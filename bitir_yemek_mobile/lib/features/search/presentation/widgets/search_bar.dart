import 'package:flutter/material.dart';
import '../../../../config/theme.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;

  const CustomSearchBar({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.md),
          Icon(Icons.search, color: AppColors.textHint, size: 24),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: hintText ?? 'Ara...',
                hintStyle: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTypography.bodyLarge,
            ),
          ),
          // Location Button
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Open location filter
              },
              icon: Icon(Icons.location_on, color: AppColors.primary, size: 20),
              padding: EdgeInsets.zero,
            ),
          ),
          // Filter Button
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Open filter modal
              },
              icon: Icon(Icons.tune, color: AppColors.primary, size: 20),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
