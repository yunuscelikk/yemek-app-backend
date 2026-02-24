const router = require('express').Router();
const notificationController = require('../controllers/notificationController');
const { authenticate } = require('../middlewares/auth');
const { validateQuery, validateParams } = require('../middlewares/validate');
const { paginationSchema, idParamSchema } = require('../validations/schemas');

/**
 * @swagger
 * tags:
 *   name: Notifications
 *   description: Bildirim işlemleri
 */

/**
 * @swagger
 * /notifications:
 *   get:
 *     summary: Bildirimlerimi listele
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Bildirim listesi
 */
router.get('/', authenticate, validateQuery(paginationSchema), notificationController.getAll);

/**
 * @swagger
 * /notifications/unread-count:
 *   get:
 *     summary: Okunmamış bildirim sayısı
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Okunmamış bildirim sayısı
 */
router.get('/unread-count', authenticate, notificationController.getUnreadCount);

/**
 * @swagger
 * /notifications/mark-all-read:
 *   patch:
 *     summary: Tüm bildirimleri okundu işaretle
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Tüm bildirimler okundu
 */
router.patch('/mark-all-read', authenticate, notificationController.markAllAsRead);

/**
 * @swagger
 * /notifications/{id}/read:
 *   patch:
 *     summary: Bildirimi okundu işaretle
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     responses:
 *       200:
 *         description: Bildirim okundu
 *       404:
 *         description: Bildirim bulunamadı
 */
router.patch('/:id/read', authenticate, validateParams(idParamSchema), notificationController.markAsRead);

/**
 * @swagger
 * /notifications/{id}:
 *   delete:
 *     summary: Bildirimi sil
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     responses:
 *       200:
 *         description: Bildirim silindi
 *       404:
 *         description: Bildirim bulunamadı
 */
router.delete('/:id', authenticate, validateParams(idParamSchema), notificationController.delete);

module.exports = router;
