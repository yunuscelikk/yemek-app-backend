const router = require('express').Router();
const { authenticate } = require('../middlewares/auth');
const { getDirections, findNearbyBusinesses, reverseGeocode, geocodeAddress } = require('../services/geocodingService');

/**
 * @swagger
 * tags:
 *   name: Maps
 *   description: Harita ve konum işlemleri
 */

/**
 * @swagger
 * /maps/directions:
 *   get:
 *     summary: Yol tarifi al
 *     tags: [Maps]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: originLat
 *         required: true
 *         schema:
 *           type: number
 *       - in: query
 *         name: originLng
 *         required: true
 *         schema:
 *           type: number
 *       - in: query
 *         name: destLat
 *         required: true
 *         schema:
 *           type: number
 *       - in: query
 *         name: destLng
 *         required: true
 *         schema:
 *           type: number
 *     responses:
 *       200:
 *         description: Yol tarifi
 *       400:
 *         description: Eksik parametre
 *       404:
 *         description: Rota bulunamadı
 */
router.get('/directions', authenticate, async (req, res, next) => {
  try {
    const { originLat, originLng, destLat, destLng } = req.query;
    
    if (!originLat || !originLng || !destLat || !destLng) {
      return res.status(400).json({ message: 'Başlangıç ve hedef koordinatları gerekli' });
    }

    const directions = await getDirections(
      parseFloat(originLat),
      parseFloat(originLng),
      parseFloat(destLat),
      parseFloat(destLng)
    );

    if (!directions) {
      return res.status(404).json({ message: 'Rota bulunamadı' });
    }

    res.json(directions);
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /maps/nearby:
 *   get:
 *     summary: Yakındaki işletmeleri getir
 *     tags: [Maps]
 *     parameters:
 *       - in: query
 *         name: lat
 *         required: true
 *         schema:
 *           type: number
 *       - in: query
 *         name: lng
 *         required: true
 *         schema:
 *           type: number
 *       - in: query
 *         name: radius
 *         schema:
 *           type: number
 *           default: 5
 *     responses:
 *       200:
 *         description: Yakındaki işletmeler
 *       400:
 *         description: Eksik parametre
 */
router.get('/nearby', async (req, res, next) => {
  try {
    const { lat, lng, radius = 5 } = req.query;
    
    if (!lat || !lng) {
      return res.status(400).json({ message: 'Konum bilgisi gerekli' });
    }

    const businesses = await findNearbyBusinesses(
      parseFloat(lat),
      parseFloat(lng),
      parseFloat(radius)
    );

    res.json({ businesses });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /maps/reverse-geocode:
 *   get:
 *     summary: Koordinattan adres bul
 *     tags: [Maps]
 *     parameters:
 *       - in: query
 *         name: lat
 *         required: true
 *         schema:
 *           type: number
 *       - in: query
 *         name: lng
 *         required: true
 *         schema:
 *           type: number
 *     responses:
 *       200:
 *         description: Adres bilgisi
 *       400:
 *         description: Eksik parametre
 *       404:
 *         description: Adres bulunamadı
 */
router.get('/reverse-geocode', async (req, res, next) => {
  try {
    const { lat, lng } = req.query;
    
    if (!lat || !lng) {
      return res.status(400).json({ message: 'Koordinatlar gerekli' });
    }

    const address = await reverseGeocode(parseFloat(lat), parseFloat(lng));

    if (!address) {
      return res.status(404).json({ message: 'Adres bulunamadı' });
    }

    res.json({ address });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /maps/geocode:
 *   get:
 *     summary: Adresten koordinat bul
 *     tags: [Maps]
 *     parameters:
 *       - in: query
 *         name: address
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Koordinat bilgisi
 *       400:
 *         description: Eksik parametre
 *       404:
 *         description: Koordinat bulunamadı
 */
router.get('/geocode', async (req, res, next) => {
  try {
    const { address } = req.query;
    
    if (!address) {
      return res.status(400).json({ message: 'Adres gerekli' });
    }

    const coordinates = await geocodeAddress(address);

    if (!coordinates) {
      return res.status(404).json({ message: 'Koordinatlar bulunamadı' });
    }

    res.json(coordinates);
  } catch (error) {
    next(error);
  }
});

module.exports = router;
