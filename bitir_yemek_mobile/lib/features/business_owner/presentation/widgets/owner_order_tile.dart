import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../data/models/owner_order_model.dart';

class OwnerOrderTile extends StatelessWidget {
  final OwnerOrderModel order;
  final VoidCallback? onVerifyTap;

  const OwnerOrderTile({super.key, required this.order, this.onVerifyTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: customer name + status chip
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  order.user?.name ?? 'Bilinmeyen Müşteri',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _StatusChip(status: order.status),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // Package title
          Text(
            order.package?.title ?? 'Bilinmeyen Paket',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Pickup time + price row
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(
                '${order.package?.pickupStart ?? ''} - ${order.package?.pickupEnd ?? ''}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
              const Spacer(),
              Text(
                '${order.totalPrice.toStringAsFixed(2)} ₺',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          // Pickup code row
          if (order.pickupCode.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(Icons.qr_code, size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(
                  'Kod: ${order.pickupCode}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textHint,
                    fontFamily: 'monospace',
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],

          // Verify button
          if (order.canVerify && onVerifyTap != null) ...[
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onVerifyTap,
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text('Kodu Doğrula'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: const BorderSide(color: AppColors.success),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case 'confirmed':
        bg = AppColors.info.withValues(alpha: 0.15);
        fg = AppColors.info;
        break;
      case 'picked_up':
        bg = AppColors.success.withValues(alpha: 0.15);
        fg = AppColors.success;
        break;
      case 'cancelled':
        bg = AppColors.error.withValues(alpha: 0.15);
        fg = AppColors.error;
        break;
      default: // pending
        bg = AppColors.warning.withValues(alpha: 0.15);
        fg = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        _label(status),
        style: AppTypography.bodySmall.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  String _label(String status) {
    switch (status) {
      case 'confirmed':
        return 'Onaylı';
      case 'picked_up':
        return 'Teslim';
      case 'cancelled':
        return 'İptal';
      default:
        return 'Bekliyor';
    }
  }
}
