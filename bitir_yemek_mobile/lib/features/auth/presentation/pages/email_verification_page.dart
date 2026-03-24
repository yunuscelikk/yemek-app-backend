import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import 'login_page.dart';

/// Shown after successful registration.
/// Informs the user to verify their email before logging in.
class EmailVerificationPage extends StatelessWidget {
  final String email;
  final String message;

  const EmailVerificationPage({
    super.key,
    required this.email,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 48,
                  color: AppColors.success,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                'E-postanızı Doğrulayın',
                textAlign: TextAlign.center,
                style: AppTypography.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Email display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  email,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                'Doğrulama bağlantısını aldıktan sonra giriş yapabilirsiniz.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),

              const Spacer(flex: 2),

              // Go to Login button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                  child: const Text('Giriş Sayfasına Git'),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
