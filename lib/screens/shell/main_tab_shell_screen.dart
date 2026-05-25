import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/AppAnalyticsEventNamesConstants.dart';
import 'package:med_reminder/core/constants/AppAnalyticsScreenNameConstants.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/core/services/AppFirebaseAnalyticsLoggingService.dart';
import 'package:med_reminder/core/widgets/common/AppMedicineRootPageScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/ShellScreenWidgets/ShellBottomTabBarWidget.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

class MainTabShellScreen extends ConsumerStatefulWidget {
  const MainTabShellScreen({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainTabShellScreen> createState() => _MainTabShellScreenState();
}

class _MainTabShellScreenState extends ConsumerState<MainTabShellScreen> {
  static const _tabScreenNames = [
    AppAnalyticsScreenNameConstants.homeToday,
    AppAnalyticsScreenNameConstants.medicinesList,
    AppAnalyticsScreenNameConstants.historyCalendar,
    AppAnalyticsScreenNameConstants.settingsMain,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logTabAnalytics(widget.navigationShell.currentIndex);
    });
  }

  void _logTabAnalytics(int index) {
    final analytics = ref.read(appFirebaseAnalyticsLoggingServiceProvider);
    analytics.logScreenView(screenName: _tabScreenNames[index]);
    switch (index) {
      case 1:
        final meds = ref.read(medicineAppDataNotifierProvider).valueOrNull;
        if (meds != null) {
          final profileId = ref.read(activeUserProfileIdProvider);
          final all = meds.medicines.where((m) => m.profileId == profileId);
          analytics.logPrdEvent(
            AppAnalyticsEventNamesConstants.medlistView,
            {
              'total_count': all.length,
              'scheduled_count': all.where((m) => !m.isOnDemand && !m.isPaused).length,
              'on_demand_count': all.where((m) => m.isOnDemand).length,
              'paused_count': all.where((m) => m.isPaused).length,
              'completed_count': 0,
            },
          );
        }
      case 2:
        analytics.logPrdEvent(AppAnalyticsEventNamesConstants.historyView, {
          'days_shown': 30,
          'total_taken': 0,
          'total_skipped': 0,
          'total_missed': 0,
        });
      case 3:
        analytics.logPrdEvent(AppAnalyticsEventNamesConstants.settingsView);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppMedicineRootPageScaffold(
      backgroundColor: AppColorsDesignTokens.backgroundSecondary,
      child: Column(
        children: [
          Expanded(child: widget.navigationShell),
          ShellBottomTabBar(
            currentIndex: widget.navigationShell.currentIndex,
            onTap: (i) {
              widget.navigationShell.goBranch(
                i,
                initialLocation: i == widget.navigationShell.currentIndex,
              );
              _logTabAnalytics(i);
            },
            todayLabel: l10n.todayTab,
            medicinesLabel: l10n.medicinesTab,
            historyLabel: l10n.historyTab,
            settingsLabel: l10n.settingsTab,
          ),
        ],
      ),
    );
  }
}
