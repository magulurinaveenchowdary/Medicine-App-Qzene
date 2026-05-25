import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

enum MedicineStatusBadgeKind {
  taken,
  missed,
  skipped,
  active,
  upcoming,
}

/// Pill-shaped status chip: Taken, Missed, Skipped, Active, Upcoming.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.kind,
    this.showCheckmark = false,
  });

  final String label;
  final MedicineStatusBadgeKind kind;
  final bool showCheckmark;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = _colorsForKind(kind);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showCheckmark && kind == MedicineStatusBadgeKind.taken) ...[
            Text(
              '✓',
              style: AppTextStyles.cardSubtitle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
            const SizedBox(width: 2),
          ],
          Text(
            label,
            style: AppTextStyles.cardSubtitle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, Border?) _colorsForKind(MedicineStatusBadgeKind kind) {
    switch (kind) {
      case MedicineStatusBadgeKind.taken:
        return (AppColors.healthGreen, AppColors.cardWhite, null);
      case MedicineStatusBadgeKind.missed:
        return (AppColors.errorRed, AppColors.cardWhite, null);
      case MedicineStatusBadgeKind.skipped:
        return (AppColors.backgroundTertiary, AppColors.textSecondary, null);
      case MedicineStatusBadgeKind.active:
        return (
          AppColors.activeBadgeFill,
          AppColors.activeBadgeText,
          Border.all(color: AppColors.primaryBlueTint),
        );
      case MedicineStatusBadgeKind.upcoming:
        return (AppColors.upcomingBadgeFill, AppColors.upcomingBadgeText, null);
    }
  }
}
