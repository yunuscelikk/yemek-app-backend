import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSource({required DioClient dioClient}) : _dioClient = dioClient;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String role = 'customer',
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      };
      if (phone != null && phone.isNotEmpty) data['phone'] = phone;

      final response = await _dioClient.dio.post('/auth/register', data: data);

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> logout() async {
    // Clear auth token from dio client
    _dioClient.clearAuthToken();
  }

  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return AuthException(
        message: 'Bağlantı zaman aşımına uğradı. Lütfen tekrar deneyin.',
      );
    } else if (e.type == DioExceptionType.connectionError) {
      return AuthException(
        message:
            'İnternet bağlantısı bulunamadı. Lütfen bağlantınızı kontrol edin.',
      );
    } else if (e.response != null) {
      final data = e.response?.data as Map<String, dynamic>?;
      final message = data?['message'] as String? ?? 'Bir hata oluştu';
      final errors = data?['errors'] as List<dynamic>?;

      return AuthException(
        message: message,
        errors: errors?.cast<String>(),
        statusCode: e.response?.statusCode,
      );
    }

    return AuthException(
      message: 'Bağlantı hatası. Lütfen internet bağlantınızı kontrol edin.',
    );
  }
}

class AuthException implements Exception {
  final String message;
  final List<String>? errors;
  final int? statusCode;

  AuthException({required this.message, this.errors, this.statusCode});

  @override
  String toString() => message;
}
