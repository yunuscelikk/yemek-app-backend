import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/dashboard_stats_model.dart';
import '../models/owner_business_model.dart';
import '../models/owner_package_model.dart';

class BusinessOwnerRemoteDataSource {
  final DioClient _dioClient;

  BusinessOwnerRemoteDataSource({required DioClient dioClient})
    : _dioClient = dioClient;

  // ── My businesses ──────────────────────────────────────────────
  Future<List<OwnerBusinessModel>> getMyBusinesses() async {
    try {
      final response = await _dioClient.dio.get(
        '/business-dashboard/my-businesses',
      );
      final List<dynamic> rawList =
          (response.data as Map<String, dynamic>)['businesses']
              as List<dynamic>;
      return rawList
          .map((e) => OwnerBusinessModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Dashboard stats ────────────────────────────────────────────
  Future<DashboardStatsModel> getDashboardStats(String businessId) async {
    try {
      final response = await _dioClient.dio.get(
        '/business-dashboard/$businessId/dashboard',
      );
      return DashboardStatsModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Orders ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getBusinessOrders(
    String businessId, {
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final params = <String, dynamic>{'page': page, 'limit': limit};
      if (status != null) params['status'] = status;
      final response = await _dioClient.dio.get(
        '/business-dashboard/$businessId/orders',
        queryParameters: params,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Packages ───────────────────────────────────────────────────
  Future<List<OwnerPackageModel>> getBusinessPackages(
    String businessId, {
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '/business-dashboard/$businessId/packages',
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> rawList = data['data'] as List<dynamic>? ?? [];
      return rawList
          .map((e) => OwnerPackageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Verify order ───────────────────────────────────────────────
  Future<Map<String, dynamic>> verifyOrder(
    String businessId,
    String pickupCode,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        '/business-dashboard/$businessId/verify-order',
        data: {'pickupCode': pickupCode},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Package CRUD ───────────────────────────────────────────────
  Future<OwnerPackageModel> createPackage({
    required String businessId,
    required String title,
    String? description,
    required double originalPrice,
    required double discountedPrice,
    required int quantity,
    required String pickupStart,
    required String pickupEnd,
    required String pickupDate,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/packages',
        data: {
          'businessId': businessId,
          'title': title,
          if (description != null && description.isNotEmpty)
            'description': description,
          'originalPrice': originalPrice,
          'discountedPrice': discountedPrice,
          'quantity': quantity,
          'pickupStart': pickupStart,
          'pickupEnd': pickupEnd,
          'pickupDate': pickupDate,
        },
      );
      final data = response.data as Map<String, dynamic>;
      // Backend returns the created package; enrich with soldQuantity defaults
      final pkg = data['package'] as Map<String, dynamic>;
      pkg['soldQuantity'] = 0;
      pkg['totalRevenue'] = 0.0;
      return OwnerPackageModel.fromJson(pkg);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<OwnerPackageModel> updatePackage(
    String packageId, {
    String? title,
    String? description,
    double? originalPrice,
    double? discountedPrice,
    int? quantity,
    String? pickupStart,
    String? pickupEnd,
    String? pickupDate,
    bool? isActive,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (originalPrice != null) body['originalPrice'] = originalPrice;
      if (discountedPrice != null) body['discountedPrice'] = discountedPrice;
      if (quantity != null) body['quantity'] = quantity;
      if (pickupStart != null) body['pickupStart'] = pickupStart;
      if (pickupEnd != null) body['pickupEnd'] = pickupEnd;
      if (pickupDate != null) body['pickupDate'] = pickupDate;
      if (isActive != null) body['isActive'] = isActive;

      final response = await _dioClient.dio.put(
        '/packages/$packageId',
        data: body,
      );
      final data = response.data as Map<String, dynamic>;
      final pkg = data['package'] as Map<String, dynamic>;
      pkg['soldQuantity'] = pkg['soldQuantity'] ?? 0;
      pkg['totalRevenue'] = pkg['totalRevenue'] ?? 0.0;
      return OwnerPackageModel.fromJson(pkg);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePackage(String packageId) async {
    try {
      await _dioClient.dio.delete('/packages/$packageId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Business CRUD ──────────────────────────────────────────────
  Future<OwnerBusinessModel> createBusiness({
    required String name,
    String? description,
    required String address,
    required String city,
    required String district,
    required double latitude,
    required double longitude,
    String? phone,
    required int categoryId,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/businesses',
        data: {
          'name': name,
          if (description != null && description.isNotEmpty)
            'description': description,
          'address': address,
          'city': city,
          'district': district,
          'latitude': latitude,
          'longitude': longitude,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          'categoryId': categoryId,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final business = data['business'] as Map<String, dynamic>;
      business['activePackages'] = 0;
      business['pendingOrders'] = 0;
      return OwnerBusinessModel.fromJson(business);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Categories ─────────────────────────────────────────────────
  Future<List<OwnerCategoryModel>> getCategories() async {
    try {
      final response = await _dioClient.dio.get('/categories');
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> rawList = data['categories'] as List<dynamic>? ?? [];
      return rawList
          .map((e) => OwnerCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Error handling ─────────────────────────────────────────────
  Exception _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data as Map<String, dynamic>?;
      final message = data?['message'] as String? ?? 'Bir hata oluştu';
      return BusinessOwnerException(message: message);
    }
    return const BusinessOwnerException(
      message: 'Bağlantı hatası. Lütfen internet bağlantınızı kontrol edin.',
    );
  }
}

class BusinessOwnerException implements Exception {
  final String message;

  const BusinessOwnerException({required this.message});

  @override
  String toString() => message;
}
