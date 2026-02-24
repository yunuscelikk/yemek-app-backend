const { SurprisePackage, Business, Category, Order } = require('../models');
const { Op } = require('sequelize');
const { paginate, paginatedResponse, haversineDistance } = require('../utils/helpers');

exports.getAll = async (req, res, next) => {
  try {
    const { city, district, categoryId, maxPrice, lat, lng, radius, excludeExpired } = req.query;
    const { page, limit, offset } = paginate(req.query);

    const businessWhere = { isActive: true };
    if (city) businessWhere.city = city;
    if (district) businessWhere.district = district;
    if (categoryId) businessWhere.categoryId = categoryId;

    const packageWhere = { isActive: true, remainingQuantity: { [Op.gt]: 0 } };
    if (maxPrice) packageWhere.discountedPrice = { [Op.lte]: maxPrice };
    
    // Süresi geçmiş paketleri filtrele (varsayılan: true)
    if (excludeExpired !== 'false') {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      packageWhere.pickupDate = { [Op.gte]: today };
    }

    const { count, rows: packages } = await SurprisePackage.findAndCountAll({
      where: packageWhere,
      include: [
        {
          model: Business,
          as: 'business',
          where: businessWhere,
          attributes: ['id', 'name', 'address', 'city', 'district', 'latitude', 'longitude', 'imageUrl', 'rating'],
          include: [{ model: Category, as: 'category', attributes: ['id', 'name', 'slug'] }],
        },
      ],
      order: [['pickupDate', 'ASC'], ['pickupStart', 'ASC']],
      limit,
      offset,
    });

    let resultPackages = packages;

    // Mesafe bazlı filtreleme
    if (lat && lng && radius) {
      const userLat = parseFloat(lat);
      const userLng = parseFloat(lng);
      const maxRadius = parseFloat(radius); // km

      resultPackages = packages.filter(pkg => {
        if (!pkg.business.latitude || !pkg.business.longitude) return false;
        const distance = haversineDistance(
          userLat,
          userLng,
          parseFloat(pkg.business.latitude),
          parseFloat(pkg.business.longitude)
        );
        pkg.business.setDataValue('distance', distance);
        return distance <= maxRadius;
      });

      // Mesafeye göre sırala
      resultPackages.sort((a, b) => a.business.getDataValue('distance') - b.business.getDataValue('distance'));
    }

    res.json(paginatedResponse(resultPackages, count, page, limit));
  } catch (error) {
    next(error);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const pkg = await SurprisePackage.findByPk(req.params.id, {
      include: [
        {
          model: Business,
          as: 'business',
          include: [{ model: Category, as: 'category', attributes: ['id', 'name', 'slug'] }],
        },
      ],
    });

    if (!pkg) {
      return res.status(404).json({ message: 'Paket bulunamadı' });
    }

    res.json({ package: pkg });
  } catch (error) {
    next(error);
  }
};

exports.create = async (req, res, next) => {
  try {
    const { businessId, title, description, originalPrice, discountedPrice, quantity, pickupStart, pickupEnd, pickupDate, imageUrl } = req.body;

    const business = await Business.findByPk(businessId);
    if (!business) {
      return res.status(404).json({ message: 'İşletme bulunamadı' });
    }

    if (business.ownerId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Bu işletme için paket oluşturma yetkiniz yok' });
    }

    const pkg = await SurprisePackage.create({
      businessId,
      title,
      description,
      originalPrice,
      discountedPrice,
      quantity,
      remainingQuantity: quantity,
      pickupStart,
      pickupEnd,
      pickupDate,
      imageUrl,
    });

    res.status(201).json({
      message: 'Paket oluşturuldu',
      package: pkg,
    });
  } catch (error) {
    next(error);
  }
};

exports.update = async (req, res, next) => {
  try {
    const pkg = await SurprisePackage.findByPk(req.params.id, {
      include: [{ model: Business, as: 'business' }],
    });

    if (!pkg) {
      return res.status(404).json({ message: 'Paket bulunamadı' });
    }

    if (pkg.business.ownerId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Bu paketi güncelleme yetkiniz yok' });
    }

    const { title, description, originalPrice, discountedPrice, quantity, remainingQuantity, pickupStart, pickupEnd, pickupDate, imageUrl, isActive } = req.body;

    // remainingQuantity validasyonu
    if (remainingQuantity !== undefined && quantity !== undefined) {
      if (remainingQuantity > quantity) {
        return res.status(400).json({ message: 'Kalan miktar toplam miktardan fazla olamaz' });
      }
    } else if (remainingQuantity !== undefined) {
      if (remainingQuantity > pkg.quantity) {
        return res.status(400).json({ message: 'Kalan miktar toplam miktardan fazla olamaz' });
      }
    }

    await pkg.update({
      title, description, originalPrice, discountedPrice,
      quantity, remainingQuantity, pickupStart, pickupEnd,
      pickupDate, imageUrl, isActive,
    });

    res.json({
      message: 'Paket güncellendi',
      package: pkg,
    });
  } catch (error) {
    next(error);
  }
};

exports.remove = async (req, res, next) => {
  try {
    const pkg = await SurprisePackage.findByPk(req.params.id, {
      include: [{ model: Business, as: 'business' }],
    });

    if (!pkg) {
      return res.status(404).json({ message: 'Paket bulunamadı' });
    }

    if (pkg.business.ownerId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Bu paketi silme yetkiniz yok' });
    }

    // Aktif sipariş kontrolü
    const activeOrders = await Order.count({
      where: {
        packageId: pkg.id,
        status: { [Op.in]: ['pending', 'confirmed'] },
      },
    });

    if (activeOrders > 0) {
      return res.status(400).json({ message: 'Bu paket için aktif siparişler var, silinemez' });
    }

    await pkg.destroy();

    res.json({ message: 'Paket silindi' });
  } catch (error) {
    next(error);
  }
};
