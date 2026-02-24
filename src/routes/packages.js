const router = require('express').Router();
const packageController = require('../controllers/packageController');
const { authenticate } = require('../middlewares/auth');
const { authorize } = require('../middlewares/role');
const { validate, validateQuery, validateParams } = require('../middlewares/validate');
const { packageSchema, packageQuerySchema, idParamSchema } = require('../validations/schemas');

/**
 * @swagger
 * tags:
 *   name: Packages
 *   description: Sürpriz paket işlemleri
 */

/**
 * @swagger
 * /packages:
 *   get:
 *     summary: Tüm paketleri listele
 *     tags: [Packages]
 *     parameters:
 *       - in: query
 *         name: city
 *         schema:
 *           type: string
 *       - in: query
 *         name: district
 *         schema:
 *           type: string
 *       - in: query
 *         name: categoryId
 *         schema:
 *           type: integer
 *       - in: query
 *         name: maxPrice
 *         schema:
 *           type: number
 *       - in: query
 *         name: lat
 *         schema:
 *           type: number
 *       - in: query
 *         name: lng
 *         schema:
 *           type: number
 *       - in: query
 *         name: radius
 *         schema:
 *           type: number
 *       - in: query
 *         name: excludeExpired
 *         schema:
 *           type: string
 *           enum: ['true', 'false']
 *           default: 'true'
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
 *         description: Paket listesi
 */
router.get('/', validateQuery(packageQuerySchema), packageController.getAll);

/**
 * @swagger
 * /packages/{id}:
 *   get:
 *     summary: Paket detayı getir
 *     tags: [Packages]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     responses:
 *       200:
 *         description: Paket detayı
 *       404:
 *         description: Paket bulunamadı
 */
router.get('/:id', validateParams(idParamSchema), packageController.getById);

/**
 * @swagger
 * /packages:
 *   post:
 *     summary: Yeni paket oluştur
 *     tags: [Packages]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - businessId
 *               - title
 *               - originalPrice
 *               - discountedPrice
 *               - quantity
 *               - pickupStart
 *               - pickupEnd
 *               - pickupDate
 *             properties:
 *               businessId:
 *                 type: string
 *                 format: uuid
 *               title:
 *                 type: string
 *               description:
 *                 type: string
 *               originalPrice:
 *                 type: number
 *               discountedPrice:
 *                 type: number
 *               quantity:
 *                 type: integer
 *               pickupStart:
 *                 type: string
 *                 example: "18:00"
 *               pickupEnd:
 *                 type: string
 *                 example: "21:00"
 *               pickupDate:
 *                 type: string
 *                 format: date
 *               imageUrl:
 *                 type: string
 *     responses:
 *       201:
 *         description: Paket oluşturuldu
 *       403:
 *         description: Yetkisiz işlem
 */
router.post('/', authenticate, authorize('business_owner', 'admin'), validate(packageSchema), packageController.create);

/**
 * @swagger
 * /packages/{id}:
 *   put:
 *     summary: Paket güncelle
 *     tags: [Packages]
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
 *             properties:
 *               title:
 *                 type: string
 *               description:
 *                 type: string
 *               originalPrice:
 *                 type: number
 *               discountedPrice:
 *                 type: number
 *               quantity:
 *                 type: integer
 *               remainingQuantity:
 *                 type: integer
 *               isActive:
 *                 type: boolean
 *     responses:
 *       200:
 *         description: Paket güncellendi
 *       403:
 *         description: Yetkisiz işlem
 *       404:
 *         description: Paket bulunamadı
 */
router.put('/:id', authenticate, authorize('business_owner', 'admin'), packageController.update);

/**
 * @swagger
 * /packages/{id}:
 *   delete:
 *     summary: Paket sil
 *     tags: [Packages]
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
 *         description: Paket silindi
 *       400:
 *         description: Aktif siparişler var
 *       403:
 *         description: Yetkisiz işlem
 *       404:
 *         description: Paket bulunamadı
 */
router.delete('/:id', authenticate, authorize('business_owner', 'admin'), packageController.remove);

module.exports = router;
