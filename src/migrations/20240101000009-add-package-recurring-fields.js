'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('SurprisePackages', 'isRecurring', {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    });
    await queryInterface.addColumn('SurprisePackages', 'recurringDays', {
      type: Sequelize.ARRAY(Sequelize.INTEGER),
      allowNull: true,
    });
    await queryInterface.addColumn('SurprisePackages', 'deletedAt', {
      type: Sequelize.DATE,
      allowNull: true,
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('SurprisePackages', 'isRecurring');
    await queryInterface.removeColumn('SurprisePackages', 'recurringDays');
    await queryInterface.removeColumn('SurprisePackages', 'deletedAt');
  },
};
