'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('Users', 'isEmailVerified', {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    });
    await queryInterface.addColumn('Users', 'emailVerificationToken', {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn('Users', 'passwordResetToken', {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn('Users', 'passwordResetExpires', {
      type: Sequelize.DATE,
      allowNull: true,
    });
    await queryInterface.addColumn('Users', 'deletedAt', {
      type: Sequelize.DATE,
      allowNull: true,
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('Users', 'isEmailVerified');
    await queryInterface.removeColumn('Users', 'emailVerificationToken');
    await queryInterface.removeColumn('Users', 'passwordResetToken');
    await queryInterface.removeColumn('Users', 'passwordResetExpires');
    await queryInterface.removeColumn('Users', 'deletedAt');
  },
};
