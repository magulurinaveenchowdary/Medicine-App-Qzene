import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddFlowPageScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/PrimaryActionButtonWidget.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddMedicineFlowStepHeadingWidget.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddMedicineScheduleOptionCardWidget.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/screens/add_medicine/components/AddMedicineDurationDetailsSectionWidget.dart';

class AddMedicineDurationScreen extends ConsumerStatefulWidget {
  const AddMedicineDurationScreen({super.key});
  @override
  ConsumerState<AddMedicineDurationScreen> createState() =>
      _AddMedicineDurationScreenState();
}

class _AddMedicineDurationScreenState extends ConsumerState<AddMedicineDurationScreen> {
  final daysCountController = TextEditingController();

  static const _options = [
    (
      kind: MedicineDurationKind.ongoing,
      title: 'Ongoing',
      subtitle: 'No end date — until I stop manually',
    ),
    (
      kind: MedicineDurationKind.untilDate,
      title: 'Until a specific date',
      subtitle: 'Pick an end date',
    ),
    (
      kind: MedicineDurationKind.forDays,
      title: 'For X days',
      subtitle: 'e.g., 7 days for an antibiotic course',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(addMedicineDraftNotifierProvider);
    _syncDaysController(draft.durationDayCount);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentDraft = ref.read(addMedicineDraftNotifierProvider);
      if (currentDraft.scheduleKind == MedicineScheduleKind.oneTime ||
          currentDraft.scheduleKind == MedicineScheduleKind.onDemand) {
        if (mounted) {
          context.replace('/add-medicine/more');
        }
        return;
      }
      ref.read(appPrdAnalyticsBridgeProvider).addMedDurationView();
    });
  }

  @override
  void dispose() {
    daysCountController.dispose();
    super.dispose();
  }

  void _syncDaysController(int? dayCount) {
    if (dayCount != null) {
      daysCountController.text = dayCount.toString();
    }
  }

  bool _canContinue(AddMedicineDraftStateModel draft) {
    switch (draft.durationKind) {
      case MedicineDurationKind.ongoing:
        return true;
      case MedicineDurationKind.untilDate:
        if (draft.endDate == null) return false;
        final today = DateTime.now();
        final todayNorm = DateTime(today.year, today.month, today.day);
        return !draft.endDate!.isBefore(todayNorm);
      case MedicineDurationKind.forDays:
        return (draft.durationDayCount ?? 0) > 0;
    }
  }

  Future<void> _pickEndDate(DateTime? current) async {
    final initial = current ?? DateTime.now().add(const Duration(days: 30));
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(today) ? today : initial,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365 * 10)),
    );
    if (picked == null || !mounted) return;
    ref.read(addMedicineDraftNotifierProvider.notifier).applyDurationEndDate(picked);
  }

  void _onSelectKind(MedicineDurationKind kind) {
    ref.read(appPrdAnalyticsBridgeProvider).addMedDurationSelected(kind);
    ref.read(addMedicineDraftNotifierProvider.notifier).applyDurationKind(kind);
    final draft = ref.read(addMedicineDraftNotifierProvider);
    if (kind == MedicineDurationKind.forDays) {
      _syncDaysController(draft.durationDayCount);
    }
  }

  void _onDayCountChanged(String text) {
    final parsed = int.tryParse(text.trim());
    if (parsed != null && parsed > 0) {
      ref.read(addMedicineDraftNotifierProvider.notifier).applyDurationDayCount(parsed);
    }
  }

  void _onQuickDayCountTap(int count) {
    ref.read(addMedicineDraftNotifierProvider.notifier).applyDurationDayCount(count);
    _syncDaysController(count);
  }

  void _onContinue() {
    final draft = ref.read(addMedicineDraftNotifierProvider);
    if (!_canContinue(draft)) return;
    context.push('/add-medicine/more');
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(addMedicineDraftNotifierProvider);
    final canContinue = _canContinue(draft);

    return AddFlowPageScaffold(
      headerTitle: 'Duration',
      stepLabel: '6 / 7',
      showBannerAd: true,
      bottomButton: PrimaryActionButton(
        label: 'Continue',
        onPressed: canContinue ? _onContinue : () {},
        backgroundColor:
            canContinue ? AppColors.primaryBlue : AppColors.textSecondary,
      ),
      children: [
        const AddMedicineFlowStepHeadingWidget(title: 'How long?'),
        for (final option in _options)
          AddMedicineScheduleOptionCardWidget(
            title: option.title,
            subtitle: option.subtitle,
            isSelected: draft.durationKind == option.kind,
            onTap: () => _onSelectKind(option.kind),
          ),
        AddMedicineDurationDetailsSectionWidget(
          durationKind: draft.durationKind,
          endDate: draft.endDate,
          durationDayCount: draft.durationDayCount,
          daysCountController: daysCountController,
          onPickEndDate: () => _pickEndDate(draft.endDate),
          onDayCountChanged: _onDayCountChanged,
          onQuickDayCountTap: _onQuickDayCountTap,
        ),
      ],
    );
  }
}
