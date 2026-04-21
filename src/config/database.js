const { Sequelize } = require('sequelize');

const isProduction = process.env.NODE_ENV === 'production';

const dbOptions = {
  dialect: 'postgres',
  logging: false,
  pool: {
    max: isProduction ? 10 : 20,
    min: isProduction ? 2 : 3,
    acquire: 30000,
    idle: 30000,
  },
};

// Railway provides DATABASE_URL; use it if available
if (isProduction) {
  dbOptions.dialectOptions = {
    ssl: {
      require: true,
      rejectUnauthorized: false,
    },
  };
}

const sequelize = process.env.DATABASE_URL
  ? new Sequelize(process.env.DATABASE_URL, dbOptions)
  : new Sequelize(
      process.env.DB_NAME,
      process.env.DB_USER,
      process.env.DB_PASSWORD,
      {
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        ...dbOptions,
      }
    );

module.exports = sequelize;
