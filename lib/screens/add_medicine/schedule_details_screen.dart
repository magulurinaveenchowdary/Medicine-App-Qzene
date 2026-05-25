import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:med_reminder/core/constants/MedicineScheduleDefaultTimesConstants.dart';
import 'package:med_reminder/core/scheduling/MedicineScheduleFireCalculator.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddFlowPageScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/FormSectionCardWidget.dart';
import 'package:med_reminder/core/widgets/common/PrimaryActionButtonWidget.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/features/medicines/domain/MedicineSchedulePayloadModel.dart';
import 'package:med_reminder/screens/add_medicine/components/ScheduleDetailsCountChipWidget.dart';
import 'package:med_reminder/screens/add_medicine/components/ScheduleDetailsOneTimeSectionWidget.dart';
import 'package:med_reminder/screens/add_medicine/components/ScheduleDetailsTimeChipsSectionWidget.dart';
import 'package:med_reminder/screens/add_medicine/components/ScheduleDetailsWeekdayPickerWidget.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/widgets/common/DashedBorderBoxWidget.dart';
import 'package:med_reminder/screens/add_medicine/time_picker_sheet.dart';

class AddMedicineScheduleDetailsScreen extends ConsumerStatefulWidget {
  const AddMedicineScheduleDetailsScreen({super.key});
  @override
  ConsumerState<AddMedicineScheduleDetailsScreen> createState() =>
      _AddMedicineScheduleDetailsScreenState();
}

class _AddMedicineScheduleDetailsScreenState
    extends ConsumerState<AddMedicineScheduleDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final draft = ref.read(addMedicineDraftNotifierProvider);
      ref.read(appPrdAnalyticsBridgeProvider).addMedScheduleDetailsView(draft.scheduleKind);
      if (draft.scheduleKind == MedicineScheduleKind.monthly) {
        final day = draft.schedulePayload.monthlyDayOfMonth;
        if (day >= 29) {
          ref.read(appPrdAnalyticsBridgeProvider).addMedMonthlyWarningShown(day);
        }
      }
    });
  }

  String _titleForDraft(AddMedicineDraftStateModel draft) {
    final payload = draft.schedulePayload;
    switch (draft.scheduleKind) {
      case MedicineScheduleKind.oneTime:
        final at = DateTime.tryParse(payload.oneTimeAtIso ?? '');
        if (at == null) return 'One-time dose';
        return 'One-time · ${DateFormat.jm().format(at)}';
      case MedicineScheduleKind.daily:
        return 'Daily';
      case MedicineScheduleKind.timesPerDay:
        final n = draft.timesPerDay;
        return '$n times a day';
      case MedicineScheduleKind.everyXHours:
        return 'Every ${payload.everyXHours} hours';
      case MedicineScheduleKind.specificDaysOfWeek:
        return 'Specific days of week';
      case MedicineScheduleKind.everyXDays:
        return 'Every ${payload.everyXDays} days';
      case MedicineScheduleKind.weekly:
        final weeks = payload.everyXWeeks;
        return weeks == 1 ? 'Weekly' : 'Every $weeks weeks';
      case MedicineScheduleKind.monthly:
        if (payload.monthlyUseLastDayOfMonth) return 'Monthly · last day';
        return 'Monthly · day ${payload.monthlyDayOfMonth}';
      case MedicineScheduleKind.cyclic:
        return 'Cyclic · ${payload.cyclicOnDays} on, ${payload.cyclicOffDays} off';
      case MedicineScheduleKind.onDemand:
        return 'On demand';
    }
  }

  bool _showsTimeChips(MedicineScheduleKind kind) {
    return kind != MedicineScheduleKind.oneTime &&
        kind != MedicineScheduleKind.onDemand &&
        kind != MedicineScheduleKind.everyXHours;
  }

  Future<void> _pickOneTimeDate(DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked == null || !mounted) return;
    ref.read(addMedicineDraftNotifierProvider.notifier).applyOneTimeAt(
          DateTime(
            picked.year,
            picked.month,
            picked.day,
            current.hour,
            current.minute,
          ),
        );
  }

  Future<void> _pickOneTimeTime(DateTime current) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (picked == null || !mounted) return;
    ref.read(addMedicineDraftNotifierProvider.notifier).applyOneTimeAt(
          DateTime(
            current.year,
            current.month,
            current.day,
            picked.hour,
            picked.minute,
          ),
        );
  }

  Future<void> _pickAnchorDate(DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked == null || !mounted) return;
    ref.read(addMedicineDraftNotifierProvider.notifier).applyScheduleAnchorDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(addMedicineDraftNotifierProvider);
    final kind = draft.scheduleKind;
    final payload = draft.schedulePayload;
    final timeLabels = draft.doseMinutesOfDay
        .map(MedicineScheduleFireCalculator.formatMinutesOfDay)
        .toList();
    final oneTimeAt = DateTime.tryParse(payload.oneTimeAtIso ?? '') ??
        MedicineScheduleFireCalculator.defaultOneTimeDateTime(DateTime.now());
    final anchorDate = DateTime.tryParse(payload.scheduleAnchorDateIso ?? '') ?? DateTime.now();
    final dayStartMinutes = draft.doseMinutesOfDay.isEmpty
        ? MedicineScheduleDefaultTimesConstants.defaultMorningMinutes
        : draft.doseMinutesOfDay.first;
    final dayStartLabel =
        MedicineScheduleFireCalculator.formatMinutesOfDay(dayStartMinutes);

    return AddFlowPageScaffold(
      headerTitle: 'Schedule details',
      stepLabel: '5 / 7',
      showBannerAd: true,
      bottomButton: PrimaryActionButton(
        label: draft.isEditMode ? 'Done' : 'Continue',
        onPressed: () {
          final draft = ref.read(addMedicineDraftNotifierProvider);
          if (draft.scheduleKind == MedicineScheduleKind.cyclic) {
            ref.read(appPrdAnalyticsBridgeProvider).addMedCyclicConfigured(
                  draft.schedulePayload.cyclicOnDays,
                  draft.schedulePayload.cyclicOffDays,
                );
          }
          if (draft.isEditMode) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          } else {
            if (draft.scheduleKind == MedicineScheduleKind.oneTime ||
                draft.scheduleKind == MedicineScheduleKind.onDemand) {
              context.push('/add-medicine/more');
            } else {
              context.push('/add-medicine/duration');
            }
          }
        },
      ),
      children: [
        Text(
          _titleForDraft(draft),
          style: AppTextStyles.screenTitle.copyWith(
            fontSize: AppDimensions.addFlowStepTitleSize,
          ),
        ),
        SizedBox(height: AppDimensions.gapMD),
        if (kind == MedicineScheduleKind.oneTime)
          ScheduleDetailsOneTimeSectionWidget(
            scheduledAt: oneTimeAt,
            onPickDate: () => _pickOneTimeDate(oneTimeAt),
            onPickTime: () => _pickOneTimeTime(oneTimeAt),
          ),
        if (kind == MedicineScheduleKind.timesPerDay)
          FormSectionCard(
            label: 'How many times per day?',
            child: Wrap(
              spacing: AppDimensions.gapSM,
              runSpacing: AppDimensions.gapSM,
              children: [
                for (final n in List.generate(
                  MedicineScheduleDefaultTimesConstants.timesPerDayMax -
                      MedicineScheduleDefaultTimesConstants.timesPerDayMin +
                      1,
                  (i) => i + MedicineScheduleDefaultTimesConstants.timesPerDayMin,
                ))
                  ScheduleDetailsCountChipWidget(
                    value: n,
                    isSelected: draft.timesPerDay == n,
                    onTap: () => ref
                        .read(addMedicineDraftNotifierProvider.notifier)
                        .applyTimesPerDay(n),
                  ),
              ],
            ),
          ),
        if (kind == MedicineScheduleKind.everyXHours) ...[
          FormSectionCard(
            label: 'Hours between doses',
            child: Wrap(
              spacing: AppDimensions.gapSM,
              runSpacing: AppDimensions.gapSM,
              children: [
                for (final hours
                    in MedicineScheduleDefaultTimesConstants.everyXHoursIntervalOptions)
                  ScheduleDetailsCountChipWidget(
                    value: hours,
                    isSelected: payload.everyXHours == hours,
                    onTap: () => ref
                        .read(addMedicineDraftNotifierProvider.notifier)
                        .applyEveryXHoursInterval(hours),
                  ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.gapMD),
          FormSectionCard(
            label: 'Day start',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ScheduleDetailsDayStartChipRowWidget(
                  label: dayStartLabel,
                  onTap: () => AddMedicineTimePickerSheet.show(
                    context,
                    isEveryXHoursDayStart: true,
                  ),
                ),
                SizedBox(height: AppDimensions.gapSM),
                Text(
                  'First dose of each cycle starts here.',
                  style: AppTextStyles.cardSubtitle.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.gapMD),
          if (timeLabels.length > 1)
            ScheduleDetailsTimeChipsSectionWidget(
              label: 'Dose times today (tap to change)',
              timeLabels: timeLabels,
              helperText: 'Pre-filled from your interval. Each time is editable.',
            ),
        ],
        if (kind == MedicineScheduleKind.specificDaysOfWeek ||
            kind == MedicineScheduleKind.weekly)
          ScheduleDetailsWeekdayPickerWidget(
            selectedWeekdays: payload.weekdays,
            onToggleWeekday: (code) => ref
                .read(addMedicineDraftNotifierProvider.notifier)
                .toggleWeekday(code),
          ),
        if (kind == MedicineScheduleKind.weekly) ...[
          SizedBox(height: AppDimensions.gapMD),
          FormSectionCard(
            label: 'Every how many weeks?',
            child: Wrap(
              spacing: AppDimensions.gapSM,
              runSpacing: AppDimensions.gapSM,
              children: [
                for (final weeks in List.generate(
                  MedicineScheduleDefaultTimesConstants.everyXWeeksMax,
                  (i) => i + 1,
                ))
                  ScheduleDetailsCountChipWidget(
                    value: weeks,
                    isSelected: payload.everyXWeeks == weeks,
                    onTap: () => ref
                        .read(addMedicineDraftNotifierProvider.notifier)
                        .applySchedulePayload(
                          payload.copyWith(everyXWeeks: weeks),
                        ),
                  ),
              ],
            ),
          ),
        ],
        if (kind == MedicineScheduleKind.everyXDays) ...[
          FormSectionCard(
            label: 'Every how many days?',
            child: Wrap(
              spacing: AppDimensions.gapSM,
              runSpacing: AppDimensions.gapSM,
              children: [
                for (final days in const [2, 3, 4, 5, 7, 10, 14, 21, 30])
                  ScheduleDetailsCountChipWidget(
                    value: days,
                    isSelected: payload.everyXDays == days,
                    onTap: () => ref
                        .read(addMedicineDraftNotifierProvider.notifier)
                        .applySchedulePayload(
                          payload.copyWith(everyXDays: days),
                        ),
                  ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.gapMD),
          FormSectionCard(
            label: 'Start date',
            child: InkWell(
              onTap: () => _pickAnchorDate(anchorDate),
              borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  DateFormat.yMMMd().format(anchorDate),
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                ),
              ),
            ),
          ),
        ],
        if (kind == MedicineScheduleKind.monthly) ...[
          FormSectionCard(
            label: 'Day of month',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final day in List.generate(31, (i) => i + 1))
                    Padding(
                      padding: const EdgeInsets.only(right: AppDimensions.gapSM),
                      child: ScheduleDetailsCountChipWidget(
                        value: day,
                        isSelected: !payload.monthlyUseLastDayOfMonth &&
                            payload.monthlyDayOfMonth == day,
                        onTap: () {
                          ref.read(addMedicineDraftNotifierProvider.notifier).applySchedulePayload(
                                payload.copyWith(
                                  monthlyDayOfMonth: day,
                                  monthlyUseLastDayOfMonth: false,
                                ),
                              );
                          if (day >= 29) {
                            ref.read(appPrdAnalyticsBridgeProvider).addMedMonthlyWarningShown(day);
                          }
                        },
                      ),
                    ),
                  ScheduleDetailsCountChipWidget(
                    value: 0,
                    label: 'Last',
                    isSelected: payload.monthlyUseLastDayOfMonth,
                    onTap: () => ref
                        .read(addMedicineDraftNotifierProvider.notifier)
                        .applySchedulePayload(
                          payload.copyWith(
                            monthlyUseLastDayOfMonth: true,
                            monthlyDayOfMonth:
                                MedicineSchedulePayloadModel.lastDayOfMonthMarker,
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
          if (!payload.monthlyUseLastDayOfMonth &&
              payload.monthlyDayOfMonth >= 29) ...[
            const SizedBox(height: AppDimensions.gapMD),
            FormSectionCard(
              label: 'Feb 29 in non-leap years',
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      payload.feb29UseFeb28InNonLeap
                          ? 'Use Feb 28'
                          : 'Skip February',
                      style: AppTextStyles.cardSubtitle,
                    ),
                  ),
                  CupertinoSwitch(
                    value: payload.feb29UseFeb28InNonLeap,
                    onChanged: (useFeb28) {
                      ref.read(addMedicineDraftNotifierProvider.notifier).applySchedulePayload(
                            payload.copyWith(feb29UseFeb28InNonLeap: useFeb28),
                          );
                      ref.read(appPrdAnalyticsBridgeProvider).addMedLeapChoice(
                            useFeb28 ? 'feb_28' : 'skip_feb',
                          );
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
        if (kind == MedicineScheduleKind.cyclic) ...[
          FormSectionCard(
            label: 'Take for how many days?',
            child: Wrap(
              spacing: AppDimensions.gapSM,
              runSpacing: AppDimensions.gapSM,
              children: [
                for (final onDays in const [5, 10, 14, 21, 28])
                  ScheduleDetailsCountChipWidget(
                    value: onDays,
                    isSelected: payload.cyclicOnDays == onDays,
                    onTap: () => ref
                        .read(addMedicineDraftNotifierProvider.notifier)
                        .applySchedulePayload(payload.copyWith(cyclicOnDays: onDays)),
                  ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.gapMD),
          FormSectionCard(
            label: 'Then pause for how many days?',
            child: Wrap(
              spacing: AppDimensions.gapSM,
              runSpacing: AppDimensions.gapSM,
              children: [
                for (final offDays in const [2, 4, 7, 10, 14])
                  ScheduleDetailsCountChipWidget(
                    value: offDays,
                    isSelected: payload.cyclicOffDays == offDays,
                    onTap: () => ref
                        .read(addMedicineDraftNotifierProvider.notifier)
                        .applySchedulePayload(payload.copyWith(cyclicOffDays: offDays)),
                  ),
              ],
            ),
          ),
        ],
        if (_showsTimeChips(kind) && timeLabels.isNotEmpty) ...[
          if (kind != MedicineScheduleKind.daily) const SizedBox(height: AppDimensions.gapMD),
          ScheduleDetailsTimeChipsSectionWidget(timeLabels: timeLabels),
        ],
      ],
    );
  }
}

class _ScheduleDetailsDayStartChipRowWidget extends StatelessWidget {
  const _ScheduleDetailsDayStartChipRowWidget({
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
