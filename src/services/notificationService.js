const { Notification } = require('../models');

const createNotification = async (userId, title, message, type = 'system', data = null) => {
  return Notification.create({ userId, title, message, type, data });
};

const notifyOrderStatus = async (userId, orderId, status) => {
  const statusMessages = {
    confirmed: 'Siparişiniz onaylandı! Teslim alma saatinde hazır olacak.',
    picked_up: 'Siparişiniz teslim alındı. Afiyet olsun!',
    cancelled: 'Siparişiniz iptal edildi.',
  };

  return createNotification(
    userId,
    'Sipariş Durumu',
    statusMessages[status] || `Sipariş durumu güncellendi: ${status}`,
    'order_status',
    { orderId, status }
  );
};

const notifyNewPackage = async (userId, businessName, packageTitle) => {
  return createNotification(
    userId,
    'Yeni Sürpriz Paket',
    `${businessName} yeni bir sürpriz paket ekledi: ${packageTitle}`,
    'new_package',
    { businessName, packageTitle }
  );
};

// İşletme sahibine yeni sipariş bildirimi
const notifyNewOrder = async (businessOwnerId, businessName, orderDetails) => {
  return createNotification(
    businessOwnerId,
    'Yeni Sipariş',
    `${businessName} işletmenize yeni bir sipariş geldi. Teslim alma kodu: ${orderDetails.pickupCode}`,
    'order_status',
    { 
      orderId: orderDetails.orderId,
      packageTitle: orderDetails.packageTitle,
      pickupCode: orderDetails.pickupCode,
      totalPrice: orderDetails.totalPrice,
    }
  );
};

module.exports = {
  createNotification,
  notifyOrderStatus,
  notifyNewPackage,
  notifyNewOrder,
};
