import 'package:shared_preferences/shared_preferences.dart';
import '../../config/constants.dart';

abstract class TokenStorage {
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveUserRole(String role);
  Future<String?> getUserRole();
  Future<void> saveUserData(String json);
  Future<String?> getUserData();
  Future<void> clearTokens();
}

class SharedPrefsTokenStorage implements TokenStorage {
  SharedPrefsTokenStorage();

  @override
  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.accessTokenKey, token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.refreshTokenKey, token);
  }

  @override
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.refreshTokenKey);
  }

  @override
  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userRoleKey, role);
  }

  @override
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userRoleKey);
  }

  @override
  Future<void> saveUserData(String json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userDataKey, json);
  }

  @override
  Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userDataKey);
  }

  @override
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.accessTokenKey);
    await prefs.remove(AppConstants.refreshTokenKey);
    await prefs.remove(AppConstants.userRoleKey);
    await prefs.remove(AppConstants.userDataKey);
  }
}

// Secure storage implementation for production
// Uncomment when flutter_secure_storage is properly configured
/*
class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _secureStorage;

  SecureTokenStorage({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(
      key: AppConstants.accessTokenKey,
      value: token,
    );
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(
      key: AppConstants.refreshTokenKey,
      value: token,
    );
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: AppConstants.accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConstants.refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: AppConstants.accessTokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
  }
}
*/
