import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../../../shared/widgets/app_cached_image.dart';
import '../../data/models/owner_business_model.dart';
import 'business_owner_scaffold.dart';
import 'register_business_page.dart';

class BusinessSelectorPage extends StatelessWidget {
  final List<OwnerBusinessModel> businesses;

  const BusinessSelectorPage({super.key, required this.businesses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('İşletmelerim'),
        actions: [
          TextButton.icon(
            onPressed: () => _openRegister(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Yeni'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: businesses.length,
        itemBuilder: (context, i) {
          return _BusinessCard(
            business: businesses[i],
            onTap: () => _selectBusiness(context, businesses[i].id),
          );
        },
      ),
    );
  }

  void _selectBusiness(BuildContext context, String businessId) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => BusinessOwnerScaffold(businessId: businessId),
      ),
      (route) => false,
    );
  }

  Future<void> _openRegister(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const RegisterBusinessPage()),
    );
    if (result == true && context.mounted) {
      // Fresh scaffold will reload businesses (now has 1)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BusinessOwnerScaffold()),
        (route) => false,
      );
    }
  }
}

class _BusinessCard extends StatelessWidget {
  final OwnerBusinessModel business;
  final VoidCallback onTap;

  const _BusinessCard({required this.business, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final approvalColor = switch (business.approvalStatus) {
      'approved' => AppColors.success,
      'rejected' => AppColors.error,
      _ => AppColors.warning,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Business icon / image
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: AppCachedImage(
                  imageUrl: business.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: const Icon(
                    Icons.storefront,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          business.name,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      // Approval badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: approvalColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          business.approvalLabel,
                          style: AppTypography.bodySmall.copyWith(
                            color: approvalColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${business.city}, ${business.district}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      _MetaPill(
                        icon: Icons.inventory_2_outlined,
                        label: '${business.activePackages} aktif paket',
                        color: AppColors.info,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      if (business.pendingOrders > 0)
                        _MetaPill(
                          icon: Icons.pending_outlined,
                          label: '${business.pendingOrders} bekliyor',
                          color: AppColors.warning,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
