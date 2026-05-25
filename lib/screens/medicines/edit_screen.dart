import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/scheduling/MedicineScheduleFireCalculator.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/theme/app_fonts.dart';
import 'package:med_reminder/core/widgets/common/AdBannerWidget.dart';
import 'package:med_reminder/core/widgets/common/AppCardWidget.dart';
import 'package:med_reminder/core/widgets/common/AppSnackBarContentWidget.dart';
import 'package:med_reminder/core/utils/AppSnackBarShowHelpers.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/core/utils/AddMedicinePreviewMedicineBuilderHelpers.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

class MedicineEditScreen extends ConsumerStatefulWidget {
  const MedicineEditScreen({super.key, required this.medicineRowId});
  final String medicineRowId;

  @override
  ConsumerState<MedicineEditScreen> createState() => _MedicineEditScreenState();
}

class _MedicineEditScreenState extends ConsumerState<MedicineEditScreen> {
  late final TextEditingController nameController;
  late final TextEditingController notesController;
  bool _isDraftInitialized = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    notesController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appPrdAnalyticsBridgeProvider).editMedView(widget.medicineRowId);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    notesController.dispose();
    // Clean up draft state when leaving edit flow
    ref.read(addMedicineDraftNotifierProvider.notifier).resetDraft();
    super.dispose();
  }

  Future<void> _save() async {
    final medicine = ref
        .read(medicineAppDataNotifierProvider.notifier)
        .medicineById(widget.medicineRowId);
    if (medicine == null) return;

    if (nameController.text.trim().isEmpty) {
      AppSnackBarShowHelpers.show(
        context,
        message: 'Medicine name is required',
        variant: AppSnackBarVariantKind.error,
      );
      return;
    }

    final draftNotifier = ref.read(addMedicineDraftNotifierProvider.notifier);

    // Apply current text controller fields to the draft
    draftNotifier
      ..applyCustomMedicineName(nameController.text.trim())
      ..applyNotes(notesController.text.trim());

    final draft = ref.read(addMedicineDraftNotifierProvider);
    final fieldsChanged = <String>[];

    if (nameController.text.trim() != medicine.displayName) {
      fieldsChanged.add('name');
    }
    if (notesController.text.trim() != (medicine.notes ?? '')) {
      fieldsChanged.add('notes');
    }
    if (draft.doseAmount != medicine.doseAmount || draft.doseUnit != medicine.doseUnit) {
      fieldsChanged.add('dose');
    }
    if (draft.scheduleKind != medicine.scheduleKind ||
        draft.doseMinutesOfDay.toString() != medicine.doseMinutesOfDay.toString()) {
      fieldsChanged.add('schedule');
    }

    if (draft.doseMinutesOfDay.length > 1 &&
        draft.doseMinutesOfDay.toString() != medicine.doseMinutesOfDay.toString()) {
      final bridge = ref.read(appPrdAnalyticsBridgeProvider);
      await bridge.editMedTimeShiftPrompt(medicine.doseMinutesOfDay.length);
      await bridge.editMedTimeShiftResult('shift_all');
    }

    await ref.read(medicineAppDataNotifierProvider.notifier).updateMedicineFromDraftWithAnalytics(
          medicineId: widget.medicineRowId,
          draft: draft.copyWith(
            displayName: nameController.text.trim(),
            editingMedicineId: widget.medicineRowId,
          ),
          originalMedicine: medicine,
          fieldsChanged: fieldsChanged,
        );

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final medicine = ref.watch(medicineAppDataNotifierProvider).maybeWhen(
          data: (_) => ref
              .read(medicineAppDataNotifierProvider.notifier)
              .medicineById(widget.medicineRowId),
          orElse: () => null,
        );

    if (medicine == null) {
      return const CupertinoPageScaffold(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    if (!_isDraftInitialized) {
      _isDraftInitialized = true;
      nameController.text = medicine.displayName;
      notesController.text = medicine.notes ?? '';
      
      final draftNotifier = ref.read(addMedicineDraftNotifierProvider.notifier);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        draftNotifier.loadFromMedicine(medicine);
      });
    }

    final draft = ref.watch(addMedicineDraftNotifierProvider);
    final tempMedicine = AddMedicinePreviewMedicineBuilderHelpers.buildFromDraft(draft);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundGrey,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.cardWhite,
        border: const Border(bottom: BorderSide(color: AppColors.divider)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            ref.read(appPrdAnalyticsBridgeProvider).editMedCancelled(
                  hadChanges: nameController.text.trim() != (medicine.displayName) ||
                      notesController.text.trim() != (medicine.notes ?? ''),
                );
            context.pop();
          },
          child: Text(
            l10n.cancel,
            style: AppFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        middle: Text(
          'Edit Medicine',
          style: AppFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: Text(
            'Save',
            style: AppFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingScreenH,
                  vertical: 20,
                ),
                children: [
                  _EditFieldCard(
                    label: 'NAME',
                    child: CupertinoTextField(
                      controller: nameController,
                      decoration: const BoxDecoration(),
                      style: AppFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      padding: EdgeInsets.zero,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EditFieldCard(
                    label: 'DOSE',
                    child: Text(
                      MedicineScheduleFireCalculator.buildDoseDescription(
                        amount: draft.doseAmount,
                        unit: draft.doseUnit,
                      ),
                      style: AppFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      context.push('/add-medicine/dose');
                    },
                  ),
                  const SizedBox(height: 16),
                  _EditFieldCard(
                    label: 'SCHEDULE',
                    child: Text(
                      MedicineScheduleFireCalculator.buildScheduleSummary(tempMedicine),
                      style: AppFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      context.push('/add-medicine/schedule-type');
                    },
                  ),
                  const SizedBox(height: 16),
                  _EditFieldCard(
                    label: 'NOTES (OPTIONAL)',
                    child: CupertinoTextField(
                      controller: notesController,
                      decoration: const BoxDecoration(),
                      style: AppFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      padding: EdgeInsets.zero,
                      placeholder: 'before breakfast',
                      placeholderStyle: AppFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: AdBanner(placement: 'edit_med'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditFieldCard extends StatelessWidget {
  const _EditFieldCard({
    required this.label,
    required this.child,
    this.onTap,
  });

  final String label;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.formLabelUppercase.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: cardContent,
    );
  }
}
