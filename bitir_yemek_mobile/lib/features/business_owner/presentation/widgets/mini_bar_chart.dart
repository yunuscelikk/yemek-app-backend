import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../data/models/dashboard_stats_model.dart';

class MiniBarChart extends StatelessWidget {
  final List<DailyStatModel> dailyStats;

  const MiniBarChart({super.key, required this.dailyStats});

  @override
  Widget build(BuildContext context) {
    if (dailyStats.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text('Veri yok', style: TextStyle(color: AppColors.textHint)),
        ),
      );
    }

    final maxRevenue = dailyStats
        .map((s) => s.revenue)
        .reduce((a, b) => a > b ? a : b);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Son 7 Günlük Kazanç',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 136,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: dailyStats.map((stat) {
                final ratio = maxRevenue > 0 ? stat.revenue / maxRevenue : 0.0;
                final barHeight = 74 * ratio;
                final dayLabel = _dayLabel(stat.date);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (stat.revenue > 0)
                          Text(
                            '${stat.revenue.toStringAsFixed(0)}₺',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 9,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 2),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          height: barHeight.clamp(4.0, 74.0),
                          decoration: BoxDecoration(
                            color: stat.revenue > 0
                                ? AppColors.primary
                                : AppColors.divider,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          dayLabel,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10,
                            color: AppColors.textHint,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _dayLabel(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length < 3) return dateStr;
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      const months = [
        'Oca',
        'Şub',
        'Mar',
        'Nis',
        'May',
        'Haz',
        'Tem',
        'Ağu',
        'Eyl',
        'Eki',
        'Kas',
        'Ara',
      ];
      return '$day\n${months[month - 1]}';
    } catch (_) {
      return dateStr;
    }
  }
}
