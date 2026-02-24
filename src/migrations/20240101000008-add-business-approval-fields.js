'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('Businesses', 'isApproved', {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    });
    await queryInterface.addColumn('Businesses', 'approvalStatus', {
      type: Sequelize.ENUM('pending', 'approved', 'rejected'),
      defaultValue: 'pending',
    });
    await queryInterface.addColumn('Businesses', 'deletedAt', {
      type: Sequelize.DATE,
      allowNull: true,
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('Businesses', 'isApproved');
    await queryInterface.removeColumn('Businesses', 'approvalStatus');
    await queryInterface.removeColumn('Businesses', 'deletedAt');
    await queryInterface.sequelize.query('DROP TYPE IF EXISTS "enum_Businesses_approvalStatus";');
  },
};
