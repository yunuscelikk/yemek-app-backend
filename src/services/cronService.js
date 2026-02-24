const cron = require('node-cron');
const { Notification } = require('../models');
const { Op } = require('sequelize');

// Her gün gece 3'te çalıştır
const startNotificationCleanupJob = () => {
  cron.schedule('0 3 * * *', async () => {
    try {
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

      const deletedCount = await Notification.destroy({
        where: {
          isRead: true,
          createdAt: { [Op.lt]: thirtyDaysAgo },
        },
      });

      console.log(`${deletedCount} eski bildirim silindi`);
    } catch (error) {
      console.error('Bildirim temizleme hatası:', error);
    }
  });

  console.log('Bildirim temizleme jobu başlatıldı');
};

module.exports = { startNotificationCleanupJob };
