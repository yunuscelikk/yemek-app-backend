const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Favorite = sequelize.define('Favorite', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: { model: 'Users', key: 'id' },
  },
  businessId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: { model: 'Businesses', key: 'id' },
  },
}, {
  timestamps: true,
  indexes: [
    { unique: true, fields: ['userId', 'businessId'] },
  ],
});

module.exports = Favorite;
