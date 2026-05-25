import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

enum SecondaryActionButtonVariant { snooze, skip, outline }

/// Side-by-side or standalone secondary actions on alarm screens.
class SecondaryActionButton extends StatelessWidget {
  const SecondaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = SecondaryActionButtonVariant.snooze,
  });

  final String label;
  final VoidCallback onPressed;
  final SecondaryActionButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (variant) {
      SecondaryActionButtonVariant.snooze => (
          AppColors.snoozeButtonFill,
          AppColors.cardWhite,
        ),
      SecondaryActionButtonVariant.skip => (
          AppColors.skipButtonFill,
          AppColors.textPrimary,
        ),
      SecondaryActionButtonVariant.outline => (
          AppColors.cardWhite,
          AppColors.primaryBlue,
        ),
    };

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: variant == SecondaryActionButtonVariant.outline
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                  border: Border.all(color: AppColors.primaryBlue),
                )
              : null,
          child: Text(
            label,
            style: AppTextStyles.buttonLabel.copyWith(
              fontSize: 14,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}
