import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  Future<void> logout();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<bool> isLoggedIn();
}
