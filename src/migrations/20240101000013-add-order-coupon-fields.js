'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('Orders', 'couponId', {
      type: Sequelize.UUID,
      allowNull: true,
      references: { model: 'Coupons', key: 'id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
    });
    await queryInterface.addColumn('Orders', 'discountAmount', {
      type: Sequelize.DECIMAL(10, 2),
      defaultValue: 0,
    });
    await queryInterface.addColumn('Orders', 'finalPrice', {
      type: Sequelize.DECIMAL(10, 2),
      allowNull: true,
    });
    await queryInterface.addColumn('Orders', 'deletedAt', {
      type: Sequelize.DATE,
      allowNull: true,
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('Orders', 'couponId');
    await queryInterface.removeColumn('Orders', 'discountAmount');
    await queryInterface.removeColumn('Orders', 'finalPrice');
    await queryInterface.removeColumn('Orders', 'deletedAt');
  },
};
