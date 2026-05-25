import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_fonts.dart';
import 'app_text_styles.dart';

/// Material [ThemeData] aligned to wireframes v2.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppFonts.family,
      scaffoldBackgroundColor: AppColors.backgroundGrey,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        onPrimary: AppColors.cardWhite,
        surface: AppColors.cardWhite,
        onSurface: AppColors.textPrimary,
        secondary: AppColors.textSecondary,
        error: AppColors.errorRed,
      ),
      dividerColor: AppColors.divider,
      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: 1,
        shadowColor: const Color(0x0F000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.cardWhite,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: AppTextStyles.cardTitle.copyWith(fontSize: 17),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardWhite,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTextStyles.navTabLabel,
        unselectedLabelStyle: AppTextStyles.navTabLabel,
      ),
    );

    return base.copyWith(
      textTheme: AppFonts.interTextTheme(base.textTheme),
    );
  }
}
