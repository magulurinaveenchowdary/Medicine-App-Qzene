import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/FormSectionCardWidget.dart';
import 'package:med_reminder/core/widgets/common/DashedBorderBoxWidget.dart';

class ScheduleDetailsOneTimeSectionWidget extends StatelessWidget {
  const ScheduleDetailsOneTimeSectionWidget({
    super.key,
    required this.scheduledAt,
    required this.onPickDate,
    required this.onPickTime,
  });

  final DateTime scheduledAt;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat.yMMMd().format(scheduledAt);
    final timeLabel = DateFormat.jm().format(scheduledAt);

    return FormSectionCard(
      label: 'When?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScheduleDetailsTapRowWidget(
            label: 'Date',
            value: dateLabel,
            onTap: onPickDate,
          ),
          SizedBox(height: AppDimensions.gapSM),
          _ScheduleDetailsTapRowWidget(
            label: 'Time',
            value: timeLabel,
            onTap: onPickTime,
          ),
          SizedBox(height: AppDimensions.gapSM),
          Text(
            'Default is 5 minutes from now. Tap to change.',
            style: AppTextStyles.cardSubtitle.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ScheduleDetailsTapRowWidget extends StatelessWidget {
  const _ScheduleDetailsTapRowWidget({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
      child: DashedBorderBoxWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingCardInner,
            vertical: 12,
          ),
          child: Row(
            children: [
              Text(
                label,
                style: AppTextStyles.cardSubtitle.copyWith(fontSize: 13),
              ),
              const Spacer(),
              Text(
                value,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
