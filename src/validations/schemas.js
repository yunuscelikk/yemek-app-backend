const { z } = require('zod');

// Auth
const registerSchema = z.object({
  name: z.string().min(1, 'Ad soyad gerekli'),
  email: z.string().email('Geçerli bir e-posta adresi girin'),
  password: z.string().min(6, 'Şifre en az 6 karakter olmalı'),
  phone: z.string().optional(),
  role: z.enum(['customer', 'business_owner']).optional(),
});

const loginSchema = z.object({
  email: z.string().email('Geçerli bir e-posta adresi girin'),
  password: z.string().min(1, 'Şifre gerekli'),
});

// Business
const businessSchema = z.object({
  name: z.string().min(1, 'İşletme adı gerekli'),
  description: z.string().optional(),
  address: z.string().min(1, 'Adres gerekli'),
  city: z.string().min(1, 'Şehir gerekli'),
  district: z.string().min(1, 'İlçe gerekli'),
  latitude: z.number({ invalid_type_error: 'Geçerli bir enlem girin' }),
  longitude: z.number({ invalid_type_error: 'Geçerli bir boylam girin' }),
  phone: z.string().optional(),
  imageUrl: z.string().url('Geçerli bir URL girin').optional(),
  categoryId: z.number().int('Kategori gerekli'),
});

// Package
const packageSchema = z.object({
  businessId: z.string().uuid('Geçerli bir işletme ID girin'),
  title: z.string().min(1, 'Paket adı gerekli'),
  description: z.string().optional(),
  originalPrice: z.number().min(0, 'Geçerli bir fiyat girin'),
  discountedPrice: z.number().min(0, 'Geçerli bir indirimli fiyat girin'),
  quantity: z.number().int().min(1, 'Adet en az 1 olmalı'),
  pickupStart: z.string().min(1, 'Teslim alma başlangıç saati gerekli'),
  pickupEnd: z.string().min(1, 'Teslim alma bitiş saati gerekli'),
  pickupDate: z.string().date('Geçerli bir tarih girin (YYYY-MM-DD)'),
  imageUrl: z.string().url('Geçerli bir URL girin').optional(),
});

// Order
const orderSchema = z.object({
  packageId: z.string().uuid('Geçerli bir paket ID girin'),
  quantity: z.number().int().min(1).optional(),
  couponCode: z.string().optional(),
});

// Review
const reviewSchema = z.object({
  orderId: z.string().uuid('Geçerli bir sipariş ID girin'),
  rating: z.number().int().min(1, 'Puan en az 1 olmalı').max(5, 'Puan en fazla 5 olmalı'),
  comment: z.string().optional(),
});

// Order status update
const orderStatusSchema = z.object({
  status: z.enum(['pending', 'confirmed', 'picked_up', 'cancelled'], {
    errorMap: () => ({ message: 'Geçerli bir durum girin (pending, confirmed, picked_up, cancelled)' }),
  }),
});

// User profile update
const profileUpdateSchema = z.object({
  name: z.string().min(1).optional(),
  phone: z.string().optional(),
  latitude: z.number().optional(),
  longitude: z.number().optional(),
});

// Query parameter schemas
const paginationSchema = z.object({
  page: z.string().regex(/^\d+$/).transform(Number).optional(),
  limit: z.string().regex(/^\d+$/).transform(Number).optional(),
});

const packageQuerySchema = z.object({
  page: z.string().regex(/^\d+$/).transform(Number).optional(),
  limit: z.string().regex(/^\d+$/).transform(Number).optional(),
  city: z.string().optional(),
  district: z.string().optional(),
  categoryId: z.string().regex(/^\d+$/).transform(Number).optional(),
  maxPrice: z.string().regex(/^\d+\.?\d*$/).transform(Number).optional(),
  lat: z.string().regex(/^-?\d+\.?\d*$/).transform(Number).optional(),
  lng: z.string().regex(/^-?\d+\.?\d*$/).transform(Number).optional(),
  radius: z.string().regex(/^\d+\.?\d*$/).transform(Number).optional(),
  excludeExpired: z.enum(['true', 'false']).optional(),
});

const businessQuerySchema = z.object({
  page: z.string().regex(/^\d+$/).transform(Number).optional(),
  limit: z.string().regex(/^\d+$/).transform(Number).optional(),
  city: z.string().optional(),
  district: z.string().optional(),
  categoryId: z.string().regex(/^\d+$/).transform(Number).optional(),
  search: z.string().optional(),
  lat: z.string().regex(/^-?\d+\.?\d*$/).transform(Number).optional(),
  lng: z.string().regex(/^-?\d+\.?\d*$/).transform(Number).optional(),
  radius: z.string().regex(/^\d+\.?\d*$/).transform(Number).optional(),
});

const idParamSchema = z.object({
  id: z.string().uuid('Geçerli bir ID girin'),
});

// Password reset schemas
const forgotPasswordSchema = z.object({
  email: z.string().email('Geçerli bir e-posta adresi girin'),
});

const resetPasswordSchema = z.object({
  token: z.string().min(1, 'Token gerekli'),
  password: z.string().min(6, 'Şifre en az 6 karakter olmalı'),
});

module.exports = {
  registerSchema,
  loginSchema,
  businessSchema,
  packageSchema,
  orderSchema,
  reviewSchema,
  orderStatusSchema,
  profileUpdateSchema,
  paginationSchema,
  packageQuerySchema,
  businessQuerySchema,
  idParamSchema,
  forgotPasswordSchema,
  resetPasswordSchema,
};
