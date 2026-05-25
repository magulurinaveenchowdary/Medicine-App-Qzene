import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../analytics/AppPrdAnalyticsBridge.dart';

/// Logs PRD `onb_skipped` when user leaves onboarding before completion.
class OnboardingAnalyticsPopScope extends ConsumerWidget {
  const OnboardingAnalyticsPopScope({
    super.key,
    required this.atStep,
    required this.child,
  });

  final String atStep;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ref.read(appPrdAnalyticsBridgeProvider).onbSkipped(atStep);
        }
      },
      child: child,
    );
  }
}

String onboardingStepFromLocation(String location) {
  if (location.contains('/permissions')) return 'notif';
  if (location.contains('/language')) return 'region';
  if (location.contains('/profile')) return 'profile';
  return 'notif';
}
