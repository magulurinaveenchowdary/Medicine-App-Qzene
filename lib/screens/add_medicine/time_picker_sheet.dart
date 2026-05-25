import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/AppModalOverlayScaffoldWidget.dart';
import 'package:med_reminder/core/analytics/AppAnalyticsMappingHelpers.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/constants/MedicineScheduleDefaultTimesConstants.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';

class AddMedicineTimePickerSheet extends ConsumerStatefulWidget {
  const AddMedicineTimePickerSheet({
    super.key,
    this.timeIndex = 0,
    this.isEveryXHoursDayStart = false,
  });

  final int timeIndex;
  final bool isEveryXHoursDayStart;

  static Future<void> show(
    BuildContext context, {
    int timeIndex = 0,
    bool isEveryXHoursDayStart = false,
  }) {
    return showCupertinoModalPopup<void>(
      context: context,
      barrierColor: AppColors.modalScrim,
      builder: (ctx) => AddMedicineTimePickerSheet(
        timeIndex: timeIndex,
        isEveryXHoursDayStart: isEveryXHoursDayStart,
      ),
    );
  }

  @override
  ConsumerState<AddMedicineTimePickerSheet> createState() =>
      _AddMedicineTimePickerSheetState();
}

class _AddMedicineTimePickerSheetState
    extends ConsumerState<AddMedicineTimePickerSheet> {
  late DateTime _pickedDateTime;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(addMedicineDraftNotifierProvider);
    final index = widget.timeIndex.clamp(0, draft.doseMinutesOfDay.length - 1);
    final minutes = widget.isEveryXHoursDayStart
        ? (draft.doseMinutesOfDay.isEmpty
            ? MedicineScheduleDefaultTimesConstants.defaultMorningMinutes
            : draft.doseMinutesOfDay.first)
        : draft.doseMinutesOfDay[index];
    _pickedDateTime = DateTime(2026, 1, 1, minutes ~/ 60, minutes % 60);
  }

  @override
  Widget build(BuildContext context) {
    final setLabel = 'Set ${_formatTime(_pickedDateTime)}';

    final screenWidth = MediaQuery.sizeOf(context).width;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: screenWidth,
          child: AppModalBottomSheetSurface(
            children: [
              Text(
                'Pick time',
                textAlign: TextAlign.center,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 17),
              ),
              SizedBox(height: AppDimensions.gapMD),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: _pickedDateTime,
                  minuteInterval: 5,
                  use24hFormat: false,
                  onDateTimeChanged: (dt) =>
                      setState(() => _pickedDateTime = dt),
                ),
              ),

              SizedBox(height: AppDimensions.gapMD),
              Row(
                children: [
                  Expanded(
                    child: _SheetActionButton(
                      label: 'Cancel',
                      backgroundColor: AppColors.backgroundTertiary,
                      textColor: AppColors.textPrimary,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: AppDimensions.gapSM),
                  Expanded(
                    flex: 2,
                    child: _SheetActionButton(
                      label: setLabel,
                      backgroundColor: AppColors.primaryBlue,
                      textColor: AppColors.cardWhite,
                      onPressed: () {
                        final draft = ref.read(
                          addMedicineDraftNotifierProvider,
                        );
                        final defaultMorning =
                            MedicineScheduleDefaultTimesConstants.defaultMorningMinutes;
                        final prior = widget.isEveryXHoursDayStart
                            ? (draft.doseMinutesOfDay.isEmpty
                                ? defaultMorning
                                : draft.doseMinutesOfDay.first)
                            : draft.doseMinutesOfDay[widget.timeIndex.clamp(
                                0,
                                draft.doseMinutesOfDay.length - 1,
                              )];
                        ref
                            .read(appPrdAnalyticsBridgeProvider)
                            .addMedDefaultTimeEdited(
                              scheduleType:
                                  AppAnalyticsMappingHelpers.scheduleTypeValue(
                                    draft.scheduleKind,
                                  ),
                              timeIndex: widget.timeIndex,
                              wasDefault8am: prior == defaultMorning,
                            );
                        final minutes =
                            _pickedDateTime.hour * 60 + _pickedDateTime.minute;
                        final notifier =
                            ref.read(addMedicineDraftNotifierProvider.notifier);
                        if (widget.isEveryXHoursDayStart) {
                          notifier.applyEveryXHoursDayStart(minutes);
                        } else {
                          notifier.applyTimeAtIndex(widget.timeIndex, minutes);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$hour:${dt.minute.toString().padLeft(2, '0')} $period';
  }
}

class _SheetActionButton extends StatelessWidget {
  const _SheetActionButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.buttonLabel.copyWith(
              fontSize: 14,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
