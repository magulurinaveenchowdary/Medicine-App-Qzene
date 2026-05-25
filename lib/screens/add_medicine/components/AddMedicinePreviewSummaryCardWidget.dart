import 'package:flutter/material.dart';
import 'package:med_reminder/core/constants/AppShadowDesignTokens.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/MedicinePillIconWidget.dart';

/// Medicine name + dose / schedule / duration summary on preview (wireframe screen 21).
class AddMedicinePreviewSummaryCardWidget extends StatelessWidget {
  const AddMedicinePreviewSummaryCardWidget({
    super.key,
    required this.displayName,
    required this.summaryLine,
    this.notesLine,
    this.ingredientLine,
  });

  final String displayName;
  final String summaryLine;
  final String? notesLine;
  final String? ingredientLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingCardInner),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: AppShadowDesignTokens.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryBlueTint,
              borderRadius: BorderRadius.circular(AppDimensions.gapSM),
            ),
            child: const MedicinePillIconWidget(
              size: 32,
              primaryColor: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: AppDimensions.gapMD),
          Text(
            displayName,
            style: AppTextStyles.screenTitle.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          if (ingredientLine != null && ingredientLine!.trim().isNotEmpty) ...[
            SizedBox(height: AppDimensions.gapSM / 2),
            Text(
              ingredientLine!,
              textAlign: TextAlign.center,
              style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
            ),
          ],
          SizedBox(height: AppDimensions.gapSM / 2),
          Text(
            summaryLine,
            textAlign: TextAlign.center,
            style: AppTextStyles.cardSubtitle.copyWith(fontSize: 13),
          ),
          if (notesLine != null) ...[
            SizedBox(height: AppDimensions.gapSM),
            Text(
              notesLine!,
              textAlign: TextAlign.center,
              style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
