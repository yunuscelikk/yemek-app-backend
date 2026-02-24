const router = require('express').Router();
const businessController = require('../controllers/businessController');
const { authenticate } = require('../middlewares/auth');
const { authorize } = require('../middlewares/role');
const { validate, validateQuery, validateParams } = require('../middlewares/validate');
const { businessSchema, businessQuerySchema, idParamSchema } = require('../validations/schemas');

/**
 * @swagger
 * tags:
 *   name: Businesses
 *   description: İşletme işlemleri
 */

/**
 * @swagger
 * /businesses:
 *   get:
 *     summary: Tüm işletmeleri listele
 *     tags: [Businesses]
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
 *         name: search
 *         schema:
 *           type: string
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
 *           default: 5
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 10
 *     responses:
 *       200:
 *         description: İşletme listesi
 */
router.get('/', validateQuery(businessQuerySchema), businessController.getAll);

/**
 * @swagger
 * /businesses/{id}:
 *   get:
 *     summary: İşletme detayı getir
 *     tags: [Businesses]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     responses:
 *       200:
 *         description: İşletme detayı
 *       404:
 *         description: İşletme bulunamadı
 */
router.get('/:id', validateParams(idParamSchema), businessController.getById);

/**
 * @swagger
 * /businesses:
 *   post:
 *     summary: Yeni işletme oluştur
 *     tags: [Businesses]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - address
 *               - city
 *               - district
 *               - latitude
 *               - longitude
 *               - categoryId
 *             properties:
 *               name:
 *                 type: string
 *                 example: "Lezzet Durağı"
 *               description:
 *                 type: string
 *               address:
 *                 type: string
 *               city:
 *                 type: string
 *               district:
 *                 type: string
 *               latitude:
 *                 type: number
 *               longitude:
 *                 type: number
 *               phone:
 *                 type: string
 *               categoryId:
 *                 type: integer
 *     responses:
 *       201:
 *         description: İşletme oluşturuldu
 *       403:
 *         description: Yetkisiz işlem
 */
router.post('/', authenticate, authorize('business_owner', 'admin'), validate(businessSchema), businessController.create);

/**
 * @swagger
 * /businesses/{id}:
 *   put:
 *     summary: İşletme güncelle
 *     tags: [Businesses]
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
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               isActive:
 *                 type: boolean
 *     responses:
 *       200:
 *         description: İşletme güncellendi
 *       403:
 *         description: Yetkisiz işlem
 *       404:
 *         description: İşletme bulunamadı
 */
router.put('/:id', authenticate, authorize('business_owner', 'admin'), validateParams(idParamSchema), businessController.update);

/**
 * @swagger
 * /businesses/{id}:
 *   delete:
 *     summary: İşletme sil
 *     tags: [Businesses]
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
 *         description: İşletme silindi
 *       403:
 *         description: Yetkisiz işlem
 *       404:
 *         description: İşletme bulunamadı
 */
router.delete('/:id', authenticate, authorize('business_owner', 'admin'), validateParams(idParamSchema), businessController.remove);

module.exports = router;
