import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/DashedBorderBoxWidget.dart';
import 'package:med_reminder/core/widgets/common/FormSectionCardWidget.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/screens/add_medicine/components/ScheduleDetailsCountChipWidget.dart';

/// End date or day-count inputs shown when a non-ongoing duration is selected (PRD §6.3 step 23).
class AddMedicineDurationDetailsSectionWidget extends StatelessWidget {
  const AddMedicineDurationDetailsSectionWidget({
    super.key,
    required this.durationKind,
    required this.endDate,
    required this.durationDayCount,
    required this.daysCountController,
    required this.onPickEndDate,
    required this.onDayCountChanged,
    required this.onQuickDayCountTap,
  });

  final MedicineDurationKind durationKind;
  final DateTime? endDate;
  final int? durationDayCount;
  final TextEditingController daysCountController;
  final VoidCallback onPickEndDate;
  final ValueChanged<String> onDayCountChanged;
  final ValueChanged<int> onQuickDayCountTap;

  static const quickDayCounts = [7, 14, 21, 30];

  @override
  Widget build(BuildContext context) {
    return switch (durationKind) {
      MedicineDurationKind.ongoing => const SizedBox.shrink(),
      MedicineDurationKind.untilDate => _UntilDateSection(
          endDate: endDate,
          onPickEndDate: onPickEndDate,
        ),
      MedicineDurationKind.forDays => _ForDaysSection(
          durationDayCount: durationDayCount,
          daysCountController: daysCountController,
          onDayCountChanged: onDayCountChanged,
          onQuickDayCountTap: onQuickDayCountTap,
        ),
    };
  }
}

class _UntilDateSection extends StatelessWidget {
  const _UntilDateSection({
    required this.endDate,
    required this.onPickEndDate,
  });

  final DateTime? endDate;
  final VoidCallback onPickEndDate;

  @override
  Widget build(BuildContext context) {
    final valueLabel = endDate != null
        ? DateFormat.yMMMd().format(endDate!)
        : 'Pick end date';

    return FormSectionCard(
      label: 'End date',
      child: InkWell(
        onTap: onPickEndDate,
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
                  'Ends on',
                  style: AppTextStyles.cardSubtitle.copyWith(fontSize: 13),
                ),
                const Spacer(),
                Text(
                  valueLabel,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ForDaysSection extends StatelessWidget {
  const _ForDaysSection({
    required this.durationDayCount,
    required this.daysCountController,
    required this.onDayCountChanged,
    required this.onQuickDayCountTap,
  });

  final int? durationDayCount;
  final TextEditingController daysCountController;
  final ValueChanged<String> onDayCountChanged;
  final ValueChanged<int> onQuickDayCountTap;

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      label: 'Number of days',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoTextField(
            controller: daysCountController,
            keyboardType: TextInputType.number,
            decoration: const BoxDecoration(),
            style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
            padding: EdgeInsets.zero,
            cursorColor: AppColors.primaryBlue,
            onChanged: onDayCountChanged,
          ),
          SizedBox(height: AppDimensions.gapMD),
          Wrap(
            spacing: AppDimensions.gapSM,
            runSpacing: AppDimensions.gapSM,
            children: [
              for (final count in AddMedicineDurationDetailsSectionWidget.quickDayCounts)
                ScheduleDetailsCountChipWidget(
                  value: count,
                  isSelected: durationDayCount == count,
                  onTap: () => onQuickDayCountTap(count),
                ),
            ],
          ),
          SizedBox(height: AppDimensions.gapSM),
          Text(
            'e.g., 7 days for an antibiotic course',
            style: AppTextStyles.cardSubtitle.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
