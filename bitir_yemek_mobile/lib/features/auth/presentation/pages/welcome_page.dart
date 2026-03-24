import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../domain/user_type.dart';
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

              // Logo + Title
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: const Icon(Icons.eco, size: 44, color: Colors.white),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                'Bitir Yemek',
                style: AppTypography.h2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Yiyecek israfını önle,\npara biriktir, dünyayı kurtar.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const Spacer(flex: 2),

              // Section Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nasıl devam etmek istersiniz?',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Customer Card
              _UserTypeCard(
                userType: UserType.customer,
                icon: Icons.person_outline_rounded,
                title: 'Müşteri',
                subtitle: 'Yakınındaki sürpriz paketleri keşfet',
                color: AppColors.primary,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LoginPage(userType: UserType.customer),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.md),

              // Business Owner Card
              _UserTypeCard(
                userType: UserType.businessOwner,
                icon: Icons.storefront_outlined,
                title: 'İşletme Sahibi',
                subtitle: 'İşletmeni yönet, arta kalan yiyecekleri değerlendir',
                color: AppColors.googleButton,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LoginPage(userType: UserType.businessOwner),
                    ),
                  );
                },
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserTypeCard extends StatelessWidget {
  final UserType userType;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _UserTypeCard({
    required this.userType,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider, width: 1.5),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 28),
            ),

            const SizedBox(width: AppSpacing.md),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
