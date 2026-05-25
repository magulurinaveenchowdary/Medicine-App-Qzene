import 'package:flutter/material.dart';

import '../../constants/AppShadowDesignTokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

/// White grouped card used across onboarding and add-medicine forms.
class FormSectionCard extends StatelessWidget {
  const FormSectionCard({
    super.key,
    this.label,
    this.child,
    this.padding,
    this.selectedBorder = false,
    this.marginBottom = AppDimensions.gapMD,
    this.expandChildToFill = false,
  });

  final String? label;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final bool selectedBorder;
  final double marginBottom;
  final bool expandChildToFill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: marginBottom),
      padding: padding ??
          const EdgeInsets.all(AppDimensions.paddingCardInner),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: selectedBorder
            ? Border.all(color: AppColors.primaryBlue, width: 2)
            : null,
        boxShadow: AppShadowDesignTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize:
            expandChildToFill ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (label != null) ...[
            Text(
              label!.toUpperCase(),
              style: AppTextStyles.formLabelUppercase,
            ),
            SizedBox(height: AppDimensions.gapSM - 2),
          ],
          if (child != null)
            expandChildToFill
                ? Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: child!,
                    ),
                  )
                : child!,
        ],
      ),
    );
  }
}
