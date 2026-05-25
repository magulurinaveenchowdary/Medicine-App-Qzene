import 'package:flutter/cupertino.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/utils/MedicineDoseUnitDisplayHelpers.dart';
import 'package:med_reminder/core/widgets/common/FormSectionCardWidget.dart';

/// Stock count + unit suffix row (PRD §6.3 optional More — wireframe screen 25).
class AddMedicineNotesMoreStockSectionWidget extends StatelessWidget {
  const AddMedicineNotesMoreStockSectionWidget({
    super.key,
    required this.stockController,
    required this.stockFocusNode,
    required this.doseUnit,
    required this.onSubmitted,
  });

  final TextEditingController stockController;
  final FocusNode stockFocusNode;
  final String doseUnit;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final stockUnitLabel =
        MedicineDoseUnitDisplayHelpers.buildStockLeftUnitLabel(doseUnit);

    return FormSectionCard(
      label: 'Stock tracking (optional)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: CupertinoTextField(
                  controller: stockController,
                  focusNode: stockFocusNode,
                  placeholder: 'e.g., 30',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: const BoxDecoration(),
                  style: AppTextStyles.screenTitle.copyWith(
                    fontSize: AppDimensions.addFlowDoseAmountFontSize,
                  ),
                  padding: EdgeInsets.zero,
                  cursorColor: AppColors.primaryBlue,
                  onSubmitted: (_) => onSubmitted(),
                ),
              ),
              SizedBox(width: AppDimensions.gapSM),
              Text(
                stockUnitLabel,
                style: AppTextStyles.cardSubtitle.copyWith(fontSize: 13),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.gapSM),
          Text(
            "We'll remind you to refill when stock is low.",
            style: AppTextStyles.cardSubtitle.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
