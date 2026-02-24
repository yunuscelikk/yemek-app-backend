require("dotenv").config();

const app = require("./app");
const { sequelize } = require("./models");
const { startNotificationCleanupJob } = require("./services/cronService");

const PORT = process.env.PORT || 3000;

const start = async () => {
  try {
    await sequelize.authenticate();
    console.log("PostgreSQL bağlantısı başarılı");

    console.log("Veritabanı bağlantısı hazır");

    // Cron job'ları başlat
    startNotificationCleanupJob();

    app.listen(PORT, () => {
      console.log(`Sunucu http://localhost:${PORT} adresinde çalışıyor`);
    });
  } catch (error) {
    console.error("Sunucu başlatılamadı:", error.message);
    process.exit(1);
  }
};

start();
