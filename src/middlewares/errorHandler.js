const logger = require('../services/logger');

const errorHandler = (err, req, res, next) => {
  logger.error('Request error', {
    error: err.message,
    stack: err.stack,
    statusCode: err.statusCode || 500,
    path: req.path,
    method: req.method,
  });

  if (err.name === 'SequelizeValidationError') {
    const messages = err.errors.map((e) => e.message);
    return res.status(400).json({
      success: false,
      message: 'Doğrulama hatası',
      errors: messages,
    });
  }

  if (err.name === 'SequelizeUniqueConstraintError') {
    return res.status(409).json({
      success: false,
      message: 'Bu kayıt zaten mevcut',
    });
  }

  res.status(err.statusCode || 500).json({
    success: false,
    message: err.message || 'Sunucu hatası',
  });
};

module.exports = errorHandler;
