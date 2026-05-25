import 'package:flutter/cupertino.dart';

/// Box shadows from Medicine_Reminder_Wireframes_v2 CSS.
class AppShadowDesignTokens {
  AppShadowDesignTokens._();

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 1),
      blurRadius: 4,
    ),
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 0),
      blurRadius: 1,
    ),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static const List<BoxShadow> fabShadow = [
    BoxShadow(
      color: Color(0x66007AFF),
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];
}
