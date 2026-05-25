import 'package:flutter/material.dart';

import '../constants/AppRootScaffoldMessengerKey.dart';
import '../theme/app_dimensions.dart';
import '../widgets/common/AppSnackBarContentWidget.dart';

/// Shows custom floating SnackBars via [AppSnackBarContentWidget].
class AppSnackBarShowHelpers {
  AppSnackBarShowHelpers._();

  static const Duration _defaultDuration = Duration(seconds: 3);

  static ScaffoldMessengerState? _messengerFor(BuildContext context) {
    if (!context.mounted) return null;
    return ScaffoldMessenger.maybeOf(context);
  }

  static EdgeInsets _defaultFloatingMargin(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    return EdgeInsets.fromLTRB(
      AppDimensions.paddingScreenH,
      0,
      AppDimensions.paddingScreenH,
      AppDimensions.gapLG + bottomSafe,
    );
  }

  static EdgeInsets _medicineListTabMargin(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    return EdgeInsets.fromLTRB(
      AppDimensions.paddingScreenH,
      0,
      AppDimensions.paddingScreenH,
      AppDimensions.bottomNavHeight +
          AppDimensions.adBannerHeight +
          AppDimensions.gapMD +
          bottomSafe,
    );
  }

  static SnackBar _buildSnackBar({
    required BuildContext context,
    required String message,
    required AppSnackBarVariantKind variant,
    required Duration duration,
    EdgeInsetsGeometry? margin,
    required ScaffoldMessengerState messenger,
  }) {
    return SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      margin: margin ?? _defaultFloatingMargin(context),
      content: SizedBox(
        width: double.infinity,
        child: AppSnackBarContentWidget(
          message: message,
          variant: variant,
          onDismiss: messenger.hideCurrentSnackBar,
        ),
      ),
    );
  }

  static void _showOnRootMessenger({
    required String message,
    required AppSnackBarVariantKind variant,
    Duration duration = _defaultDuration,
    EdgeInsetsGeometry? margin,
    bool clearPrevious = true,
  }) {
    final messenger = appRootScaffoldMessengerKey.currentState;
    if (messenger == null) return;
    if (clearPrevious) messenger.clearSnackBars();
    final context = messenger.context;
    messenger.showSnackBar(
      _buildSnackBar(
        context: context,
        message: message,
        variant: variant,
        duration: duration,
        margin: margin,
        messenger: messenger,
      ),
    );
  }

  /// Shows a SnackBar on the nearest [ScaffoldMessenger] for [context].
  static void show(
    BuildContext context, {
    required String message,
    required AppSnackBarVariantKind variant,
    Duration duration = _defaultDuration,
    EdgeInsetsGeometry? margin,
    bool clearPrevious = true,
  }) {
    final messenger = _messengerFor(context);
    if (messenger == null) return;
    if (clearPrevious) messenger.clearSnackBars();
    messenger.showSnackBar(
      _buildSnackBar(
        context: context,
        message: message,
        variant: variant,
        duration: duration,
        margin: margin,
        messenger: messenger,
      ),
    );
  }

  /// Root messenger (see [appRootScaffoldMessengerKey]) when no local scaffold applies.
  static void showOnAppRoot({
    required String message,
    required AppSnackBarVariantKind variant,
    Duration duration = _defaultDuration,
    EdgeInsetsGeometry? margin,
    bool clearPrevious = true,
  }) {
    _showOnRootMessenger(
      message: message,
      variant: variant,
      duration: duration,
      margin: margin,
      clearPrevious: clearPrevious,
    );
  }

  /// Success toast after add-medicine save — uses root messenger after [GoRouter.go].
  ///
  /// Waits for navigation to finish (add-flow overlay popped, medicines tab visible).
  static void scheduleMedicineSavedToast(String message) {
    void attemptShow({int framesLeft = 4}) {
      final messenger = appRootScaffoldMessengerKey.currentState;
      if (messenger == null) {
        if (framesLeft <= 0) return;
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => attemptShow(framesLeft: framesLeft - 1),
        );
        return;
      }
      _showOnRootMessenger(
        message: message,
        variant: AppSnackBarVariantKind.success,
        margin: _medicineListTabMargin(messenger.context),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => attemptShow());
    });
  }
}
