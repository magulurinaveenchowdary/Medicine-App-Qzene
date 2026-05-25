import '../theme/app_dimensions.dart';

/// Back-compat spacing — prefer [AppDimensions] in new code.
class AppSpacingLayoutTokens {
  AppSpacingLayoutTokens._();

  static const double screenHorizontal = AppDimensions.paddingScreenH;
  static const double onboardingHorizontal = 22;
  static const double phoneContentPadding = AppDimensions.paddingScreenH;
  static const double phoneContentGap = AppDimensions.gapMD;
  static const double cardRadius = AppDimensions.radiusCard;
  static const double buttonRadius = AppDimensions.radiusButton;
  static const double fabSize = AppDimensions.fabSize;
  static const double fabBottomOffset = AppDimensions.fabBottomOffset;
  static const double minTouchTarget = AppDimensions.minTouchTarget;
  static const double bannerHeight = AppDimensions.adBannerHeight;
  static const double dateStripCellHeight = 52;
  static const double dateStripVerticalPadding = 10;
  static const double dateStripHorizontalPadding = 8;
  static const double topBarVerticalPadding = 10;
  static const double medCardPadding = AppDimensions.paddingCardInner;
  static const double medIconSize = AppDimensions.medIconSize;
  static const double profileAvatarSmall = AppDimensions.profileAvatarSmall;
  static const double profileAvatarLarge = AppDimensions.profileAvatarLarge;
}
