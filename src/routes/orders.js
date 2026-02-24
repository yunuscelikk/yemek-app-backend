const router = require('express').Router();
const orderController = require('../controllers/orderController');
const { authenticate } = require('../middlewares/auth');
const { validate, validateQuery, validateParams } = require('../middlewares/validate');
const { orderSchema, orderStatusSchema, paginationSchema, idParamSchema } = require('../validations/schemas');

/**
 * @swagger
 * tags:
 *   name: Orders
 *   description: Sipariş işlemleri
 */

/**
 * @swagger
 * /orders:
 *   post:
 *     summary: Yeni sipariş oluştur
 *     tags: [Orders]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - packageId
 *             properties:
 *               packageId:
 *                 type: string
 *                 format: uuid
 *               quantity:
 *                 type: integer
 *                 default: 1
 *               couponCode:
 *                 type: string
 *                 example: "INDIRIM20"
 *     responses:
 *       201:
 *         description: Sipariş oluşturuldu
 *       400:
 *         description: Yetersiz stok veya geçersiz kupon
 *       404:
 *         description: Paket bulunamadı
 */
router.post('/', authenticate, validate(orderSchema), orderController.create);

/**
 * @swagger
 * /orders:
 *   get:
 *     summary: Siparişlerimi listele
 *     tags: [Orders]
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
 *         description: Sipariş listesi
 */
router.get('/', authenticate, validateQuery(paginationSchema), orderController.getAll);

/**
 * @swagger
 * /orders/{id}:
 *   get:
 *     summary: Sipariş detayı getir
 *     tags: [Orders]
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
 *         description: Sipariş detayı
 *       403:
 *         description: Yetkisiz erişim
 *       404:
 *         description: Sipariş bulunamadı
 */
router.get('/:id', authenticate, validateParams(idParamSchema), orderController.getById);

/**
 * @swagger
 * /orders/{id}/status:
 *   patch:
 *     summary: Sipariş durumu güncelle
 *     tags: [Orders]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - status
 *             properties:
 *               status:
 *                 type: string
 *                 enum: [pending, confirmed, picked_up, cancelled]
 *     responses:
 *       200:
 *         description: Durum güncellendi
 *       403:
 *         description: Yetkisiz işlem
 *       404:
 *         description: Sipariş bulunamadı
 */
router.patch('/:id/status', authenticate, validateParams(idParamSchema), validate(orderStatusSchema), orderController.updateStatus);

/**
 * @swagger
 * /orders/{id}/cancel:
 *   patch:
 *     summary: Sipariş iptal et
 *     tags: [Orders]
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
 *         description: Sipariş iptal edildi
 *       400:
 *         description: Teslim alınmış sipariş iptal edilemez
 *       403:
 *         description: Yetkisiz işlem
 *       404:
 *         description: Sipariş bulunamadı
 */
router.patch('/:id/cancel', authenticate, validateParams(idParamSchema), orderController.cancel);

module.exports = router;
