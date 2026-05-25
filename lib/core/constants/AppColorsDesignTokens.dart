import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Back-compat shim — prefer [AppColors] in new code.
class AppColorsDesignTokens {
  AppColorsDesignTokens._();

  static const Color backgroundPrimary = AppColors.cardWhite;
  static const Color backgroundSecondary = AppColors.backgroundGrey;
  static const Color backgroundTertiary = AppColors.backgroundTertiary;
  static const Color colorPrimary = AppColors.primaryBlue;
  static const Color colorPrimaryTint = AppColors.primaryBlueTint;
  static const Color colorHealth = AppColors.healthGreen;
  static const Color colorHealthTint = AppColors.healthGreenTint;
  static const Color colorCritical = AppColors.criticalRed;
  static const Color colorWarning = AppColors.warningOrange;
  static const Color colorWarningTint = AppColors.warningOrangeTint;
  static const Color colorError = AppColors.errorRed;
  static const Color colorErrorTint = AppColors.errorRedTint;
  static const Color colorPurple = AppColors.purple;
  static const Color colorPurpleTint = AppColors.purpleTint;
  static const Color colorTeal = AppColors.teal;
  static const Color colorTealTint = AppColors.tealTint;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textTertiary = AppColors.textCaption;
  static const Color divider = AppColors.divider;
}
