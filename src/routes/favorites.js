const router = require("express").Router();
const favoriteController = require("../controllers/favoriteController");
const { authenticate } = require("../middlewares/auth");
const {
  validate,
  validateQuery,
  validateParams,
} = require("../middlewares/validate");
const {
  paginationSchema,
  businessIdParamSchema,
} = require("../validations/schemas");
const { z } = require("zod");

const addFavoriteSchema = z.object({
  businessId: z.string().uuid("Geçerli bir işletme ID girin"),
});

/**
 * @swagger
 * tags:
 *   name: Favorites
 *   description: Favori işletme işlemleri
 */

/**
 * @swagger
 * /favorites:
 *   get:
 *     summary: Favorilerimi listele
 *     tags: [Favorites]
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
 *         description: Favori listesi
 */
router.get(
  "/",
  authenticate,
  validateQuery(paginationSchema),
  favoriteController.getAll,
);

/**
 * @swagger
 * /favorites:
 *   post:
 *     summary: Favorilere ekle
 *     tags: [Favorites]
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
 *             properties:
 *               businessId:
 *                 type: string
 *                 format: uuid
 *     responses:
 *       201:
 *         description: Favorilere eklendi
 *       409:
 *         description: Zaten favorilerde
 */
router.post(
  "/",
  authenticate,
  validate(addFavoriteSchema),
  favoriteController.add,
);

/**
 * @swagger
 * /favorites/check/{businessId}:
 *   get:
 *     summary: Favori durumunu kontrol et
 *     tags: [Favorites]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: businessId
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     responses:
 *       200:
 *         description: Favori durumu
 */
router.get(
  "/check/:businessId",
  authenticate,
  validateParams(businessIdParamSchema),
  favoriteController.check,
);

/**
 * @swagger
 * /favorites/{businessId}:
 *   delete:
 *     summary: Favorilerden kaldır
 *     tags: [Favorites]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: businessId
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     responses:
 *       200:
 *         description: Favorilerden kaldırıldı
 */
router.delete(
  "/:businessId",
  authenticate,
  validateParams(businessIdParamSchema),
  favoriteController.remove,
);

module.exports = router;
