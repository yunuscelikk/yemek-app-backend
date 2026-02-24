const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Notification = sequelize.define('Notification', {
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
  title: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  message: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  type: {
    type: DataTypes.ENUM('order_status', 'new_package', 'promotion', 'system'),
    defaultValue: 'system',
  },
  isRead: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  data: {
    type: DataTypes.JSONB,
    allowNull: true,
  },
}, {
  timestamps: true,
});

module.exports = Notification;
