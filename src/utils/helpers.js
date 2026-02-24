const crypto = require('crypto');
const { Order } = require('../models');

const generatePickupCode = async () => {
  const maxAttempts = 10;
  let attempts = 0;
  
  while (attempts < maxAttempts) {
    const code = Math.floor(1000 + Math.random() * 9000).toString();
    
    // Kodun benzersiz olduğunu kontrol et
    const existingOrder = await Order.findOne({ where: { pickupCode: code } });
    if (!existingOrder) {
      return code;
    }
    
    attempts++;
  }
  
  // 10 denemeden sonra hata fırlat
  throw new Error('Benzersiz teslim alma kodu oluşturulamadı');
};

const paginate = (query) => {
  const page = Math.max(1, parseInt(query.page) || 1);
  const limit = Math.min(50, Math.max(1, parseInt(query.limit) || 10));
  const offset = (page - 1) * limit;
  return { page, limit, offset };
};

const paginatedResponse = (data, count, page, limit) => ({
  data,
  pagination: {
    total: count,
    page,
    limit,
    totalPages: Math.ceil(count / limit),
  },
});

const haversineDistance = (lat1, lon1, lat2, lon2) => {
  const R = 6371;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
    Math.cos((lat2 * Math.PI) / 180) *
    Math.sin(dLon / 2) *
    Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
};

const generateToken = () => {
  return crypto.randomBytes(32).toString('hex');
};

const getSortOptions = (query, allowedFields) => {
  const sortBy = allowedFields.includes(query.sortBy) ? query.sortBy : 'createdAt';
  const sortOrder = query.sortOrder === 'ASC' ? 'ASC' : 'DESC';
  return [[sortBy, sortOrder]];
};

module.exports = {
  generatePickupCode,
  paginate,
  paginatedResponse,
  haversineDistance,
  generateToken,
  getSortOptions,
};
