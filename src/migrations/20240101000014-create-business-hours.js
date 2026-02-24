'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('BusinessHours', {
      id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.UUIDV4,
        primaryKey: true,
      },
      businessId: {
        type: Sequelize.UUID,
        allowNull: false,
        references: { model: 'Businesses', key: 'id' },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE',
      },
      dayOfWeek: { type: Sequelize.INTEGER, allowNull: false },
      openTime: { type: Sequelize.TIME, allowNull: false },
      closeTime: { type: Sequelize.TIME, allowNull: false },
      isClosed: { type: Sequelize.BOOLEAN, defaultValue: false },
      createdAt: { type: Sequelize.DATE, allowNull: false },
      updatedAt: { type: Sequelize.DATE, allowNull: false },
    });
    await queryInterface.addIndex('BusinessHours', ['businessId', 'dayOfWeek'], { unique: true });
  },

  async down(queryInterface) {
    await queryInterface.dropTable('BusinessHours');
  },
};
