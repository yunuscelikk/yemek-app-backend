import 'package:dio/dio.dart';
import '../../../../config/constants.dart';
import '../../../../core/network/dio_client.dart';

class BusinessesRemoteDataSource {
  final DioClient _dioClient;

  BusinessesRemoteDataSource({required DioClient dioClient})
    : _dioClient = dioClient;

  Future<Map<String, dynamic>> getNearbyBusinesses({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '/maps/nearby',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'radius': radius,
          'page': page,
          'limit': limit,
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getBusinesses({
    String? city,
    String? district,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (city != null) queryParams['city'] = city;
      if (district != null) queryParams['district'] = district;

      final response = await _dioClient.dio.get(
        '/businesses',
        queryParameters: queryParams,
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getPackages({
    String? categoryId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (categoryId != null) queryParams['categoryId'] = categoryId;

      final response = await _dioClient.dio.get(
        '/packages',
        queryParameters: queryParams,
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getNearbyPackages({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int page = 1,
    int limit = 10,
    bool excludeExpired = false, // Test amaçlı tüm paketleri göster
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '/packages',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'radius': radius,
          'page': page,
          'limit': limit,
          'excludeExpired': excludeExpired.toString(),
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await _dioClient.dio.get('/categories');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data as Map<String, dynamic>?;
      final message = data?['message'] as String? ?? 'Bir hata oluştu';

      return BusinessesException(message: message);
    }

    return BusinessesException(
      message: 'Bağlantı hatası. Lütfen internet bağlantınızı kontrol edin.',
    );
  }
}

class BusinessesException implements Exception {
  final String message;

  BusinessesException({required this.message});

  @override
  String toString() => message;
}
