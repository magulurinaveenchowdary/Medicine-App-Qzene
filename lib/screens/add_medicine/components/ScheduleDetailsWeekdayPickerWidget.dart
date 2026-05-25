import 'package:flutter/material.dart';
import 'package:med_reminder/core/constants/MedicineScheduleDefaultTimesConstants.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/widgets/common/FormSectionCardWidget.dart';
import 'package:med_reminder/screens/add_medicine/components/ScheduleDetailsCountChipWidget.dart';

class ScheduleDetailsWeekdayPickerWidget extends StatelessWidget {
  const ScheduleDetailsWeekdayPickerWidget({
    super.key,
    required this.selectedWeekdays,
    required this.onToggleWeekday,
  });

  final List<int> selectedWeekdays;
  final ValueChanged<int> onToggleWeekday;

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      label: 'Which days?',
      child: Wrap(
        spacing: AppDimensions.gapSM,
        runSpacing: AppDimensions.gapSM,
        children: [
          for (var code = 1; code <= 7; code++)
            ScheduleDetailsCountChipWidget(
              value: code,
              label: MedicineScheduleDefaultTimesConstants.weekdayShortLabels[code - 1],
              isSelected: selectedWeekdays.contains(code),
              onTap: () => onToggleWeekday(code),
            ),
        ],
      ),
    );
  }
}
