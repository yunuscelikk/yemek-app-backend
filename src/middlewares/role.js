const authorize = (...roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ message: 'Önce giriş yapmalısınız' });
    }

    if (!roles.includes(req.user.role)) {
      return res.status(403).json({ message: 'Bu işlem için yetkiniz yok' });
    }

    next();
  };
};

module.exports = { authorize };
