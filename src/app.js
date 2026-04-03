const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const routes = require('./routes');
const errorHandler = require('./middlewares/errorHandler');

const app = express();

// Swagger konfigürasyonu
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Bitir Yemek API',
      version: '1.0.0',
      description: 'Bitir Yemek - Yemek israfını önleme platformu API dokümantasyonu',
      contact: {
        name: 'Bitir Yemek',
        email: 'info@bitiryemek.com',
      },
    },
    servers: [
      {
        url: process.env.API_URL || 'http://localhost:3000/api',
        description: 'Development Server',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
    security: [
      {
        bearerAuth: [],
      },
    ],
  },
  apis: ['./src/routes/*.js', './src/controllers/*.js'],
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);

// Swagger UI
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
  explorer: true,
  customCss: '.swagger-ui .topbar { display: none }',
  customSiteTitle: 'Bitir Yemek API Docs',
}));

// Security Headers - Helmet
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
  crossOriginEmbedderPolicy: false,
}));

// CORS
const corsOptions = {
  origin: process.env.CORS_ORIGIN || (process.env.NODE_ENV === 'production' ? false : '*'),
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
};
app.use(cors(corsOptions));

// Rate limit - genel
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 dakika
  max: 100,
  message: { message: 'Çok fazla istek gönderdiniz, lütfen daha sonra tekrar deneyin' },
  standardHeaders: true,
  legacyHeaders: false,
});

// Rate limit - auth (daha sıkı)
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  message: { message: 'Çok fazla giriş denemesi, lütfen 15 dakika sonra tekrar deneyin' },
  standardHeaders: true,
  legacyHeaders: false,
});

// Rate limit - business dashboard (orta seviye)
const businessDashboardLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 200,
  message: { message: 'Çok fazla istek gönderdiniz, lütfen daha sonra tekrar deneyin' },
  standardHeaders: true,
  legacyHeaders: false,
});

app.use(generalLimiter);
app.use('/api/auth', authLimiter);
app.use('/api/business-dashboard', businessDashboardLimiter);

// Body parser
app.use(express.json({ limit: '10kb' }));
app.use(express.urlencoded({ extended: true, limit: '10kb' }));

// Routes
app.get('/api/health', async (req, res) => {
  try {
    const { sequelize } = require('./models');
    await sequelize.authenticate();
    res.json({ 
      status: 'ok', 
      timestamp: new Date().toISOString(),
      database: 'connected',
      uptime: process.uptime()
    });
  } catch (error) {
    res.status(503).json({ 
      status: 'unhealthy', 
      timestamp: new Date().toISOString(),
      database: 'disconnected'
    });
  }
});

app.use('/api', routes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ message: 'Endpoint bulunamadı' });
});

// Error handler
app.use(errorHandler);

module.exports = app;
