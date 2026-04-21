import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';

class ProfileRemoteDataSource {
  final DioClient _dioClient;
  final TokenStorage _tokenStorage;

  ProfileRemoteDataSource({
    required DioClient dioClient,
    required TokenStorage tokenStorage,
  }) : _dioClient = dioClient,
       _tokenStorage = tokenStorage;

  Future<void> _ensureAuth() async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      _dioClient.setAuthToken(token);
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      await _ensureAuth();
      final response = await _dioClient.dio.get('/users/profile');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
  }) async {
    try {
      await _ensureAuth();
      final response = await _dioClient.dio.put(
        '/users/profile',
        data: {'name': ?name, 'phone': ?phone},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _ensureAuth();
      await _dioClient.dio.delete('/users/profile');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data as Map<String, dynamic>?;
      final message = data?['message'] as String? ?? 'Bir hata olustu';
      return ProfileException(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
    return ProfileException(
      message: 'Baglanti hatasi. Lutfen internet baglantinizi kontrol edin.',
    );
  }
}

class ProfileException implements Exception {
  final String message;
  final int? statusCode;

  ProfileException({required this.message, this.statusCode});

  @override
  String toString() => message;
}
