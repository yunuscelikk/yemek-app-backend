'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // Orders indexes
    await queryInterface.addIndex('Orders', ['userId'], {
      name: 'idx_orders_userId',
    });
    await queryInterface.addIndex('Orders', ['packageId'], {
      name: 'idx_orders_packageId',
    });
    await queryInterface.addIndex('Orders', ['status'], {
      name: 'idx_orders_status',
    });

    // Reviews indexes
    await queryInterface.addIndex('Reviews', ['businessId'], {
      name: 'idx_reviews_businessId',
    });
    await queryInterface.addIndex('Reviews', ['userId'], {
      name: 'idx_reviews_userId',
    });

    // SurprisePackages indexes
    await queryInterface.addIndex('SurprisePackages', ['businessId'], {
      name: 'idx_surprisepackages_businessId',
    });

    // Businesses indexes
    await queryInterface.addIndex('Businesses', ['ownerId'], {
      name: 'idx_businesses_ownerId',
    });
    await queryInterface.addIndex('Businesses', ['categoryId'], {
      name: 'idx_businesses_categoryId',
    });

    // Notifications indexes
    await queryInterface.addIndex('Notifications', ['userId'], {
      name: 'idx_notifications_userId',
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeIndex('Orders', 'idx_orders_userId');
    await queryInterface.removeIndex('Orders', 'idx_orders_packageId');
    await queryInterface.removeIndex('Orders', 'idx_orders_status');
    await queryInterface.removeIndex('Reviews', 'idx_reviews_businessId');
    await queryInterface.removeIndex('Reviews', 'idx_reviews_userId');
    await queryInterface.removeIndex('SurprisePackages', 'idx_surprisepackages_businessId');
    await queryInterface.removeIndex('Businesses', 'idx_businesses_ownerId');
    await queryInterface.removeIndex('Businesses', 'idx_businesses_categoryId');
    await queryInterface.removeIndex('Notifications', 'idx_notifications_userId');
  },
};
