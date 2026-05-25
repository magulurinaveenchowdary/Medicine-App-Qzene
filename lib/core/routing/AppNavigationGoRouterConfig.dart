import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:med_reminder/core/analytics/AppMedicineReminderNavigationAnalyticsObserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';

import 'package:med_reminder/features/onboarding/application/AppOnboardingCompletionNotifier.dart';
import 'package:med_reminder/screens/onboarding/welcome_screen.dart';
import 'package:med_reminder/screens/onboarding/permissions_screen.dart';
import 'package:med_reminder/screens/onboarding/language_screen.dart';
import 'package:med_reminder/screens/onboarding/profile_screen.dart';
import 'package:med_reminder/screens/shell/main_tab_shell_screen.dart';
import 'package:med_reminder/screens/home/today_screen.dart';
import 'package:med_reminder/screens/medicines/list_screen.dart';
import 'package:med_reminder/screens/medicines/detail_screen.dart';
import 'package:med_reminder/screens/medicines/edit_screen.dart';
import 'package:med_reminder/screens/history/calendar_screen.dart';
import 'package:med_reminder/screens/history/day_detail_screen.dart';
import 'package:med_reminder/screens/settings/menu_screen.dart';
import 'package:med_reminder/screens/settings/profiles_screen.dart';
import 'package:med_reminder/screens/add_medicine/name_screen.dart';
import 'package:med_reminder/screens/add_medicine/category_screen.dart';
import 'package:med_reminder/screens/add_medicine/dose_screen.dart';
import 'package:med_reminder/screens/add_medicine/schedule_type_screen.dart';
import 'package:med_reminder/screens/add_medicine/schedule_details_screen.dart';
import 'package:med_reminder/screens/add_medicine/duration_screen.dart';
import 'package:med_reminder/screens/add_medicine/notes_screen.dart';
import 'package:med_reminder/screens/add_medicine/preview_screen.dart';
import 'package:med_reminder/screens/alarm/fullscreen_screen.dart';
import 'package:med_reminder/screens/alarm/snooze_sheet.dart';
import 'package:med_reminder/screens/after_call/single_screen.dart';
import 'package:med_reminder/screens/after_call/multi_screen.dart';
import 'package:med_reminder/screens/after_call/disable_confirm_sheet.dart';
import 'package:med_reminder/screens/shared/date_picker_sheet.dart';
/// Central [GoRouter] — paths mirror analytics `screen_name` where possible.
final GlobalKey<NavigatorState> appRootNavigatorKey = GlobalKey<NavigatorState>();

final appGoRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen<bool>(appOnboardingCompletionNotifierProvider, (previous, next) {
    refresh.value++;
  });

  /// Parses deep-link URIs (e.g., medreminder://after-call/single) to app routes.
  String? _parseDeepLinkToRoute(Uri uri) {
    if (uri.scheme == 'medreminder') {
      final path = uri.path;
      if (path.isNotEmpty) {
        // medreminder://after-call/single -> /after-call/single
        // medreminder://alarm?occurrenceId=... -> /alarm?occurrenceId=...
        if (uri.query.isNotEmpty) {
          return '$path?${uri.query}';
        }
        return path;
      }
    }
    return null;
  }

  return GoRouter(
    navigatorKey: appRootNavigatorKey,
    initialLocation: '/onboarding/welcome',
    refreshListenable: refresh,
    observers: [
      if (Firebase.apps.isNotEmpty)
        AppMedicineReminderNavigationAnalyticsObserver(
          analytics: FirebaseAnalytics.instance,
        ),
    ],
    redirect: (context, state) {
      // Handle deep-link URIs (e.g., medreminder://after-call/single)
      final deepLinkRoute = _parseDeepLinkToRoute(state.uri);
      if (deepLinkRoute != null && deepLinkRoute != state.matchedLocation) {
        return deepLinkRoute;
      }
      
      final completed = ref.read(appOnboardingCompletionNotifierProvider);
      final loc = state.matchedLocation;
      final inOnboarding = loc.startsWith('/onboarding');
      final inAlarmOrAfterCall = loc.startsWith('/alarm') || loc.startsWith('/after-call');
      if (!completed && !inOnboarding && !inAlarmOrAfterCall) {
        return '/onboarding/welcome';
      }
      if (completed && inOnboarding) {
        return '/main/today';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding/welcome',
        name: '/onboarding/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/permissions',
        name: '/onboarding/permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),
      GoRoute(
        path: '/onboarding/language',
        name: '/onboarding/language',
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/onboarding/profile',
        name: '/onboarding/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainTabShellScreen(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/today',
                name: '/main/today',
                builder: (context, state) => const TodayScreen(),
                routes: [
                  GoRoute(
                    path: 'date-picker',
                    parentNavigatorKey: appRootNavigatorKey,
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      opaque: false,
                      barrierDismissible: true,
                      transitionDuration: const Duration(milliseconds: 200),
                      child: const DatePickerSheet(),
                      transitionsBuilder: (context, animation, secondary, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/medicines',
                name: '/main/medicines',
                builder: (context, state) => const MedicinesListScreen(),
                routes: [
                  GoRoute(
                    path: 'detail/:medicineId',
                    name: '/main/medicines/detail',
                    builder: (context, state) {
                      final id = state.pathParameters['medicineId'] ?? '';
                      return MedicineDetailScreen(medicineRowId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: '/main/medicines/detail/edit',
                        builder: (context, state) {
                          final id = state.pathParameters['medicineId'] ?? '';
                          return MedicineEditScreen(medicineRowId: id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/history',
                name: '/main/history',
                builder: (context, state) => const HistoryCalendarScreen(),
                routes: [
                  GoRoute(
                    path: 'day/:ymd',
                    builder: (context, state) {
                      final ymd = state.pathParameters['ymd'] ?? '';
                      return HistoryDayDetailScreen(dayKey: ymd);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/settings',
                name: '/main/settings',
                builder: (context, state) => const SettingsMenuScreen(),
                routes: [
                  GoRoute(
                    path: 'profiles',
                    builder: (context, state) => const ProfilesScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/add-medicine/name',
        name: '/add-medicine/name',
        parentNavigatorKey: appRootNavigatorKey,
        builder: (context, state) => const AddMedicineNameScreen(),
      ),
      GoRoute(
        path: '/add-medicine/category',
        name: '/add-medicine/category',
        parentNavigatorKey: appRootNavigatorKey,
        builder: (context, state) => const AddMedicineCategoryScreen(),
      ),
      GoRoute(
        path: '/add-medicine/dose',
        name: '/add-medicine/dose',
        parentNavigatorKey: appRootNavigatorKey,
        builder: (context, state) => const AddMedicineDoseScreen(),
      ),
      GoRoute(
        path: '/add-medicine/schedule-type',
        name: '/add-medicine/schedule-type',
        parentNavigatorKey: appRootNavigatorKey,
        builder: (context, state) => const AddMedicineScheduleTypeScreen(),
      ),
      GoRoute(
        path: '/add-medicine/schedule-details',
        name: '/add-medicine/schedule-details',
        parentNavigatorKey: appRootNavigatorKey,
        builder: (context, state) => const AddMedicineScheduleDetailsScreen(),
      ),
      GoRoute(
        path: '/add-medicine/duration',
        name: '/add-medicine/duration',
        parentNavigatorKey: appRootNavigatorKey,
        builder: (context, state) => const AddMedicineDurationScreen(),
      ),
      GoRoute(
        path: '/add-medicine/more',
        name: '/add-medicine/more',
        parentNavigatorKey: appRootNavigatorKey,
        builder: (context, state) => const AddMedicineNotesScreen(),
      ),
      GoRoute(
        path: '/add-medicine/preview',
        name: '/add-medicine/preview',
        parentNavigatorKey: appRootNavigatorKey,
        builder: (context, state) => const AddMedicinePreviewScreen(),
      ),
      GoRoute(
        path: '/alarm',
        name: '/alarm',
        parentNavigatorKey: appRootNavigatorKey,
        builder: (context, state) {
          final consolidated =
              state.uri.queryParameters['consolidated'] == '1';
          final showMenu = state.uri.queryParameters['menu'] == '1';
          final occurrenceId = state.uri.queryParameters['occurrenceId'];
          return AlarmFullscreenScreen(
            isConsolidatedAlarm: consolidated,
            showPerMedMenu: showMenu,
            initialOccurrenceId: occurrenceId,
          );
        },
      ),
      GoRoute(
        path: '/alarm/snooze',
        parentNavigatorKey: appRootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          opaque: false,
          child: AlarmSnoozeSheet(
            medicineId: state.uri.queryParameters['medicineId'],
            isConsolidated: state.uri.queryParameters['consolidated'] == '1',
            medCount: int.tryParse(state.uri.queryParameters['medCount'] ?? '') ?? 1,
          ),
          transitionsBuilder: (context, animation, _, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: '/after-call/single',
        parentNavigatorKey: appRootNavigatorKey,
        builder: (context, state) => const AfterCallSmartDispatcher(),
      ),
      GoRoute(
        path: '/after-call/multi',
        parentNavigatorKey: appRootNavigatorKey,
        builder: (context, state) => const AfterCallMultiScreen(),
      ),
      GoRoute(
        path: '/after-call/disable-confirm',
        parentNavigatorKey: appRootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          opaque: false,
          child: const AfterCallDisableSheet(),
          transitionsBuilder: (context, animation, _, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ),
    ],
  );
});

class AfterCallSmartDispatcher extends ConsumerWidget {
  const AfterCallSmartDispatcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(medicineAppDataNotifierProvider);
    return dataAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CupertinoActivityIndicator()),
      ),
      error: (e, _) => const AfterCallSingleScreen(),
      data: (_) {
        final notifier = ref.read(medicineAppDataNotifierProvider.notifier);
        // Query upcoming doses in the next 4 hours (240 minutes)
        final upcomingDoses = notifier.upcomingDoseRowsWithinMinutes(240);
        if (upcomingDoses.length >= 3) {
          return const AfterCallMultiScreen();
        } else {
          return const AfterCallSingleScreen();
        }
      },
    );
  }
}
