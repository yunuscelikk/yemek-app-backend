import '../../../auth/data/models/user_model.dart';

abstract class ProfileRepository {
  Future<ProfileResult> getProfile();

  Future<ProfileResult> updateProfile({String? name, String? phone});

  Future<void> logout();
}

class ProfileResult {
  final bool isSuccess;
  final UserModel? user;
  final String? message;
  final String? error;

  ProfileResult._({
    required this.isSuccess,
    this.user,
    this.message,
    this.error,
  });

  factory ProfileResult.success({UserModel? user, String? message}) {
    return ProfileResult._(isSuccess: true, user: user, message: message);
  }

  factory ProfileResult.failure(String error) {
    return ProfileResult._(isSuccess: false, error: error);
  }
}
