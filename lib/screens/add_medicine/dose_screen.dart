import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/screens/add_medicine/unit_picker_sheet.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddFlowPageScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/FormSectionCardWidget.dart';
import 'package:med_reminder/core/widgets/common/PrimaryActionButtonWidget.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddMedicineFlowStepHeadingWidget.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';

class AddMedicineDoseScreen extends ConsumerStatefulWidget {
  const AddMedicineDoseScreen({super.key});
  @override
  ConsumerState<AddMedicineDoseScreen> createState() =>
      _AddMedicineDoseScreenState();
}

class _AddMedicineDoseScreenState extends ConsumerState<AddMedicineDoseScreen> {
  final amountController = TextEditingController(text: '1');
  final amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final draft = ref.read(addMedicineDraftNotifierProvider);
    amountController.text = draft.doseAmount == draft.doseAmount.roundToDouble()
        ? draft.doseAmount.toInt().toString()
        : draft.doseAmount.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appPrdAnalyticsBridgeProvider).addMedDoseView();
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(addMedicineDraftNotifierProvider);
    return AddFlowPageScaffold(
      headerTitle: 'Dose',
      stepLabel: '3 / 7',
      showBannerAd: true,
      bottomButton: PrimaryActionButton(
        label: draft.isEditMode ? 'Done' : 'Continue',
        onPressed: () {
          ref
              .read(addMedicineDraftNotifierProvider.notifier)
              .applyDoseAmount(amountController.text);
          if (draft.isEditMode) {
            context.pop();
          } else {
            context.push('/add-medicine/schedule-type');
          }
        },
      ),
      children: [
        const AddMedicineFlowStepHeadingWidget(
          title: 'How much do you take?',
          subtitle: 'For each dose.',
          bottomSpacing: AppDimensions.gapMD,
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: FormSectionCard(
                  expandChildToFill: true,
                  marginBottom: 0,
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.paddingCardInner,
                    AppDimensions.gapLG,
                    AppDimensions.paddingCardInner,
                    AppDimensions.gapLG,
                  ),
                  label: 'Amount',
                  child: CupertinoTextField(
                    controller: amountController,
                    focusNode: amountFocusNode,
                    decoration: const BoxDecoration(),
                    style: AppTextStyles.screenTitle.copyWith(
                      fontSize: AppDimensions.addFlowDoseAmountFontSize,
                    ),
                    padding: EdgeInsets.zero,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (v) => ref
                        .read(addMedicineDraftNotifierProvider.notifier)
                        .applyDoseAmount(v),
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.gapSM),
              SizedBox(
                width: AppDimensions.addFlowUnitColumnWidth,
                child: FormSectionCard(
                  expandChildToFill: true,
                  marginBottom: 0,
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.paddingCardInner,
                    AppDimensions.gapLG,
                    AppDimensions.paddingCardInner,
                    AppDimensions.gapLG,
                  ),
                  label: 'Unit',
                  child: GestureDetector(
                    onTap: () => AddMedicineUnitPickerSheet.show(context),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            draft.doseUnit,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.cardTitle.copyWith(
                              fontSize: AppDimensions.addFlowDoseUnitFontSize,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.chevron_down,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: AppDimensions.gapSM,
            left: AppDimensions.gapSM / 2,
          ),
          child: Text(
            '✓ Auto-selected from ${draft.categoryFormLabel}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardSubtitle.copyWith(
              fontSize: 11,
              color: AppColors.healthGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
