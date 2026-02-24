const errorHandler = (err, req, res, next) => {
  console.error(err.stack);

  if (err.name === 'SequelizeValidationError') {
    const messages = err.errors.map((e) => e.message);
    return res.status(400).json({ message: 'Doğrulama hatası', errors: messages });
  }

  if (err.name === 'SequelizeUniqueConstraintError') {
    return res.status(409).json({ message: 'Bu kayıt zaten mevcut' });
  }

  res.status(err.statusCode || 500).json({
    message: err.message || 'Sunucu hatası',
  });
};

module.exports = errorHandler;
