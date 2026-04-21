const router = require('express').Router();
const { authenticate } = require('../middlewares/auth');
const { validateQuery } = require('../middlewares/validate');
const { directionsQuerySchema, nearbyQuerySchema, reverseGeocodeQuerySchema, geocodeQuerySchema } = require('../validations/schemas');
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
router.get('/directions', authenticate, validateQuery(directionsQuerySchema), async (req, res, next) => {
  try {
    const { originLat, originLng, destLat, destLng } = req.query;

    const directions = await getDirections(
      originLat,
      originLng,
      destLat,
      destLng
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
router.get('/nearby', authenticate, validateQuery(nearbyQuerySchema), async (req, res, next) => {
  try {
    const { lat, lng, radius = 5 } = req.query;

    const businesses = await findNearbyBusinesses(
      lat,
      lng,
      radius
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
router.get('/reverse-geocode', authenticate, validateQuery(reverseGeocodeQuerySchema), async (req, res, next) => {
  try {
    const { lat, lng } = req.query;

    const address = await reverseGeocode(lat, lng);

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
router.get('/geocode', authenticate, validateQuery(geocodeQuerySchema), async (req, res, next) => {
  try {
    const { address } = req.query;

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
