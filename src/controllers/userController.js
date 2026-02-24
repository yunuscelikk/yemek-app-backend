const { User } = require('../models');

exports.getProfile = async (req, res, next) => {
  try {
    res.json({ user: req.user });
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
