import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme.dart';
import '../../../auth/data/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  String get _initials {
    final parts = user.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  String get _memberSince {
    return DateFormat('MMMM yyyy', 'tr_TR').format(user.createdAt);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        // Avatar
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _initials,
              style: AppTypography.h1.copyWith(
                color: AppColors.primary,
                fontSize: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Name
        Text(user.name, style: AppTypography.h2, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.xs),
        // Email
        Text(
          user.email,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        // Member since
        Text(
          '$_memberSince\'den beri uye',
          style: AppTypography.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
