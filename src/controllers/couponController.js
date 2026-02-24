const { Coupon, Order } = require('../models');
const { Op, Sequelize } = require('sequelize');
const { paginate, paginatedResponse } = require('../utils/helpers');

exports.getAll = async (req, res, next) => {
  try {
    const { page, limit, offset } = paginate(req.query);
    const { active } = req.query;

    const where = {};
    if (active === 'true') {
      where.isActive = true;
      where.expiresAt = { [Op.gt]: new Date() };
      where.currentUsage = { [Op.lt]: Sequelize.col('maxUsage') };
    }

    const { count, rows: coupons } = await Coupon.findAndCountAll({
      where,
      order: [['createdAt', 'DESC']],
      limit,
      offset,
    });

    res.json(paginatedResponse(coupons, count, page, limit));
  } catch (error) {
    next(error);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const coupon = await Coupon.findByPk(req.params.id);

    if (!coupon) {
      return res.status(404).json({ message: 'Kupon bulunamadı' });
    }

    res.json({ coupon });
  } catch (error) {
    next(error);
  }
};

exports.validate = async (req, res, next) => {
  try {
    const { code, orderAmount } = req.body;

    const coupon = await Coupon.findOne({
      where: {
        code: code.toUpperCase(),
        isActive: true,
        expiresAt: { [Op.gt]: new Date() },
      },
    });

    if (!coupon) {
      return res.status(404).json({ message: 'Geçersiz kupon kodu' });
    }

    if (coupon.currentUsage >= coupon.maxUsage) {
      return res.status(400).json({ message: 'Kupon kullanım limiti dolmuş' });
    }

    if (orderAmount && parseFloat(orderAmount) < parseFloat(coupon.minOrderAmount)) {
      return res.status(400).json({
        message: `Bu kupon minimum ${coupon.minOrderAmount} TL siparişte geçerlidir`,
      });
    }

    let discountAmount = 0;
    const parsedOrderAmount = parseFloat(orderAmount) || 0;
    if (coupon.discountType === 'percentage') {
      discountAmount = (parsedOrderAmount * parseFloat(coupon.discountValue)) / 100;
    } else {
      discountAmount = parseFloat(coupon.discountValue);
    }

    res.json({
      valid: true,
      coupon,
      discountAmount: Math.round(discountAmount * 100) / 100,
    });
  } catch (error) {
    next(error);
  }
};

// Admin only
exports.create = async (req, res, next) => {
  try {
    const {
      code,
      discountType,
      discountValue,
      minOrderAmount,
      maxUsage,
      expiresAt,
    } = req.body;

    const existing = await Coupon.findOne({
      where: { code: code.toUpperCase() },
    });

    if (existing) {
      return res.status(409).json({ message: 'Bu kupon kodu zaten kullanımda' });
    }

    const coupon = await Coupon.create({
      code: code.toUpperCase(),
      discountType,
      discountValue,
      minOrderAmount,
      maxUsage,
      expiresAt,
    });

    res.status(201).json({
      message: 'Kupon oluşturuldu',
      coupon,
    });
  } catch (error) {
    next(error);
  }
};

exports.update = async (req, res, next) => {
  try {
    const coupon = await Coupon.findByPk(req.params.id);

    if (!coupon) {
      return res.status(404).json({ message: 'Kupon bulunamadı' });
    }

    const { discountType, discountValue, minOrderAmount, maxUsage, expiresAt, isActive } = req.body;

    await coupon.update({
      discountType,
      discountValue,
      minOrderAmount,
      maxUsage,
      expiresAt,
      isActive,
    });

    res.json({
      message: 'Kupon güncellendi',
      coupon,
    });
  } catch (error) {
    next(error);
  }
};

exports.remove = async (req, res, next) => {
  try {
    const coupon = await Coupon.findByPk(req.params.id);

    if (!coupon) {
      return res.status(404).json({ message: 'Kupon bulunamadı' });
    }

    await coupon.destroy();

    res.json({ message: 'Kupon silindi' });
  } catch (error) {
    next(error);
  }
};
