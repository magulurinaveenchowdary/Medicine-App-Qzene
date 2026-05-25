import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

/// Typography tokens — Inter family (wireframe SF Pro equivalent on Android).
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get screenTitle => AppFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get cardTitle => AppFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get cardSubtitle => AppFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: AppColors.textSecondary,
      );

  static TextStyle get sectionLabel => AppFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        height: 1.2,
        color: AppColors.textSecondary,
      );

  static TextStyle get bigTime => AppFonts.inter(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -1,
        color: AppColors.textPrimary,
      );

  static TextStyle get adherencePercent => AppFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.1,
        color: AppColors.warningOrange,
      );

  static TextStyle get buttonLabel => AppFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.cardWhite,
      );

  static TextStyle get onboardingTitleLarge => AppFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get onboardingTitleMedium => AppFonts.inter(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get flowStepProgress => AppFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AppColors.textSecondary,
      );

  static TextStyle get navTabLabel => AppFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.1,
        color: AppColors.textSecondary,
      );

  static TextStyle get formLabelUppercase => AppFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        height: 1.2,
        color: AppColors.textSecondary,
      );

  static TextStyle get captionSponsored => AppFonts.inter(
        fontSize: 8,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textCaption,
      );

  static TextStyle get adPlaceholderLabel => AppFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );
}
