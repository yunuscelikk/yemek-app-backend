import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme.dart';
import '../../data/models/package_model.dart';
import '../../data/models/reservation_model.dart';
import '../bloc/reservation_bloc.dart';

class ReservationConfirmSheet extends StatefulWidget {
  final PackageModel package;

  const ReservationConfirmSheet({super.key, required this.package});

  @override
  State<ReservationConfirmSheet> createState() =>
      _ReservationConfirmSheetState();
}

class _ReservationConfirmSheetState extends State<ReservationConfirmSheet> {
  final _couponController = TextEditingController();
  CouponModel? _appliedCoupon;
  double _couponDiscount = 0;
  bool _couponValidating = false;
  String? _couponError;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  double get _packageDiscount =>
      widget.package.originalPrice - widget.package.discountedPrice;

  double get _totalPrice => widget.package.discountedPrice - _couponDiscount;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationBloc, ReservationState>(
      listener: (context, state) {
        if (state is CouponValidated) {
          setState(() {
            _appliedCoupon = state.coupon;
            _couponDiscount = state.discount;
            _couponValidating = false;
            _couponError = null;
          });
        } else if (state is CouponError) {
          setState(() {
            _couponValidating = false;
            _couponError = state.message;
            _appliedCoupon = null;
            _couponDiscount = 0;
          });
        } else if (state is CouponValidating) {
          setState(() {
            _couponValidating = true;
            _couponError = null;
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.screenPadding,
          right: AppSpacing.screenPadding,
          top: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Title
              Text('Rezervasyonu Onayla', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.lg),

              // Package summary
              _buildPackageSummary(),
              const SizedBox(height: AppSpacing.md),

              // Pickup info
              _buildPickupInfo(),
              const SizedBox(height: AppSpacing.lg),

              // Coupon input
              _buildCouponInput(),
              const SizedBox(height: AppSpacing.lg),

              // Price breakdown
              _buildPriceBreakdown(),
              const SizedBox(height: AppSpacing.lg),

              // Confirm button
              BlocBuilder<ReservationBloc, ReservationState>(
                builder: (context, state) {
                  final isLoading = state is ReservationLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Rezerve Et - ₺${_totalPrice.toStringAsFixed(0)}',
                              style: AppTypography.button,
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageSummary() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            width: 60,
            height: 60,
            color: AppColors.divider,
            child: widget.package.imageUrl != null
                ? Image.network(
                    widget.package.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.restaurant, color: AppColors.textHint),
                  )
                : Icon(Icons.restaurant, color: AppColors.textHint),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.package.title,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                widget.package.business.name,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPickupInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Bugun, ${widget.package.formattedPickupTime}',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  widget.package.business.address,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCouponInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kupon Kodu (opsiyonel)',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textHint,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponController,
                enabled: _appliedCoupon == null,
                decoration: InputDecoration(
                  hintText: 'Kupon kodunu girin',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (_appliedCoupon != null)
              IconButton(
                onPressed: () {
                  setState(() {
                    _appliedCoupon = null;
                    _couponDiscount = 0;
                    _couponController.clear();
                    _couponError = null;
                  });
                },
                icon: const Icon(Icons.close, color: AppColors.error),
              )
            else
              ElevatedButton(
                onPressed: _couponValidating ? null : _onValidateCoupon,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 12,
                  ),
                ),
                child: _couponValidating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Uygula'),
              ),
          ],
        ),
        if (_couponError != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              _couponError!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        if (_appliedCoupon != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              'Kupon uygulandi!',
              style: AppTypography.bodySmall.copyWith(color: AppColors.success),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceBreakdown() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          _buildPriceRow(
            'Paket fiyati',
            '₺${widget.package.originalPrice.toStringAsFixed(0)}',
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildPriceRow(
            'Indirim',
            '-₺${_packageDiscount.toStringAsFixed(0)}',
            valueColor: AppColors.success,
          ),
          if (_couponDiscount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildPriceRow(
              'Kupon indirimi',
              '-₺${_couponDiscount.toStringAsFixed(0)}',
              valueColor: AppColors.success,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(height: 1, color: AppColors.divider),
          ),
          _buildPriceRow(
            'Toplam',
            '₺${_totalPrice.toStringAsFixed(0)}',
            isBold: true,
            valueColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)
              : AppTypography.bodyMedium,
        ),
        Text(
          value,
          style:
              (isBold
                      ? AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        )
                      : AppTypography.bodyMedium)
                  .copyWith(color: valueColor),
        ),
      ],
    );
  }

  void _onValidateCoupon() {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;

    context.read<ReservationBloc>().add(
      ValidateCoupon(code: code, orderTotal: widget.package.discountedPrice),
    );
  }

  void _onConfirm() {
    context.read<ReservationBloc>().add(
      CreateReservation(
        packageId: widget.package.id,
        couponCode: _appliedCoupon?.code,
      ),
    );
  }
}
