const { Review, Order, Business, User, SurprisePackage } = require('../models');
const { paginate, paginatedResponse } = require('../utils/helpers');
const sequelize = require('../config/database');

exports.create = async (req, res, next) => {
  const t = await sequelize.transaction();

  try {
    const { orderId, rating, comment } = req.body;

    const order = await Order.findByPk(orderId, {
      include: [{ model: SurprisePackage, as: 'package' }],
      transaction: t,
    });

    if (!order) {
      await t.rollback();
      return res.status(404).json({ message: 'Sipariş bulunamadı' });
    }

    if (order.userId !== req.user.id) {
      await t.rollback();
      return res.status(403).json({ message: 'Sadece kendi siparişinizi değerlendirebilirsiniz' });
    }

    if (order.status !== 'picked_up') {
      await t.rollback();
      return res.status(400).json({ message: 'Sadece teslim alınmış siparişler değerlendirilebilir' });
    }

    const existingReview = await Review.findOne({ where: { orderId }, transaction: t });
    if (existingReview) {
      await t.rollback();
      return res.status(409).json({ message: 'Bu sipariş için zaten değerlendirme yapılmış' });
    }

    const review = await Review.create({
      userId: req.user.id,
      businessId: order.package.businessId,
      orderId,
      rating,
      comment,
    }, { transaction: t });

    // İşletme ortalama puanını güncelle
    const business = await Business.findByPk(order.package.businessId, { transaction: t });
    const reviews = await Review.findAll({ where: { businessId: business.id }, transaction: t });
    const avgRating = reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length;
    await business.update({ rating: Math.round(avgRating * 10) / 10 }, { transaction: t });

    await t.commit();

    res.status(201).json({
      message: 'Değerlendirme oluşturuldu',
      review,
    });
  } catch (error) {
    await t.rollback();
    next(error);
  }
};

exports.getByBusiness = async (req, res, next) => {
  try {
    const { page, limit, offset } = paginate(req.query);

    const { count, rows: reviews } = await Review.findAndCountAll({
      where: { businessId: req.params.businessId },
      include: [
        { model: User, as: 'user', attributes: ['id', 'name'] },
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
