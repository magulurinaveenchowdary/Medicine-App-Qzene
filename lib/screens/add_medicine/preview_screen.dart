import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:med_reminder/core/analytics/AppAnalyticsMappingHelpers.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/scheduling/MedicineScheduleFireCalculator.dart';
import 'package:med_reminder/core/scheduling/MedicineScheduleOccurrenceGenerator.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/utils/AddMedicinePreviewMedicineBuilderHelpers.dart';
import 'package:med_reminder/core/utils/AppSnackBarShowHelpers.dart';
import 'package:med_reminder/core/widgets/common/AppSnackBarContentWidget.dart';
import 'package:med_reminder/core/widgets/common/AddFlowHeaderWidget.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddFlowBodyLayoutWidget.dart';
import 'package:med_reminder/core/widgets/common/PrimaryActionButtonWidget.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/screens/add_medicine/components/AddMedicinePreviewFiresSectionWidget.dart';
import 'package:med_reminder/screens/add_medicine/components/AddMedicinePreviewSummaryCardWidget.dart';

class AddMedicinePreviewScreen extends ConsumerStatefulWidget {
  const AddMedicinePreviewScreen({super.key});
  @override
  ConsumerState<AddMedicinePreviewScreen> createState() =>
      _AddMedicinePreviewScreenState();
}

class _AddMedicinePreviewScreenState extends ConsumerState<AddMedicinePreviewScreen> {
  var _isSaving = false;
  var _didLogPreviewView = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _logPreviewViewOnce());
  }

  void _logPreviewViewOnce() {
    if (_didLogPreviewView) return;
    _didLogPreviewView = true;
    final draft = ref.read(addMedicineDraftNotifierProvider);
    final previewMedicine =
        AddMedicinePreviewMedicineBuilderHelpers.buildFromDraft(draft);
    final fireCount = MedicineScheduleOccurrenceGenerator.generateBetween(
      medicine: previewMedicine,
      rangeStart: DateTime.now(),
      rangeEnd: DateTime.now().add(const Duration(days: 120)),
    ).length;
    ref.read(appPrdAnalyticsBridgeProvider).addMedPreviewViewWithSchedule(
          scheduleType:
              AppAnalyticsMappingHelpers.scheduleTypeValue(draft.scheduleKind),
          nextFiresCount: fireCount.clamp(0, 5),
        );
  }

  String _buildSummaryLine(
    AddMedicineDraftStateModel draft,
    MedicineStoredRecordModel previewMedicine,
  ) {
    final doseLine = MedicineScheduleFireCalculator.buildDoseDescription(
      amount: draft.doseAmount,
      unit: draft.doseUnit,
    );
    final scheduleLine =
        MedicineScheduleFireCalculator.buildScheduleSummary(previewMedicine);
    final showDurationLine = draft.scheduleKind != MedicineScheduleKind.oneTime &&
        draft.scheduleKind != MedicineScheduleKind.onDemand;
    final durationLine = switch (draft.durationKind) {
      MedicineDurationKind.ongoing => 'Ongoing',
      MedicineDurationKind.untilDate => draft.endDate != null
          ? 'Until ${DateFormat.yMMMd().format(draft.endDate!)}'
          : 'Until date',
      MedicineDurationKind.forDays => 'For ${draft.durationDayCount ?? 0} days',
    };
    return [
      doseLine,
      scheduleLine,
      if (showDurationLine) durationLine,
    ].join(' · ');
  }

  Future<void> _confirmSave() async {
    if (_isSaving) return;
    final draft = ref.read(addMedicineDraftNotifierProvider);
    if (draft.displayName.trim().isEmpty) {
      AppSnackBarShowHelpers.show(
        context,
        message: 'Medicine name is required',
        variant: AppSnackBarVariantKind.error,
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref
          .read(medicineAppDataNotifierProvider.notifier)
          .saveMedicineFromDraft(draft);
      if (!mounted) return;
      final savedName = draft.displayName.trim();
      context.go('/main/medicines');
      AppSnackBarShowHelpers.scheduleMedicineSavedToast('$savedName saved');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _onBack() {
    ref.read(appPrdAnalyticsBridgeProvider).addMedCancelled('preview');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(addMedicineDraftNotifierProvider);
    final previewMedicine =
        AddMedicinePreviewMedicineBuilderHelpers.buildFromDraft(draft);
    final nextFires = MedicineScheduleFireCalculator.nextFireDateTimes(
      medicine: previewMedicine,
      from: DateTime.now(),
      count: 5,
    );
    final summaryLine = _buildSummaryLine(draft, previewMedicine);
    final notesLine = draft.notes != null && draft.notes!.trim().isNotEmpty
        ? 'Notes: ${draft.notes!.trim()}'
        : null;
    final saveLabel = draft.isEditMode
        ? (_isSaving ? 'Saving…' : 'Save changes ✓')
        : (_isSaving ? 'Saving…' : 'Confirm & Save ✓');

    return Material(
      color: AppColors.cardWhite,
      child: SafeArea(
        child: Column(
          children: [
            AddFlowHeader(
              title: 'Preview',
              trailingSubtitleLabel: 'Final check',
              onBack: _onBack,
            ),
            AddFlowBodyLayout(
              showBannerAd: true,
              bottomButton: PrimaryActionButton(
                label: saveLabel,
                onPressed: _isSaving ? () {} : _confirmSave,
                backgroundColor:
                    _isSaving ? AppColors.textSecondary : AppColors.healthGreen,
              ),
              children: [
                AddMedicinePreviewSummaryCardWidget(
                  displayName: draft.displayName,
                  ingredientLine: draft.ingredientLine,
                  summaryLine: summaryLine,
                  notesLine: notesLine,
                ),
                SizedBox(height: AppDimensions.gapMD),
                AddMedicinePreviewFiresSectionWidget(
                  scheduleKind: draft.scheduleKind,
                  nextFires: nextFires,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
