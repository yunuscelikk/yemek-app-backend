import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Title
              Text(
                'Yiyecekleri kurtarmaya\nbaşlayalım!',
                textAlign: TextAlign.center,
                style: AppTypography.h2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Food Image
              Image.asset(
                'assets/images/food_box.png',
                height: 200,
                fit: BoxFit.contain,
              ),

              const Spacer(flex: 3),

              // Continue with Apple Button
              _SocialButton(
                text: 'Continue with Apple',
                icon: Icons.apple,
                backgroundColor: AppColors.appleButton,
                onPressed: () {
                  // TODO: Implement Apple sign in
                },
              ),

              const SizedBox(height: AppSpacing.md),

              // Continue with Google Button
              _SocialButton(
                text: 'Continue with Google',
                icon: Icons.g_mobiledata,
                backgroundColor: AppColors.googleButton,
                onPressed: () {
                  // TODO: Implement Google sign in
                },
              ),

              const SizedBox(height: AppSpacing.md),

              // Continue with Email Button
              _SocialButton(
                text: 'Continue with email',
                icon: Icons.email_outlined,
                backgroundColor: AppColors.primary,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Text(
              text,
              style: AppTypography.button.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
