import 'package:dio/dio.dart';
import '../../config/constants.dart';
import '../../core/storage/token_storage.dart';

class DioClient {
  late final Dio _dio;

  DioClient({TokenStorage? tokenStorage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: AppConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (tokenStorage != null) {
      _dio.interceptors.add(
        AuthInterceptor(tokenStorage: tokenStorage, dio: _dio),
      );
    }

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  Dio get dio => _dio;

  // Kept for manual override (e.g. right after login before interceptor loads)
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

/// Automatically injects Bearer token on every request.
/// On 401, attempts a silent token refresh and retries the original request.
/// On refresh failure, clears tokens (forces re-login).
class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Dio dio;
  bool _isRefreshing = false;

  AuthInterceptor({required this.tokenStorage, required this.dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await tokenStorage.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          await tokenStorage.clearTokens();
          handler.next(err);
          return;
        }

        // Use a separate Dio instance to avoid interceptor loop
        final refreshDio = Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrl,
            headers: {'Content-Type': 'application/json'},
          ),
        );

        final response = await refreshDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['accessToken'] as String;
        final newRefreshToken = response.data['refreshToken'] as String;

        await tokenStorage.saveAccessToken(newAccessToken);
        await tokenStorage.saveRefreshToken(newRefreshToken);

        // Retry original request with the new token
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await dio.fetch(err.requestOptions);
        handler.resolve(retryResponse);
      } catch (_) {
        await tokenStorage.clearTokens();
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }
}
