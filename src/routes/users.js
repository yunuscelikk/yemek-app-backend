const router = require('express').Router();
const userController = require('../controllers/userController');
const { authenticate } = require('../middlewares/auth');
const { validate } = require('../middlewares/validate');
const { profileUpdateSchema } = require('../validations/schemas');

/**
 * @swagger
 * tags:
 *   name: Users
 *   description: Kullanıcı işlemleri
 */

/**
 * @swagger
 * /users/profile:
 *   get:
 *     summary: Kullanıcı profili getir
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Profil bilgileri
 *       401:
 *         description: Yetkilendirme hatası
 */
router.get('/profile', authenticate, userController.getProfile);

/**
 * @swagger
 * /users/profile:
 *   put:
 *     summary: Profil güncelle
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: "Ahmet Yılmaz"
 *               phone:
 *                 type: string
 *                 example: "5551234567"
 *               latitude:
 *                 type: number
 *                 example: 41.0082
 *               longitude:
 *                 type: number
 *                 example: 28.9784
 *     responses:
 *       200:
 *         description: Profil güncellendi
 *       401:
 *         description: Yetkilendirme hatası
 */
router.put('/profile', authenticate, validate(profileUpdateSchema), userController.updateProfile);

/**
 * @swagger
 * /users/profile:
 *   delete:
 *     summary: Hesabı sil
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Hesap silindi
 *       401:
 *         description: Yetkilendirme hatası
 */
router.delete('/profile', authenticate, userController.deleteAccount);

module.exports = router;
