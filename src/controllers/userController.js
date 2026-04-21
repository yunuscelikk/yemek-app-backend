const { User, Order, Review, Favorite, Business, SurprisePackage } = require('../models');

exports.getProfile = async (req, res, next) => {
  try {
    res.json({ user: req.user });
  } catch (error) {
    next(error);
  }
};

exports.deleteAccount = async (req, res, next) => {
  try {
    const userId = req.user.id;

    // Cancel pending orders
    await Order.update(
      { status: 'cancelled' },
      { where: { userId, status: ['pending', 'confirmed'] } }
    );

    // Remove favorites
    await Favorite.destroy({ where: { userId } });

    // Soft-delete the user (paranoid mode)
    await req.user.destroy();

    res.json({ message: 'Hesabınız başarıyla silindi' });
  } catch (error) {
    next(error);
  }
};

exports.updateProfile = async (req, res, next) => {
  try {
    const { name, phone, latitude, longitude } = req.body;

    await req.user.update({ name, phone, latitude, longitude });

    res.json({
      message: 'Profil güncellendi',
      user: req.user,
    });
  } catch (error) {
    next(error);
  }
};
