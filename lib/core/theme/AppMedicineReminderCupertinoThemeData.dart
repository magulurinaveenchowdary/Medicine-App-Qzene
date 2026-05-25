import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_text_styles.dart';
import 'app_theme.dart';

/// Cupertino-forward theme for Android (per build spec §1a).
class AppMedicineReminderCupertinoThemeData {
  AppMedicineReminderCupertinoThemeData._();

  static CupertinoThemeData buildCupertinoTheme() {
    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.backgroundGrey,
      barBackgroundColor: AppColors.cardWhite,
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.primaryBlue,
        textStyle: AppFonts.inter(
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
        navTitleTextStyle: AppTextStyles.cardTitle.copyWith(fontSize: 17),
      ),
    );
  }

  static ThemeData buildMaterialTheme() => AppTheme.light;
}
