import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String role = 'customer',
  });

  Future<void> logout();

  Future<AuthResult> googleLogin({required String role});

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<bool> isLoggedIn();

  Future<String?> getSavedUserRole();

  Future<UserModel?> getCurrentUser();

  Future<AuthResult> forgotPassword(String email);

  Future<AuthResult> resetPassword(String token, String newPassword);
}
