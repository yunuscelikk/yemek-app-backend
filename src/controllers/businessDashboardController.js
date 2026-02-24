const { Business, SurprisePackage, Order, User, Review, Category, Notification } = require('../models');
const { Op, Sequelize } = require('sequelize');
const { paginate, paginatedResponse } = require('../utils/helpers');
const { sendNotification } = require('../services/notificationService');

// İşletme Dashboard İstatistikleri
exports.getDashboardStats = async (req, res, next) => {
  try {
    const { businessId } = req.params;

    // İşletmenin sahibi mi kontrol et
    const business = await Business.findOne({
      where: { id: businessId, ownerId: req.user.id },
    });

    if (!business) {
      return res.status(404).json({ message: 'İşletme bulunamadı veya yetkiniz yok' });
    }

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    const thisWeekStart = new Date(today);
    thisWeekStart.setDate(thisWeekStart.getDate() - 7);

    const thisMonthStart = new Date(today);
    thisMonthStart.setMonth(thisMonthStart.getMonth() - 1);

    // İşletmeye ait paket ID'lerini al
    const packages = await SurprisePackage.findAll({
      where: { businessId },
      attributes: ['id'],
    });
    const packageIds = packages.map((p) => p.id);

    // Paket yoksa boş istatistik döndür
    if (packageIds.length === 0) {
      return res.json({
        stats: {
          totalPackages: 0,
          activePackages: 0,
          todayOrders: 0,
          todayRevenue: 0,
          pendingOrders: 0,
          totalOrders: 0,
          totalRevenue: 0,
          averageRating: 0,
          weeklyRevenue: 0,
          monthlyRevenue: 0,
        },
        dailyStats: [],
      });
    }

    // İstatistikleri hesapla
    const [
      totalPackages,
      activePackages,
      todayOrders,
      todayRevenue,
      pendingOrders,
      totalOrders,
      totalRevenue,
      averageRating,
      weeklyRevenue,
      monthlyRevenue,
    ] = await Promise.all([
      // Toplam paket sayısı
      SurprisePackage.count({ where: { businessId } }),

      // Aktif paket sayısı
      SurprisePackage.count({
        where: {
          businessId,
          isActive: true,
          remainingQuantity: { [Op.gt]: 0 },
        },
      }),

      // Bugünkü siparişler
      Order.count({
        where: {
          packageId: { [Op.in]: packageIds },
          createdAt: { [Op.gte]: today },
          status: { [Op.ne]: 'cancelled' },
        },
      }),

      // Bugünkü kazanç
      Order.sum('totalPrice', {
        where: {
          packageId: { [Op.in]: packageIds },
          createdAt: { [Op.gte]: today },
          status: { [Op.ne]: 'cancelled' },
        },
      }),

      // Bekleyen siparişler
      Order.count({
        where: {
          packageId: { [Op.in]: packageIds },
          status: 'pending',
        },
      }),

      // Toplam sipariş
      Order.count({
        where: {
          packageId: { [Op.in]: packageIds },
          status: { [Op.ne]: 'cancelled' },
        },
      }),

      // Toplam kazanç
      Order.sum('totalPrice', {
        where: {
          packageId: { [Op.in]: packageIds },
          status: { [Op.ne]: 'cancelled' },
        },
      }),

      // Ortalama puan
      Review.findOne({
        where: { businessId },
        attributes: [[Sequelize.fn('AVG', Sequelize.col('rating')), 'avgRating']],
        raw: true,
      }),

      // Haftalık kazanç
      Order.sum('totalPrice', {
        where: {
          packageId: { [Op.in]: packageIds },
          createdAt: { [Op.gte]: thisWeekStart },
          status: { [Op.ne]: 'cancelled' },
        },
      }),

      // Aylık kazanç
      Order.sum('totalPrice', {
        where: {
          packageId: { [Op.in]: packageIds },
          createdAt: { [Op.gte]: thisMonthStart },
          status: { [Op.ne]: 'cancelled' },
        },
      }),
    ]);

    // Günlük sipariş grafiği için son 7 gün
    const last7Days = [];
    for (let i = 6; i >= 0; i--) {
      const date = new Date(today);
      date.setDate(date.getDate() - i);
      last7Days.push(date);
    }

    const dailyStats = await Promise.all(
      last7Days.map(async (date) => {
        const nextDate = new Date(date);
        nextDate.setDate(nextDate.getDate() + 1);

        const [orderCount, revenue] = await Promise.all([
          Order.count({
            where: {
              packageId: { [Op.in]: packageIds },
              createdAt: { [Op.gte]: date, [Op.lt]: nextDate },
              status: { [Op.ne]: 'cancelled' },
            },
          }),
          Order.sum('totalPrice', {
            where: {
              packageId: { [Op.in]: packageIds },
              createdAt: { [Op.gte]: date, [Op.lt]: nextDate },
              status: { [Op.ne]: 'cancelled' },
            },
          }),
        ]);

        return {
          date: date.toISOString().split('T')[0],
          orders: orderCount,
          revenue: revenue || 0,
        };
      })
    );

    res.json({
      stats: {
        totalPackages,
        activePackages,
        todayOrders,
        todayRevenue: todayRevenue || 0,
        pendingOrders,
        totalOrders,
        totalRevenue: totalRevenue || 0,
        averageRating: averageRating?.avgRating
          ? Math.round(parseFloat(averageRating.avgRating) * 10) / 10
          : 0,
        weeklyRevenue: weeklyRevenue || 0,
        monthlyRevenue: monthlyRevenue || 0,
      },
      dailyStats,
    });
  } catch (error) {
    next(error);
  }
};

// İşletmenin siparişlerini getir
exports.getBusinessOrders = async (req, res, next) => {
  try {
    const { businessId } = req.params;
    const { status, page, limit, offset } = paginate(req.query);

    // İşletmenin sahibi mi kontrol et
    const business = await Business.findOne({
      where: { id: businessId, ownerId: req.user.id },
    });

    if (!business) {
      return res.status(404).json({ message: 'İşletme bulunamadı veya yetkiniz yok' });
    }

    // İşletmeye ait paket ID'lerini al
    const packages = await SurprisePackage.findAll({
      where: { businessId },
      attributes: ['id'],
    });
    const packageIds = packages.map((p) => p.id);

    // Paket yoksa boş liste döndür
    if (packageIds.length === 0) {
      return res.json(paginatedResponse([], 0, page, limit));
    }

    const where = { packageId: { [Op.in]: packageIds } };
    if (status) where.status = status;

    const { count, rows: orders } = await Order.findAndCountAll({
      where,
      include: [
        {
          model: SurprisePackage,
          as: 'package',
          attributes: ['id', 'title', 'pickupDate', 'pickupStart', 'pickupEnd'],
        },
        { model: User, as: 'user', attributes: ['id', 'name', 'phone'] },
      ],
      order: [['createdAt', 'DESC']],
      limit,
      offset,
    });

    res.json(paginatedResponse(orders, count, page, limit));
  } catch (error) {
    next(error);
  }
};

// İşletmenin paketlerini getir
exports.getBusinessPackages = async (req, res, next) => {
  try {
    const { businessId } = req.params;
    const { page, limit, offset } = paginate(req.query);

    // İşletmenin sahibi mi kontrol et
    const business = await Business.findOne({
      where: { id: businessId, ownerId: req.user.id },
    });

    if (!business) {
      return res.status(404).json({ message: 'İşletme bulunamadı veya yetkiniz yok' });
    }

    const { count, rows: packages } = await SurprisePackage.findAndCountAll({
      where: { businessId },
      include: [
        {
          model: Order,
          as: 'orders',
          where: { status: { [Op.ne]: 'cancelled' } },
          required: false,
          attributes: ['id', 'status', 'totalPrice'],
        },
      ],
      order: [['createdAt', 'DESC']],
      limit,
      offset,
    });

    // Her paket için satış istatistikleri ekle
    const packagesWithStats = packages.map((pkg) => {
      const pkgData = pkg.toJSON();
      const soldQuantity = pkgData.orders?.length || 0;
      const totalRevenue = pkgData.orders?.reduce((sum, o) => sum + parseFloat(o.totalPrice), 0) || 0;

      return {
        ...pkgData,
        soldQuantity,
        totalRevenue,
        remainingQuantity: pkgData.remainingQuantity,
      };
    });

    res.json(paginatedResponse(packagesWithStats, count, page, limit));
  } catch (error) {
    next(error);
  }
};

// İşletmenin değerlendirmelerini getir
exports.getBusinessReviews = async (req, res, next) => {
  try {
    const { businessId } = req.params;
    const { page, limit, offset } = paginate(req.query);

    // İşletmenin sahibi mi kontrol et
    const business = await Business.findOne({
      where: { id: businessId, ownerId: req.user.id },
    });

    if (!business) {
      return res.status(404).json({ message: 'İşletme bulunamadı veya yetkiniz yok' });
    }

    const { count, rows: reviews } = await Review.findAndCountAll({
      where: { businessId },
      include: [
        { model: User, as: 'user', attributes: ['id', 'name'] },
        { model: Order, as: 'order', attributes: ['id', 'createdAt'] },
      ],
      order: [['createdAt', 'DESC']],
      limit,
      offset,
    });

    res.json(paginatedResponse(reviews, count, page, limit));
  } catch (error) {
    next(error);
  }
};

// QR Kod ile sipariş doğrulama
exports.verifyOrderByPickupCode = async (req, res, next) => {
  try {
    const { businessId } = req.params;
    const { pickupCode } = req.body;

    // İşletmenin sahibi mi kontrol et
    const business = await Business.findOne({
      where: { id: businessId, ownerId: req.user.id },
    });

    if (!business) {
      return res.status(404).json({ message: 'İşletme bulunamadı veya yetkiniz yok' });
    }

    // İşletmeye ait paket ID'lerini al
    const packages = await SurprisePackage.findAll({
      where: { businessId },
      attributes: ['id'],
    });
    const packageIds = packages.map((p) => p.id);

    // Siparişi bul
    const order = await Order.findOne({
      where: {
        packageId: { [Op.in]: packageIds },
        pickupCode,
        status: { [Op.in]: ['pending', 'confirmed'] },
      },
      include: [
        {
          model: SurprisePackage,
          as: 'package',
          attributes: ['id', 'title', 'pickupDate', 'pickupStart', 'pickupEnd'],
        },
        { model: User, as: 'user', attributes: ['id', 'name', 'phone'] },
      ],
    });

    if (!order) {
      return res.status(404).json({ message: 'Sipariş bulunamadı veya kod hatalı' });
    }

    // Siparişi teslim alındı olarak işaretle
    await order.update({ status: 'picked_up' });

    // Müşteriye bildirim gönder
    await Notification.create({
      userId: order.userId,
      title: 'Sipariş Teslim Alındı',
      message: `${business.name} işletmesinden siparişiniz teslim alındı.`,
      type: 'order_status',
      data: { orderId: order.id, status: 'picked_up' },
    });

    res.json({
      message: 'Sipariş başarıyla doğrulandı ve teslim alındı',
      order,
    });
  } catch (error) {
    next(error);
  }
};

// İşletme sahibinin işletmelerini listele
exports.getMyBusinesses = async (req, res, next) => {
  try {
    const businesses = await Business.findAll({
      where: { ownerId: req.user.id },
      include: [
        { model: Category, as: 'category', attributes: ['id', 'name', 'slug'] },
        {
          model: SurprisePackage,
          as: 'packages',
          where: { isActive: true },
          required: false,
          limit: 1,
        },
      ],
      order: [['createdAt', 'DESC']],
    });

    // Her işletme için aktif paket sayısı ve onay durumu ekle
    const businessesWithStats = await Promise.all(
      businesses.map(async (business) => {
        const [activePackages, pendingOrders] = await Promise.all([
          SurprisePackage.count({
            where: {
              businessId: business.id,
              isActive: true,
              remainingQuantity: { [Op.gt]: 0 },
            },
          }),
          Order.count({
            where: {
              status: 'pending',
            },
            include: [
              {
                model: SurprisePackage,
                as: 'package',
                where: { businessId: business.id },
              },
            ],
          }),
        ]);

        return {
          ...business.toJSON(),
          activePackages,
          pendingOrders,
        };
      })
    );

    res.json({ businesses: businessesWithStats });
  } catch (error) {
    next(error);
  }
};
