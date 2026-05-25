import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddFlowPageScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddMedicineFlowStepHeadingWidget.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddMedicineScheduleOptionCardWidget.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';

class AddMedicineScheduleTypeScreen extends ConsumerStatefulWidget {
  const AddMedicineScheduleTypeScreen({super.key});
  @override
  ConsumerState<AddMedicineScheduleTypeScreen> createState() => _AddMedicineScheduleTypeScreenState();
}

class _AddMedicineScheduleTypeScreenState extends ConsumerState<AddMedicineScheduleTypeScreen> {
  static const _options = [
    (kind: MedicineScheduleKind.oneTime, emoji: '⏱', title: 'One-time', subtitle: 'Single dose'),
    (kind: MedicineScheduleKind.daily, emoji: '📅', title: 'Daily', subtitle: 'Same time(s) every day'),
    (kind: MedicineScheduleKind.timesPerDay, emoji: '⏰', title: 'X times a day', subtitle: 'e.g., 3 times'),
    (kind: MedicineScheduleKind.everyXHours, emoji: '🕐', title: 'Every X hours', subtitle: 'e.g., every 6 hours'),
    (kind: MedicineScheduleKind.specificDaysOfWeek, emoji: '📆', title: 'Specific days of week', subtitle: 'Mon, Wed, Fri…'),
    (kind: MedicineScheduleKind.everyXDays, emoji: '🔁', title: 'Every X days', subtitle: 'e.g., every 2 days'),
    (kind: MedicineScheduleKind.weekly, emoji: '📅', title: 'Weekly', subtitle: 'Once per week'),
    (kind: MedicineScheduleKind.monthly, emoji: '🗓', title: 'Monthly', subtitle: 'Same day each month'),
    (kind: MedicineScheduleKind.cyclic, emoji: '🔄', title: 'Cyclic', subtitle: 'On/off pattern'),
    (kind: MedicineScheduleKind.onDemand, emoji: '💊', title: 'On Demand', subtitle: 'No reminders'),
  ];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appPrdAnalyticsBridgeProvider).addMedScheduleTypeView();
    });
  }

  void _onSelect(MedicineScheduleKind kind) {
    ref.read(appPrdAnalyticsBridgeProvider).addMedScheduleSelected(kind);
    ref.read(addMedicineDraftNotifierProvider.notifier).applyScheduleKind(kind);
    final draft = ref.read(addMedicineDraftNotifierProvider);
    if (draft.isEditMode) {
      if (kind == MedicineScheduleKind.onDemand) {
        context.pop();
      } else {
        context.push('/add-medicine/schedule-details');
      }
    } else {
      if (kind == MedicineScheduleKind.onDemand) {
        context.push('/add-medicine/more');
      } else {
        context.push('/add-medicine/schedule-details');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(addMedicineDraftNotifierProvider);
    return AddFlowPageScaffold(
      headerTitle: 'Schedule',
      stepLabel: '4 / 7',
      showBannerAd: true,
      children: [
        const AddMedicineFlowStepHeadingWidget(
          title: 'How often?',
          subtitle: 'Pick the pattern.',
        ),
        for (final option in _options)
          AddMedicineScheduleOptionCardWidget(
            emoji: option.emoji,
            title: option.title,
            subtitle: option.subtitle,
            isSelected: draft.scheduleKind == option.kind,
            onTap: () => _onSelect(option.kind),
          ),
      ],
    );
  }
}
