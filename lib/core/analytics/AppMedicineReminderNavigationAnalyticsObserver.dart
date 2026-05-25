import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'AppAnalyticsRouteScreenNameResolver.dart';

/// PRD §12.1 — one screen_view per navigation with screen_name + screen_class.
class AppMedicineReminderNavigationAnalyticsObserver extends NavigatorObserver {
  AppMedicineReminderNavigationAnalyticsObserver({
    required FirebaseAnalytics analytics,
  }) : _analytics = analytics;

  final FirebaseAnalytics _analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logScreen(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _logScreen(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _logScreen(newRoute);
    }
  }

  void _logScreen(Route<dynamic> route) {
    final screenName = _resolveScreenName(route);
    if (screenName == null || screenName.isEmpty) return;
    final screenClass = route.settings.name ?? screenName;
    _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  String? _resolveScreenName(Route<dynamic> route) {
    return AppAnalyticsRouteScreenNameResolver.screenNameForRouteName(
      route.settings.name,
    );
  }
}
