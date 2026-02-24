const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const BusinessHours = sequelize.define('BusinessHours', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  businessId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: { model: 'Businesses', key: 'id' },
  },
  dayOfWeek: {
    type: DataTypes.INTEGER,
    allowNull: false,
    validate: { min: 0, max: 6 },
  },
  openTime: {
    type: DataTypes.TIME,
    allowNull: false,
  },
  closeTime: {
    type: DataTypes.TIME,
    allowNull: false,
  },
  isClosed: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
}, {
  timestamps: true,
  indexes: [
    { unique: true, fields: ['businessId', 'dayOfWeek'] },
  ],
});

module.exports = BusinessHours;
