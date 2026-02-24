const router = require('express').Router();
const reviewController = require('../controllers/reviewController');
const { authenticate } = require('../middlewares/auth');
const { validate, validateQuery, validateParams } = require('../middlewares/validate');
const { reviewSchema, paginationSchema, idParamSchema } = require('../validations/schemas');

/**
 * @swagger
 * tags:
 *   name: Reviews
 *   description: Değerlendirme işlemleri
 */

/**
 * @swagger
 * /reviews:
 *   post:
 *     summary: Değerlendirme oluştur
 *     tags: [Reviews]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - orderId
 *               - rating
 *             properties:
 *               orderId:
 *                 type: string
 *                 format: uuid
 *               rating:
 *                 type: integer
 *                 minimum: 1
 *                 maximum: 5
 *               comment:
 *                 type: string
 *     responses:
 *       201:
 *         description: Değerlendirme oluşturuldu
 *       400:
 *         description: Teslim alınmamış sipariş
 *       409:
 *         description: Zaten değerlendirme yapılmış
 */
router.post('/', authenticate, validate(reviewSchema), reviewController.create);

/**
 * @swagger
 * /reviews/business/{businessId}:
 *   get:
 *     summary: İşletme değerlendirmelerini getir
 *     tags: [Reviews]
 *     parameters:
 *       - in: path
 *         name: businessId
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
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
 *         description: Değerlendirme listesi
 */
router.get('/business/:businessId', validateParams(idParamSchema), validateQuery(paginationSchema), reviewController.getByBusiness);

module.exports = router;
