const { Notification } = require('../models');
const { paginate, paginatedResponse } = require('../utils/helpers');

exports.getAll = async (req, res, next) => {
  try {
    const { page, limit, offset } = paginate(req.query);
    const { unreadOnly } = req.query;

    const where = { userId: req.user.id };
    if (unreadOnly === 'true') {
      where.isRead = false;
    }

    const { count, rows: notifications } = await Notification.findAndCountAll({
      where,
      order: [['createdAt', 'DESC']],
      limit,
      offset,
    });

    res.json(paginatedResponse(notifications, count, page, limit));
  } catch (error) {
    next(error);
  }
};

exports.getUnreadCount = async (req, res, next) => {
  try {
    const count = await Notification.count({
      where: { userId: req.user.id, isRead: false },
    });

    res.json({ count });
  } catch (error) {
    next(error);
  }
};

exports.markAsRead = async (req, res, next) => {
  try {
    const { id } = req.params;

    const notification = await Notification.findOne({
      where: { id, userId: req.user.id },
    });

    if (!notification) {
      return res.status(404).json({ message: 'Bildirim bulunamadı' });
    }

    await notification.update({ isRead: true });

    res.json({ message: 'Bildirim okundu olarak işaretlendi' });
  } catch (error) {
    next(error);
  }
};

exports.markAllAsRead = async (req, res, next) => {
  try {
    await Notification.update(
      { isRead: true },
      { where: { userId: req.user.id, isRead: false } }
    );

    res.json({ message: 'Tüm bildirimler okundu olarak işaretlendi' });
  } catch (error) {
    next(error);
  }
};

exports.delete = async (req, res, next) => {
  try {
    const { id } = req.params;

    const notification = await Notification.findOne({
      where: { id, userId: req.user.id },
    });

    if (!notification) {
      return res.status(404).json({ message: 'Bildirim bulunamadı' });
    }

    await notification.destroy();

    res.json({ message: 'Bildirim silindi' });
  } catch (error) {
    next(error);
  }
};
