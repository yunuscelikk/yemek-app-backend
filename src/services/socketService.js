const { Server } = require('socket.io');
const logger = require('./logger');

let io = null;

const initSocket = (server) => {
  io = new Server(server, {
    cors: {
      origin: process.env.CORS_ORIGIN || '*',
      methods: ['GET', 'POST'],
    },
  });

  io.on('connection', (socket) => {
    logger.info(`Socket bağlandı: ${socket.id}`);

    socket.on('join_user', (userId) => {
      socket.join(`user_${userId}`);
    });

    socket.on('join_business', (businessId) => {
      socket.join(`business_${businessId}`);
    });

    socket.on('disconnect', () => {
      logger.info(`Socket ayrıldı: ${socket.id}`);
    });
  });

  return io;
};

const getIO = () => io;

const emitStockUpdate = (packageId, remainingQuantity) => {
  if (io) {
    io.emit('stock_update', { packageId, remainingQuantity });
  }
};

const emitOrderUpdate = (userId, order) => {
  if (io) {
    io.to(`user_${userId}`).emit('order_update', order);
  }
};

const emitNewPackage = (businessId, pkg) => {
  if (io) {
    io.emit('new_package', { businessId, package: pkg });
  }
};

const emitNotification = (userId, notification) => {
  if (io) {
    io.to(`user_${userId}`).emit('notification', notification);
  }
};

module.exports = {
  initSocket,
  getIO,
  emitStockUpdate,
  emitOrderUpdate,
  emitNewPackage,
  emitNotification,
};
