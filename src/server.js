require("dotenv").config();

const logger = require("./services/logger");

const app = require("./app");
const { sequelize } = require("./models");
const { startNotificationCleanupJob } = require("./services/cronService");

const PORT = process.env.PORT || 3000;

const requiredEnvVars = ['DB_HOST', 'DB_PORT', 'DB_NAME', 'DB_USER', 'DB_PASSWORD', 'JWT_SECRET', 'JWT_REFRESH_SECRET'];

const validateEnv = () => {
  const missing = requiredEnvVars.filter(v => !process.env[v]);
  if (missing.length > 0) {
    throw new Error(`Missing required environment variables: ${missing.join(', ')}`);
  }
  if (process.env.NODE_ENV === 'production' && 
      (process.env.JWT_SECRET === 'your_jwt_secret_key_here' || process.env.JWT_SECRET.length < 32)) {
    throw new Error('JWT_SECRET must be a secure value (min 32 chars) in production');
  }
};

const start = async () => {
  validateEnv();
  try {
    await sequelize.authenticate();
    logger.info("PostgreSQL bağlantısı başarılı");

    logger.info("Veritabanı bağlantısı hazır");

    // Cron job'ları başlat
    startNotificationCleanupJob();

    app.listen(PORT, () => {
      logger.info(`Sunucu http://localhost:${PORT} adresinde çalışıyor`);
    });
  } catch (error) {
    logger.error("Sunucu başlatılamadı:", { error: error.message });
    process.exit(1);
  }
};

start();

process.on('unhandledRejection', (reason, promise) => {
  logger.error('Unhandled Rejection at:', { promise, reason: reason?.message || reason });
});

process.on('uncaughtException', (error) => {
  logger.error('Uncaught Exception:', { error: error.message, stack: error.stack });
  process.exit(1);
});
