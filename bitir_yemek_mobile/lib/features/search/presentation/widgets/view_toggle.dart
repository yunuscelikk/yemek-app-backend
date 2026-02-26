import 'package:flutter/material.dart';
import '../../../../config/theme.dart';

class ViewToggle extends StatelessWidget {
  final bool isListView;
  final ValueChanged<bool> onToggle;

  const ViewToggle({
    super.key,
    required this.isListView,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Liste Button
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              child: Container(
                decoration: BoxDecoration(
                  color: isListView ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Text(
                    'Liste',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isListView
                          ? Colors.white
                          : AppColors.textSecondary,
                      fontWeight: isListView
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Harita Button
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: Container(
                decoration: BoxDecoration(
                  color: !isListView ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Text(
                    'Harita',
                    style: AppTypography.bodyMedium.copyWith(
                      color: !isListView
                          ? Colors.white
                          : AppColors.textSecondary,
                      fontWeight: !isListView
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
