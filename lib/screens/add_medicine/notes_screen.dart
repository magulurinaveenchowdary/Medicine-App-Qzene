import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddFlowPageScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/FormSectionCardWidget.dart';
import 'package:med_reminder/core/widgets/common/PrimaryActionButtonWidget.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddMedicineFlowStepHeadingWidget.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/screens/add_medicine/components/AddMedicineNotesMoreStockSectionWidget.dart';

class AddMedicineNotesScreen extends ConsumerStatefulWidget {
  const AddMedicineNotesScreen({super.key});
  @override
  ConsumerState<AddMedicineNotesScreen> createState() =>
      _AddMedicineNotesScreenState();
}

class _AddMedicineNotesScreenState extends ConsumerState<AddMedicineNotesScreen> {
  final notesController = TextEditingController();
  final stockController = TextEditingController();
  final notesFocusNode = FocusNode();
  final stockFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final draft = ref.read(addMedicineDraftNotifierProvider);
    notesController.text = draft.notes ?? '';
    if (draft.stockRemaining != null) {
      stockController.text = draft.stockRemaining!.toInt().toString();
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    stockController.dispose();
    notesFocusNode.dispose();
    stockFocusNode.dispose();
    super.dispose();
  }

  void _persistDraftAndOpenPreview() {
    ref.read(addMedicineDraftNotifierProvider.notifier)
      ..applyNotes(notesController.text)
      ..applyStock(stockController.text);
    context.push('/add-medicine/preview');
  }

  void _onCriticalChanged(bool value) {
    ref.read(addMedicineDraftNotifierProvider.notifier).applyCriticalFlag(value);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(addMedicineDraftNotifierProvider);
    final showStockTracking = draft.scheduleKind != MedicineScheduleKind.onDemand;

    return AddFlowPageScaffold(
      headerTitle: 'More (optional)',
      stepLabel: '7 / 7',
      showBannerAd: true,
      bottomButton: PrimaryActionButton.take(
        label: 'Preview',
        onPressed: _persistDraftAndOpenPreview,
      ),
      children: [
        const AddMedicineFlowStepHeadingWidget(
          title: 'Anything else?',
          subtitle: 'All fields below are optional — skip if not needed.',
        ),
        FormSectionCard(
          label: 'Notes (optional)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CupertinoTextField(
                controller: notesController,
                focusNode: notesFocusNode,
                minLines: 2,
                maxLines: 4,
                textInputAction: showStockTracking
                    ? TextInputAction.next
                    : TextInputAction.done,
                decoration: const BoxDecoration(),
                style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                padding: EdgeInsets.zero,
                cursorColor: AppColors.primaryBlue,
                onSubmitted: (_) {
                  if (showStockTracking) {
                    FocusScope.of(context).requestFocus(stockFocusNode);
                  } else {
                    _persistDraftAndOpenPreview();
                  }
                },
              ),
              SizedBox(height: AppDimensions.gapSM),
              Text(
                'e.g., "before breakfast", "with food", "empty stomach". Shows on alarm card.',
                style: AppTextStyles.cardSubtitle.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
        if (showStockTracking)
          AddMedicineNotesMoreStockSectionWidget(
            stockController: stockController,
            stockFocusNode: stockFocusNode,
            doseUnit: draft.doseUnit,
            onSubmitted: _persistDraftAndOpenPreview,
          ),
        FormSectionCard(
          marginBottom: 0,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Critical medicine',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                    ),
                    SizedBox(height: AppDimensions.gapSM / 2),
                    Text(
                      'Persistent alarm if missed',
                      style: AppTextStyles.cardSubtitle.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: 'Critical medicine',
                toggled: draft.isCriticalMedicine,
                child: Transform.scale(
                  scale: 1.1,
                  child: CupertinoSwitch(
                    value: draft.isCriticalMedicine,
                    activeTrackColor: AppColors.healthGreen,
                    onChanged: _onCriticalChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
