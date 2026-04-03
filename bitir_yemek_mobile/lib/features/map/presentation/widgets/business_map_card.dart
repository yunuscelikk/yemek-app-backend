import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../../home/data/models/business_model.dart';

class BusinessMapCard extends StatelessWidget {
  final BusinessModel business;
  final Map<String, dynamic>? directions;
  final VoidCallback onClose;
  final VoidCallback onNavigate;
  final VoidCallback onViewDetails;

  const BusinessMapCard({
    super.key,
    required this.business,
    this.directions,
    required this.onClose,
    required this.onNavigate,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header row with close button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Business image or placeholder
                      _buildBusinessImage(),
                      const SizedBox(width: AppSpacing.md),
                      // Business info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              business.name,
                              style: AppTypography.h3.copyWith(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            // Category
                            Text(
                              business.category.name,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            // Rating
                            _buildRating(),
                            const SizedBox(height: AppSpacing.xs),
                            // Address
                            Text(
                              business.address,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textHint,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Close button
                      IconButton(
                        onPressed: onClose,
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                        color: AppColors.textSecondary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),

                  // Distance and ETA if directions available
                  if (directions != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _buildDirectionsInfo(),
                  ],

                  // Action buttons
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      // View Details button (secondary)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onViewDetails,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                          ),
                          child: const Text('Detaylar'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Navigate button (primary)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onNavigate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                          ),
                          icon: const Icon(Icons.directions, size: 18),
                          label: const Text('Yol Tarifi'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessImage() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: business.imageUrl != null && business.imageUrl!.isNotEmpty
            ? Image.network(
                business.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Icon(
        _getCategoryIcon(),
        size: 32,
        color: AppColors.primary.withValues(alpha: 0.6),
      ),
    );
  }

  IconData _getCategoryIcon() {
    final categoryName = business.category.name.toLowerCase();
    if (categoryName.contains('restoran') ||
        categoryName.contains('restaurant')) {
      return Icons.restaurant;
    } else if (categoryName.contains('kafe') || categoryName.contains('cafe')) {
      return Icons.local_cafe;
    } else if (categoryName.contains('pastane') ||
        categoryName.contains('bakery')) {
      return Icons.bakery_dining;
    } else if (categoryName.contains('market')) {
      return Icons.store;
    }
    return Icons.storefront;
  }

  Widget _buildRating() {
    return Row(
      children: [
        Icon(Icons.star, size: 14, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          business.rating.toStringAsFixed(1),
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (business.distance != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.textHint,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.location_on_outlined, size: 14, color: AppColors.textHint),
          const SizedBox(width: 2),
          Text(
            '${business.distance!.toStringAsFixed(1)} km',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
          ),
        ],
      ],
    );
  }

  Widget _buildDirectionsInfo() {
    final distanceMeters = (directions?['distance'] as num?) ?? 0;
    final durationSeconds = (directions?['duration'] as num?) ?? 0;

    final distanceKm = distanceMeters / 1000;
    final durationMin = (durationSeconds / 60).round();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.straighten, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            distanceKm < 1
                ? '${(distanceMeters).round()} m'
                : '${distanceKm.toStringAsFixed(1)} km',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Icon(Icons.access_time, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$durationMin dk',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
