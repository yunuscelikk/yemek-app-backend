const router = require('express').Router();
const { Category } = require('../models');

/**
 * @swagger
 * tags:
 *   name: Categories
 *   description: Kategori işlemleri
 */

/**
 * @swagger
 * /categories:
 *   get:
 *     summary: Tüm kategorileri listele
 *     tags: [Categories]
 *     responses:
 *       200:
 *         description: Kategori listesi
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 categories:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                       name:
 *                         type: string
 *                       slug:
 *                         type: string
 */
router.get('/', async (req, res, next) => {
  try {
    const categories = await Category.findAll({
      order: [['name', 'ASC']],
    });
    res.json({ categories });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /categories/{id}:
 *   get:
 *     summary: Kategori detayı getir
 *     tags: [Categories]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Kategori detayı
 *       404:
 *         description: Kategori bulunamadı
 */
router.get('/:id', async (req, res, next) => {
  try {
    const category = await Category.findByPk(req.params.id);
    if (!category) {
      return res.status(404).json({ message: 'Kategori bulunamadı' });
    }
    res.json({ category });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
