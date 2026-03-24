class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api';
  static const String apiVersion = 'v1';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String userRoleKey = 'user_role';

  // Pagination
  static const int defaultPageSize = 10;

  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}
