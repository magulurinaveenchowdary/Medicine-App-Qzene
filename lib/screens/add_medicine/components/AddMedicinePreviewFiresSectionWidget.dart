import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_reminder/core/constants/AppShadowDesignTokens.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/SectionLabelWidget.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';

/// Upcoming dose fire list on add-medicine preview (PRD: next 3–5 fires).
class AddMedicinePreviewFiresSectionWidget extends StatelessWidget {
  const AddMedicinePreviewFiresSectionWidget({
    super.key,
    required this.scheduleKind,
    required this.nextFires,
  });

  final MedicineScheduleKind scheduleKind;
  final List<DateTime> nextFires;

  @override
  Widget build(BuildContext context) {
    if (scheduleKind == MedicineScheduleKind.onDemand) {
      return _PreviewMessageCard(
        message: 'No scheduled reminders — take as needed.',
      );
    }

    if (nextFires.isEmpty) {
      final emptyMessage = scheduleKind == MedicineScheduleKind.oneTime
          ? 'No upcoming dose in the next 120 days.'
          : 'No upcoming reminders found for this schedule.';
      return _PreviewMessageCard(message: emptyMessage);
    }

    final sectionTitle = nextFires.length == 1
        ? 'Next reminder'
        : 'Next ${nextFires.length} fires';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingCardInner),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: AppShadowDesignTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(text: sectionTitle),
          for (var i = 0; i < nextFires.length; i++)
            _PreviewFireRowWidget(
              dateLabel: DateFormat('EEE, MMM d').format(nextFires[i]),
              timeLabel: DateFormat('h:mm a').format(nextFires[i]),
              showDivider: i < nextFires.length - 1,
            ),
        ],
      ),
    );
  }
}

class _PreviewMessageCard extends StatelessWidget {
  const _PreviewMessageCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingCardInner),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: AppShadowDesignTokens.cardShadow,
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.cardSubtitle.copyWith(fontSize: 13),
      ),
    );
  }
}

class _PreviewFireRowWidget extends StatelessWidget {
  const _PreviewFireRowWidget({
    required this.dateLabel,
    required this.timeLabel,
    required this.showDivider,
  });

  final String dateLabel;
  final String timeLabel;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              dateLabel,
              style: AppTextStyles.cardSubtitle.copyWith(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            timeLabel,
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 13,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
