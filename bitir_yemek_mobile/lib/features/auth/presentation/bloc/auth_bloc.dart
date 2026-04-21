import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<AppleSignInRequested>(_onAppleSignInRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.login(event.email, event.password);

    if (result.isSuccess) {
      emit(AuthAuthenticated(user: result.user!));
    } else {
      emit(AuthError(message: result.error!));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.register(
      name: event.name,
      email: event.email,
      password: event.password,
      phone: event.phone,
      role: event.role,
    );

    if (result.isSuccess) {
      emit(
        AuthRegistrationSuccess(
          message:
              result.message ??
              'Kayıt başarılı! Lütfen e-postanızı doğrulayın.',
          email: result.registeredEmail ?? event.email,
        ),
      );
    } else {
      emit(AuthError(message: result.error!));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final isLoggedIn = await _authRepository.isLoggedIn();

    if (isLoggedIn) {
      // User has token, load user data from storage
      final userData = await _authRepository.getCurrentUser();
      if (userData != null) {
        emit(AuthAuthenticated(user: userData));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.googleLogin(role: event.role);

    if (result.isSuccess) {
      emit(AuthAuthenticated(user: result.user!));
    } else {
      emit(AuthError(message: result.error!));
    }
  }

  Future<void> _onAppleSignInRequested(
    AppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.appleLogin(role: event.role);

    if (result.isSuccess) {
      emit(AuthAuthenticated(user: result.user!));
    } else {
      emit(AuthError(message: result.error!));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.forgotPassword(event.email);

    if (result.isSuccess) {
      emit(
        ForgotPasswordSuccess(
          message: result.message ?? 'Şifre sıfırlama kodu gönderildi',
        ),
      );
    } else {
      emit(AuthError(message: result.error!));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.resetPassword(
      event.token,
      event.newPassword,
    );

    if (result.isSuccess) {
      emit(
        ResetPasswordSuccess(
          message: result.message ?? 'Şifreniz başarıyla değiştirildi',
        ),
      );
    } else {
      emit(AuthError(message: result.error!));
    }
  }
}
