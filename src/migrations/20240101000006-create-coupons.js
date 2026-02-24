'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Coupons', {
      id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.UUIDV4,
        primaryKey: true,
      },
      code: { type: Sequelize.STRING, allowNull: false, unique: true },
      discountType: {
        type: Sequelize.ENUM('percentage', 'fixed'),
        allowNull: false,
      },
      discountValue: { type: Sequelize.DECIMAL(10, 2), allowNull: false },
      minOrderAmount: { type: Sequelize.DECIMAL(10, 2), defaultValue: 0 },
      maxUsage: { type: Sequelize.INTEGER, allowNull: false, defaultValue: 100 },
      currentUsage: { type: Sequelize.INTEGER, defaultValue: 0 },
      expiresAt: { type: Sequelize.DATE, allowNull: false },
      isActive: { type: Sequelize.BOOLEAN, defaultValue: true },
      createdAt: { type: Sequelize.DATE, allowNull: false },
      updatedAt: { type: Sequelize.DATE, allowNull: false },
    });
  },

  async down(queryInterface) {
    await queryInterface.dropTable('Coupons');
  },
};
