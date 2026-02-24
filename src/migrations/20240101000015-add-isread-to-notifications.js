'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    const tableInfo = await queryInterface.describeTable('Notifications');
    
    if (!tableInfo.isRead) {
      await queryInterface.addColumn('Notifications', 'isRead', {
        type: Sequelize.BOOLEAN,
        defaultValue: false,
      });
    }
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('Notifications', 'isRead');
  },
};
