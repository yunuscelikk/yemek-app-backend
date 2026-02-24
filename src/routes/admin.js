const router = require('express').Router();
const adminController = require('../controllers/adminController');
const { authenticate } = require('../middlewares/auth');
const { authorize } = require('../middlewares/role');
const { validateQuery, validateParams } = require('../middlewares/validate');
const { paginationSchema, idParamSchema } = require('../validations/schemas');

/**
 * @swagger
 * tags:
 *   name: Admin
 *   description: Admin işlemleri
 */

// All routes require admin role
router.use(authenticate, authorize('admin'));

/**
 * @swagger
 * /admin/dashboard:
 *   get:
 *     summary: Admin dashboard istatistikleri
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Dashboard verileri
 *       403:
 *         description: Yetkisiz işlem
 */
router.get('/dashboard', adminController.getDashboardStats);

/**
 * @swagger
 * /admin/users:
 *   get:
 *     summary: Tüm kullanıcıları listele
 *     tags: [Admin]
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
 *         description: Kullanıcı listesi
 *       403:
 *         description: Yetkisiz işlem
 */
router.get('/users', validateQuery(paginationSchema), adminController.getAllUsers);

/**
 * @swagger
 * /admin/users/{id}:
 *   get:
 *     summary: Kullanıcı detayı getir
 *     tags: [Admin]
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
 *         description: Kullanıcı detayı
 *       403:
 *         description: Yetkisiz işlem
 *       404:
 *         description: Kullanıcı bulunamadı
 */
router.get('/users/:id', validateParams(idParamSchema), adminController.getUserById);

/**
 * @swagger
 * /admin/users/{id}:
 *   put:
 *     summary: Kullanıcı güncelle
 *     tags: [Admin]
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
 *               role:
 *                 type: string
 *                 enum: [customer, business_owner, admin]
 *               isEmailVerified:
 *                 type: boolean
 *     responses:
 *       200:
 *         description: Kullanıcı güncellendi
 *       403:
 *         description: Yetkisiz işlem
 *       404:
 *         description: Kullanıcı bulunamadı
 */
router.put('/users/:id', validateParams(idParamSchema), adminController.updateUser);

/**
 * @swagger
 * /admin/users/{id}:
 *   delete:
 *     summary: Kullanıcı sil
 *     tags: [Admin]
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
 *         description: Kullanıcı silindi
 *       403:
 *         description: Yetkisiz işlem
 *       404:
 *         description: Kullanıcı bulunamadı
 */
router.delete('/users/:id', validateParams(idParamSchema), adminController.deleteUser);

/**
 * @swagger
 * /admin/businesses/pending:
 *   get:
 *     summary: Onay bekleyen işletmeleri listele
 *     tags: [Admin]
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
 *         description: Onay bekleyen işletme listesi
 *       403:
 *         description: Yetkisiz işlem
 */
router.get('/businesses/pending', validateQuery(paginationSchema), adminController.getPendingBusinesses);

/**
 * @swagger
 * /admin/businesses/{id}/approve:
 *   patch:
 *     summary: İşletme onayla
 *     tags: [Admin]
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
 *         description: İşletme onaylandı
 *       403:
 *         description: Yetkisiz işlem
 *       404:
 *         description: İşletme bulunamadı
 */
router.patch('/businesses/:id/approve', validateParams(idParamSchema), adminController.approveBusiness);

/**
 * @swagger
 * /admin/businesses/{id}/reject:
 *   patch:
 *     summary: İşletme reddet
 *     tags: [Admin]
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
 *         description: İşletme reddedildi
 *       403:
 *         description: Yetkisiz işlem
 *       404:
 *         description: İşletme bulunamadı
 */
router.patch('/businesses/:id/reject', validateParams(idParamSchema), adminController.rejectBusiness);

/**
 * @swagger
 * /admin/orders:
 *   get:
 *     summary: Tüm siparişleri listele
 *     tags: [Admin]
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
 *       403:
 *         description: Yetkisiz işlem
 */
router.get('/orders', validateQuery(paginationSchema), adminController.getAllOrders);

module.exports = router;
