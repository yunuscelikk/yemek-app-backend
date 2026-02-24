const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Coupon = sequelize.define('Coupon', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  code: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  discountType: {
    type: DataTypes.ENUM('percentage', 'fixed'),
    allowNull: false,
  },
  discountValue: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
  },
  minOrderAmount: {
    type: DataTypes.DECIMAL(10, 2),
    defaultValue: 0,
  },
  maxUsage: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 100,
  },
  currentUsage: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  expiresAt: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
}, {
  timestamps: true,
});

module.exports = Coupon;
