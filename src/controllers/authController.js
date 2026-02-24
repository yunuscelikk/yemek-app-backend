const jwt = require('jsonwebtoken');
const { Op } = require('sequelize');
const { User } = require('../models');
const { generateToken } = require('../utils/helpers');
const { sendVerificationEmail, sendPasswordResetEmail } = require('../services/emailService');

const generateTokens = (user) => {
  const accessToken = jwt.sign(
    { id: user.id, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN }
  );

  const refreshToken = jwt.sign(
    { id: user.id },
    process.env.JWT_REFRESH_SECRET,
    { expiresIn: process.env.JWT_REFRESH_EXPIRES_IN }
  );

  return { accessToken, refreshToken };
};

exports.register = async (req, res, next) => {
  try {
    const { name, email, password, phone, role } = req.body;

    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(409).json({ message: 'Bu e-posta adresi zaten kayıtlı' });
    }

    const user = await User.create({ name, email, password, phone, role });
    
    // Send verification email
    const verificationToken = generateToken();
    await user.update({ emailVerificationToken: verificationToken });
    await sendVerificationEmail(email, verificationToken);
    
    const tokens = generateTokens(user);

    res.status(201).json({
      message: 'Kayıt başarılı. Lütfen e-postanızı doğrulayın.',
      user,
      ...tokens,
    });
  } catch (error) {
    next(error);
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(401).json({ message: 'E-posta veya şifre hatalı' });
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({ message: 'E-posta veya şifre hatalı' });
    }

    if (!user.isEmailVerified) {
      return res.status(403).json({ message: 'Lütfen önce e-posta adresinizi doğrulayın' });
    }

    const tokens = generateTokens(user);

    res.json({
      message: 'Giriş başarılı',
      user,
      ...tokens,
    });
  } catch (error) {
    next(error);
  }
};

exports.refreshToken = async (req, res, next) => {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken) {
      return res.status(400).json({ message: 'Refresh token gerekli' });
    }

    const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
    const user = await User.findByPk(decoded.id);
    if (!user) {
      return res.status(401).json({ message: 'Kullanıcı bulunamadı' });
    }

    const tokens = generateTokens(user);

    res.json({
      message: 'Token yenilendi',
      ...tokens,
    });
  } catch (error) {
    return res.status(401).json({ message: 'Geçersiz refresh token' });
  }
};

// Email Verification
exports.verifyEmail = async (req, res, next) => {
  try {
    const { token } = req.query;
    
    if (!token) {
      return res.status(400).json({ message: 'Token gerekli' });
    }

    const user = await User.findOne({ where: { emailVerificationToken: token } });
    if (!user) {
      return res.status(400).json({ message: 'Geçersiz veya süresi dolmuş token' });
    }

    await user.update({ 
      isEmailVerified: true, 
      emailVerificationToken: null 
    });

    res.json({ message: 'E-posta adresiniz başarıyla doğrulandı' });
  } catch (error) {
    next(error);
  }
};

// Resend verification email
exports.resendVerification = async (req, res, next) => {
  try {
    const { email } = req.body;
    
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: 'Kullanıcı bulunamadı' });
    }

    if (user.isEmailVerified) {
      return res.status(400).json({ message: 'E-posta adresiniz zaten doğrulanmış' });
    }

    const verificationToken = generateToken();
    await user.update({ emailVerificationToken: verificationToken });
    await sendVerificationEmail(email, verificationToken);

    res.json({ message: 'Doğrulama e-postası tekrar gönderildi' });
  } catch (error) {
    next(error);
  }
};

// Forgot Password
exports.forgotPassword = async (req, res, next) => {
  try {
    const { email } = req.body;
    
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: 'Bu e-posta adresiyle kayıtlı kullanıcı bulunamadı' });
    }

    const resetToken = generateToken();
    const resetExpires = new Date(Date.now() + 60 * 60 * 1000); // 1 hour

    await user.update({ 
      passwordResetToken: resetToken, 
      passwordResetExpires: resetExpires 
    });

    await sendPasswordResetEmail(email, resetToken);

    res.json({ message: 'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi' });
  } catch (error) {
    next(error);
  }
};

// Reset Password
exports.resetPassword = async (req, res, next) => {
  try {
    const { token, password } = req.body;
    
    if (!token || !password) {
      return res.status(400).json({ message: 'Token ve şifre gerekli' });
    }

    const user = await User.findOne({ 
      where: { 
        passwordResetToken: token,
        passwordResetExpires: { [Op.gt]: new Date() }
      } 
    });

    if (!user) {
      return res.status(400).json({ message: 'Geçersiz veya süresi dolmuş token' });
    }

    await user.update({ 
      password,
      passwordResetToken: null,
      passwordResetExpires: null
    });

    res.json({ message: 'Şifreniz başarıyla değiştirildi' });
  } catch (error) {
    next(error);
  }
};
