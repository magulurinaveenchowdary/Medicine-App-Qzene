import 'package:flutter/material.dart';

import 'app_text_styles.dart';

/// Back-compat typography — prefer [AppTextStyles] in new code.
class AppTypographyDesignTokens {
  AppTypographyDesignTokens._();

  static TextStyle get onboardingTitleLarge => AppTextStyles.onboardingTitleLarge;
  static TextStyle get onboardingTitleMedium => AppTextStyles.onboardingTitleMedium;
  static TextStyle get screenTitleBold => AppTextStyles.screenTitle;
  static TextStyle get screenSubtitle => AppTextStyles.cardSubtitle;
  static TextStyle get formLabelUppercase => AppTextStyles.formLabelUppercase;
  static TextStyle get sectionHeaderUppercase => AppTextStyles.sectionLabel;
  static TextStyle get navTabLabel => AppTextStyles.navTabLabel;
  static TextStyle get flowStepProgress => AppTextStyles.flowStepProgress;
}
