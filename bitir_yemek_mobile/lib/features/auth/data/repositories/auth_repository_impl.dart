import 'dart:convert';

import '../../../../core/storage/token_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenStorage tokenStorage,
  }) : _remoteDataSource = remoteDataSource,
       _tokenStorage = tokenStorage;

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);

      final accessToken = response['accessToken'] as String?;
      final refreshToken = response['refreshToken'] as String?;
      final userData = response['user'] as Map<String, dynamic>?;

      if (accessToken == null || refreshToken == null || userData == null) {
        return AuthResult.failure('Giriş bilgileri alınamadı');
      }

      // Save tokens and user data
      await _tokenStorage.saveAccessToken(accessToken);
      await _tokenStorage.saveRefreshToken(refreshToken);

      final user = UserModel.fromJson(userData);
      await _tokenStorage.saveUserRole(user.role);
      await _tokenStorage.saveUserData(jsonEncode(user.toJson()));

      return AuthResult.success(user: user);
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure('Bir hata oluştu: $e');
    }
  }

  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String role = 'customer',
  }) async {
    try {
      final response = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
      );

      final message =
          response['message'] as String? ??
          'Kayıt başarılı! Lütfen e-postanızı doğrulayın.';

      return AuthResult.success(message: message, registeredEmail: email);
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure('Bir hata oluştu: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _tokenStorage.clearTokens();
  }

  @override
  Future<String?> getAccessToken() async {
    return await _tokenStorage.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _tokenStorage.getRefreshToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  @override
  Future<String?> getSavedUserRole() async {
    return await _tokenStorage.getUserRole();
  }
}

class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? message;
  final String? error;
  final String? registeredEmail;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.message,
    this.error,
    this.registeredEmail,
  });

  factory AuthResult.success({
    UserModel? user,
    String? message,
    String? registeredEmail,
  }) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      message: message,
      registeredEmail: registeredEmail,
    );
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(isSuccess: false, error: error);
  }
}
