const { Business, Category, User, Review } = require('../models');
const { Op } = require('sequelize');
const { paginate, paginatedResponse, haversineDistance } = require('../utils/helpers');

exports.getAll = async (req, res, next) => {
  try {
    const { city, district, categoryId, search, lat, lng, radius } = req.query;
    const { page, limit, offset } = paginate(req.query);

    const where = { isActive: true, isApproved: true };
    if (city) where.city = city;
    if (district) where.district = district;
    if (categoryId) where.categoryId = categoryId;
    if (search) where.name = { [Op.iLike]: `%${search}%` };

    const { count, rows: businesses } = await Business.findAndCountAll({
      where,
      include: [
        { model: Category, as: 'category', attributes: ['id', 'name', 'slug'] },
      ],
      order: [['createdAt', 'DESC']],
      limit,
      offset,
    });

    let resultBusinesses = businesses;

    // Mesafe bazlı filtreleme
    if (lat && lng && radius) {
      const userLat = parseFloat(lat);
      const userLng = parseFloat(lng);
      const maxRadius = parseFloat(radius); // km

      resultBusinesses = businesses.filter(business => {
        if (!business.latitude || !business.longitude) return false;
        const distance = haversineDistance(
          userLat,
          userLng,
          parseFloat(business.latitude),
          parseFloat(business.longitude)
        );
        business.setDataValue('distance', distance);
        return distance <= maxRadius;
      });

      // Mesafeye göre sırala
      resultBusinesses.sort((a, b) => a.getDataValue('distance') - b.getDataValue('distance'));
    }

    res.json(paginatedResponse(resultBusinesses, count, page, limit));
  } catch (error) {
    next(error);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const business = await Business.findByPk(req.params.id, {
      include: [
        { model: Category, as: 'category', attributes: ['id', 'name', 'slug'] },
        { model: User, as: 'owner', attributes: ['id', 'name', 'email'] },
        { model: Review, as: 'reviews', include: [{ model: User, as: 'user', attributes: ['id', 'name'] }] },
      ],
    });

    if (!business) {
      return res.status(404).json({ message: 'İşletme bulunamadı' });
    }

    res.json({ business });
  } catch (error) {
    next(error);
  }
};

exports.create = async (req, res, next) => {
  try {
    const { name, description, address, city, district, latitude, longitude, phone, imageUrl, categoryId } = req.body;

    const business = await Business.create({
      ownerId: req.user.id,
      categoryId,
      name,
      description,
      address,
      city,
      district,
      latitude,
      longitude,
      phone,
      imageUrl,
    });

    res.status(201).json({
      message: 'İşletme oluşturuldu',
      business,
    });
  } catch (error) {
    next(error);
  }
};

exports.update = async (req, res, next) => {
  try {
    const business = await Business.findByPk(req.params.id);

    if (!business) {
      return res.status(404).json({ message: 'İşletme bulunamadı' });
    }

    if (business.ownerId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Bu işletmeyi güncelleme yetkiniz yok' });
    }

    const { name, description, address, city, district, latitude, longitude, phone, imageUrl, categoryId, isActive } = req.body;

    await business.update({
      name, description, address, city, district,
      latitude, longitude, phone, imageUrl, categoryId, isActive,
    });

    res.json({
      message: 'İşletme güncellendi',
      business,
    });
  } catch (error) {
    next(error);
  }
};

exports.remove = async (req, res, next) => {
  try {
    const business = await Business.findByPk(req.params.id);

    if (!business) {
      return res.status(404).json({ message: 'İşletme bulunamadı' });
    }

    if (business.ownerId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Bu işletmeyi silme yetkiniz yok' });
    }

    await business.destroy();

    res.json({ message: 'İşletme silindi' });
  } catch (error) {
    next(error);
  }
};
