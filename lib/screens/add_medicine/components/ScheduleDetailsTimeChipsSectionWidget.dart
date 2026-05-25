import 'package:flutter/material.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/FormSectionCardWidget.dart';
import 'package:med_reminder/core/widgets/common/DashedBorderBoxWidget.dart';
import 'package:med_reminder/screens/add_medicine/time_picker_sheet.dart';

class ScheduleDetailsTimeChipsSectionWidget extends StatelessWidget {
  const ScheduleDetailsTimeChipsSectionWidget({
    super.key,
    required this.timeLabels,
    this.label = 'Times (tap to change)',
    this.helperText = 'Tap any chip to open the time picker.',
  });

  final List<String> timeLabels;
  final String label;
  final String helperText;

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppDimensions.gapSM,
            runSpacing: AppDimensions.gapSM,
            children: [
              for (var i = 0; i < timeLabels.length; i++)
                _ScheduleDetailsTimeChipWidget(
                  label: timeLabels[i],
                  onTap: () => AddMedicineTimePickerSheet.show(
                    context,
                    timeIndex: i,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppDimensions.gapSM),
          Text(
            helperText,
            style: AppTextStyles.cardSubtitle.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ScheduleDetailsTimeChipWidget extends StatelessWidget {
  const _ScheduleDetailsTimeChipWidget({
    required this.label,
    required this.onTap,
  });

  final String label;
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
            vertical: 10,
          ),
          child: Text(
            label,
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
