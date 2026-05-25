import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Wireframes use iOS SF Pro. On Android we use [GoogleFonts.inter] — the closest
/// legal cross-platform match (same metrics, weight scale, and UI feel).
class AppFonts {
  AppFonts._();

  static String get family => GoogleFonts.inter().fontFamily!;

  /// Base text style for all [AppTextStyles] tokens.
  static TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    Color? color,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
      fontStyle: fontStyle,
      decoration: TextDecoration.none,
      decorationColor: Colors.transparent,
    );
  }

  static TextTheme interTextTheme(TextTheme base) => GoogleFonts.interTextTheme(base);
}
