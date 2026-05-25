import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analytics/AppAnalyticsMappingHelpers.dart';
import '../constants/AppAnalyticsEventNamesConstants.dart';
import '../constants/AppAnalyticsParameterNamesConstants.dart';
import '../services/AppFirebaseAnalyticsLoggingService.dart';
import '../../features/medicines/domain/MedicineReminderDataModels.dart';

final appPrdAnalyticsBridgeProvider = Provider<AppPrdAnalyticsBridge>(
  (ref) => AppPrdAnalyticsBridge(ref.watch(appFirebaseAnalyticsLoggingServiceProvider)),
);

/// PRD §12 — typed helpers so screens log consistent event + parameter names.
class AppPrdAnalyticsBridge {
  AppPrdAnalyticsBridge(this._analytics);

  final AppFirebaseAnalyticsLoggingService _analytics;

  Future<void> _e(String name, [Map<String, Object>? p]) =>
      _analytics.logPrdEvent(name, p);

  // —— Add medicine funnel ——
  Future<void> addMedStarted(String source) => _e(
        AppAnalyticsEventNamesConstants.addmedStarted,
        {AppAnalyticsParameterNamesConstants.source: source},
      );

  Future<void> addMedNameScreenView() =>
      _e(AppAnalyticsEventNamesConstants.addmedNameScreenView);

  Future<void> addMedSearchResults({
    required int queryLength,
    required int resultCount,
    required bool hasFuzzyMatch,
  }) =>
      _e(AppAnalyticsEventNamesConstants.addmedSearchResults, {
        AppAnalyticsParameterNamesConstants.queryLength: queryLength,
        AppAnalyticsParameterNamesConstants.resultCount: resultCount,
        AppAnalyticsParameterNamesConstants.hasFuzzyMatch: hasFuzzyMatch,
      });

  Future<void> addMedSuggestionSelected({
    required String source,
    required int queryLength,
  }) =>
      _e(AppAnalyticsEventNamesConstants.addmedSuggestionSelected, {
        AppAnalyticsParameterNamesConstants.source: source,
        AppAnalyticsParameterNamesConstants.queryLength: queryLength,
      });

  Future<void> addMedCustomAdded(int nameLength) => _e(
        AppAnalyticsEventNamesConstants.addmedCustomAdded,
        {AppAnalyticsParameterNamesConstants.nameLength: nameLength},
      );

  Future<void> addMedCategoryView() =>
      _e(AppAnalyticsEventNamesConstants.addmedCategoryView);

  Future<void> addMedCategorySelected(String category) => _e(
        AppAnalyticsEventNamesConstants.addmedCategorySelected,
        {AppAnalyticsParameterNamesConstants.category: category},
      );

  Future<void> addMedDoseView() => _e(AppAnalyticsEventNamesConstants.addmedDoseView);

  Future<void> addMedUnitSelected(String unit, {required bool wasDefault}) => _e(
        AppAnalyticsEventNamesConstants.addmedUnitSelected,
        {
          AppAnalyticsParameterNamesConstants.unit: unit,
          AppAnalyticsParameterNamesConstants.wasDefault: wasDefault,
        },
      );

  Future<void> addMedUnitCustomEntered(int unitLength) => _e(
        AppAnalyticsEventNamesConstants.addmedUnitCustomEntered,
        {AppAnalyticsParameterNamesConstants.unitLength: unitLength},
      );

  Future<void> addMedScheduleTypeView() =>
      _e(AppAnalyticsEventNamesConstants.addmedScheduleTypeView);

  Future<void> addMedScheduleSelected(MedicineScheduleKind kind) => _e(
        AppAnalyticsEventNamesConstants.addmedScheduleSelected,
        {
          AppAnalyticsParameterNamesConstants.scheduleType:
              AppAnalyticsMappingHelpers.scheduleTypeValue(kind),
        },
      );

  Future<void> addMedScheduleDetailsView(MedicineScheduleKind kind) => _e(
        AppAnalyticsEventNamesConstants.addmedScheduleDetailsView,
        {
          AppAnalyticsParameterNamesConstants.scheduleType:
              AppAnalyticsMappingHelpers.scheduleTypeValue(kind),
        },
      );

  Future<void> addMedDurationView() =>
      _e(AppAnalyticsEventNamesConstants.addmedDurationView);

  Future<void> addMedDurationSelected(MedicineDurationKind kind) => _e(
        AppAnalyticsEventNamesConstants.addmedDurationSelected,
        {
          AppAnalyticsParameterNamesConstants.type:
              AppAnalyticsMappingHelpers.durationTypeValue(kind),
        },
      );

  Future<void> addMedPreviewView() =>
      _e(AppAnalyticsEventNamesConstants.addmedPreviewView);

  Future<void> addMedCancelled(String exitStep) => _e(
        AppAnalyticsEventNamesConstants.addmedCancelled,
        {AppAnalyticsParameterNamesConstants.exitStep: exitStep},
      );

  // —— Home ——
  Future<void> homeMedicineTapped({
    required String medicineId,
    required MedicineScheduleKind scheduleKind,
    required String status,
    required String viewedDate,
  }) =>
      _e(AppAnalyticsEventNamesConstants.homeMedicineTapped, {
        AppAnalyticsParameterNamesConstants.medicineId: medicineId,
        AppAnalyticsParameterNamesConstants.scheduleType:
            AppAnalyticsMappingHelpers.scheduleTypeValue(scheduleKind),
        AppAnalyticsParameterNamesConstants.status: status,
        AppAnalyticsParameterNamesConstants.viewedDate: viewedDate,
      });

  Future<void> homeDatestripSwiped({
    required String direction,
    required String fromWeekStart,
    required String toWeekStart,
  }) =>
      _e(AppAnalyticsEventNamesConstants.homeDatestripSwiped, {
        AppAnalyticsParameterNamesConstants.direction: direction,
        'from_week_start': fromWeekStart,
        'to_week_start': toWeekStart,
      });

  Future<void> homeCalendarDismissed({
    required int dwelltimeSec,
    required String currentViewedDate,
  }) =>
      _e(AppAnalyticsEventNamesConstants.homeCalendarDismissed, {
        AppAnalyticsParameterNamesConstants.dwelltimeSec: dwelltimeSec,
        AppAnalyticsParameterNamesConstants.currentViewedDate: currentViewedDate,
      });

  // —— Medicines list ——
  Future<void> medlistMedicineTapped({
    required String medicineId,
    required String section,
  }) =>
      _e(AppAnalyticsEventNamesConstants.medlistMedicineTapped, {
        AppAnalyticsParameterNamesConstants.medicineId: medicineId,
        AppAnalyticsParameterNamesConstants.section: section,
      });

  Future<void> medlistSectionExpanded(String section) => _e(
        AppAnalyticsEventNamesConstants.medlistSectionExpanded,
        {AppAnalyticsParameterNamesConstants.section: section},
      );

  // —— Medicine detail ——
  Future<void> meddetailEditTapped(String medicineId) => _e(
        AppAnalyticsEventNamesConstants.meddetailEditTapped,
        {AppAnalyticsParameterNamesConstants.medicineId: medicineId},
      );

  Future<void> meddetailPauseToggled(String medicineId, bool paused) => _e(
        AppAnalyticsEventNamesConstants.meddetailPauseToggled,
        {
          AppAnalyticsParameterNamesConstants.medicineId: medicineId,
          AppAnalyticsParameterNamesConstants.newState: paused ? 'paused' : 'active',
        },
      );

  Future<void> meddetailDeleteTapped(String medicineId) => _e(
        AppAnalyticsEventNamesConstants.meddetailDeleteTapped,
        {AppAnalyticsParameterNamesConstants.medicineId: medicineId},
      );

  Future<void> meddetailDeleteConfirmed(String medicineId, bool hadHistory) =>
      _e(AppAnalyticsEventNamesConstants.meddetailDeleteConfirmed, {
        AppAnalyticsParameterNamesConstants.medicineId: medicineId,
        AppAnalyticsParameterNamesConstants.hadHistory: hadHistory,
      });

  // —— Edit medicine ——
  Future<void> editMedView(String medicineId) => _e(
        AppAnalyticsEventNamesConstants.editmedView,
        {AppAnalyticsParameterNamesConstants.medicineId: medicineId},
      );

  Future<void> editMedCancelled({required bool hadChanges}) => _e(
        AppAnalyticsEventNamesConstants.editmedCancelled,
        {AppAnalyticsParameterNamesConstants.hadChanges: hadChanges},
      );

  // —— Alarm ——
  Future<void> alarmSkipTapped(String medicineId) => _e(
        AppAnalyticsEventNamesConstants.alarmSkipTapped,
        {AppAnalyticsParameterNamesConstants.medicineId: medicineId},
      );

  Future<void> alarmSnoozeTapped(String medicineId, int durationMin) => _e(
        AppAnalyticsEventNamesConstants.alarmSnoozeTapped,
        {
          AppAnalyticsParameterNamesConstants.medicineId: medicineId,
          AppAnalyticsParameterNamesConstants.durationMin: durationMin,
          AppAnalyticsParameterNamesConstants.snoozeCount: 1,
        },
      );

  Future<void> alarmTakeAllTapped(int medCount) => _e(
        AppAnalyticsEventNamesConstants.alarmTakeAllTapped,
        {
          AppAnalyticsParameterNamesConstants.medCount: medCount,
          AppAnalyticsParameterNamesConstants.unhandledCountBefore: medCount,
          AppAnalyticsParameterNamesConstants.alreadyHandledCount: 0,
        },
      );

  Future<void> alarmSnoozeAllTapped(int medCount, int durationMin) => _e(
        AppAnalyticsEventNamesConstants.alarmSnoozeAllTapped,
        {
          AppAnalyticsParameterNamesConstants.medCount: medCount,
          AppAnalyticsParameterNamesConstants.unhandledCountBefore: medCount,
          AppAnalyticsParameterNamesConstants.durationMin: durationMin,
        },
      );

  Future<void> alarmSkipAllTapped(int medCount) => _e(
        AppAnalyticsEventNamesConstants.alarmSkipAllTapped,
        {
          AppAnalyticsParameterNamesConstants.medCount: medCount,
          AppAnalyticsParameterNamesConstants.unhandledCountBefore: medCount,
        },
      );

  Future<void> alarmDismissedNoAction({
    required int medCount,
    required int dwelltimeSec,
    required int unhandledCount,
  }) =>
      _e(AppAnalyticsEventNamesConstants.alarmDismissedNoAction, {
        AppAnalyticsParameterNamesConstants.medCount: medCount,
        AppAnalyticsParameterNamesConstants.dwelltimeSec: dwelltimeSec,
        AppAnalyticsParameterNamesConstants.unhandledCount: unhandledCount,
      });

  // —— History ——
  Future<void> historyDayTapped({
    required int daysAgo,
    required String adherenceColor,
  }) =>
      _e(AppAnalyticsEventNamesConstants.historyDayTapped, {
        AppAnalyticsParameterNamesConstants.daysAgo: daysAgo,
        AppAnalyticsParameterNamesConstants.adherenceColor: adherenceColor,
      });

  // —— Settings ——
  Future<void> settingsSnoozeDefaultChanged(int durationMin) => _e(
        AppAnalyticsEventNamesConstants.settingsSnoozeDefaultChanged,
        {AppAnalyticsParameterNamesConstants.durationMin: durationMin},
      );

  Future<void> settingsAftercallToggled(bool enabled) => _e(
        AppAnalyticsEventNamesConstants.settingsAftercallToggled,
        {'enabled': enabled},
      );

  // —— Profiles ——
  Future<void> profileDeleted({required bool hadMedicines, required bool hadHistory}) =>
      _e(AppAnalyticsEventNamesConstants.profileDeleted, {
        'had_medicines': hadMedicines,
        AppAnalyticsParameterNamesConstants.hadHistory: hadHistory,
      });

  Future<void> profileAddedWithCount(int profileCountNow) => _e(
        AppAnalyticsEventNamesConstants.profileAdded,
        {'profile_count_now': profileCountNow},
      );

  // —— Ads ——
  Future<void> adBannerLoaded(String placement) => _e(
        AppAnalyticsEventNamesConstants.adBannerLoaded,
        {'placement': placement},
      );

  Future<void> adBannerFailed(String placement, String errorCode) => _e(
        AppAnalyticsEventNamesConstants.adBannerFailed,
        {'placement': placement, 'error_code': errorCode},
      );

  Future<void> adAftercallShown() => _e(AppAnalyticsEventNamesConstants.adAftercallShown);

  Future<void> adAftercallDismissed(int dwelltimeSec) => _e(
        AppAnalyticsEventNamesConstants.adAftercallDismissed,
        {AppAnalyticsParameterNamesConstants.dwelltimeSec: dwelltimeSec},
      );

  Future<void> adAftercallAddMedClicked() =>
      _e(AppAnalyticsEventNamesConstants.adAftercallAddmedClicked);

  Future<void> adFullscreenLoaded(int medCount) => _e(
        AppAnalyticsEventNamesConstants.adFullscreenLoaded,
        {AppAnalyticsParameterNamesConstants.medCount: medCount},
      );

  // —— System ——
  Future<void> sysBootReschedule(int medicinesRescheduled, int timeTakenMs) => _e(
        AppAnalyticsEventNamesConstants.sysBootReschedule,
        {
          'medicines_rescheduled': medicinesRescheduled,
          'time_taken_ms': timeTakenMs,
        },
      );

  Future<void> medicinesRescheduled(int count) => _e(
        AppAnalyticsEventNamesConstants.medicinesRescheduled,
        {'medicines_rescheduled': count},
      );

  Future<void> sysUpdateReschedule(int count) => _e(
        AppAnalyticsEventNamesConstants.sysUpdateReschedule,
        {'medicines_rescheduled': count},
      );

  // —— Onboarding ——
  Future<void> onbSkipped(String atStep) => _e(
        AppAnalyticsEventNamesConstants.onbSkipped,
        {AppAnalyticsParameterNamesConstants.atStep: atStep},
      );

  Future<void> onbAutostartShown(String oem) => _e(
        AppAnalyticsEventNamesConstants.onbAutostartShown,
        {AppAnalyticsParameterNamesConstants.oem: oem},
      );

  Future<void> onbRegionChanged(String fromRegion, String toRegion) => _e(
        AppAnalyticsEventNamesConstants.onbRegionChanged,
        {
          AppAnalyticsParameterNamesConstants.fromRegion: fromRegion,
          AppAnalyticsParameterNamesConstants.toRegion: toRegion,
        },
      );

  Future<void> onbLanguageSelected({
    required String language,
    required bool wasDefault,
  }) =>
      _e(AppAnalyticsEventNamesConstants.onbLanguageSelected, {
        AppAnalyticsParameterNamesConstants.language: language,
        AppAnalyticsParameterNamesConstants.wasDefault: wasDefault,
      });

  // —— Home (continued) ——
  Future<void> homePermissionWarningShown(String missingPerms) => _e(
        AppAnalyticsEventNamesConstants.homePermissionWarningShown,
        {AppAnalyticsParameterNamesConstants.missingPerms: missingPerms},
      );

  Future<void> homePermissionWarningTapped(String missingPerms) => _e(
        AppAnalyticsEventNamesConstants.homePermissionWarningTapped,
        {AppAnalyticsParameterNamesConstants.missingPerms: missingPerms},
      );

  Future<void> homeViewPastDate({
    required String date,
    required int daysBack,
    required bool hasMedsScheduled,
    required bool hasHistory,
  }) =>
      _e(AppAnalyticsEventNamesConstants.homeViewPastDate, {
        'date': date,
        'days_back': daysBack,
        AppAnalyticsParameterNamesConstants.hasMedsScheduled: hasMedsScheduled,
        AppAnalyticsParameterNamesConstants.hasHistory: hasHistory,
      });

  Future<void> homeViewFutureDate({
    required String date,
    required int daysAhead,
    required bool hasMedsScheduled,
  }) =>
      _e(AppAnalyticsEventNamesConstants.homeViewFutureDate, {
        'date': date,
        AppAnalyticsParameterNamesConstants.daysAhead: daysAhead,
        AppAnalyticsParameterNamesConstants.hasMedsScheduled: hasMedsScheduled,
      });

  // —— Add medicine (continued) ——
  Future<void> addMedDefaultTimeEdited({
    required String scheduleType,
    required int timeIndex,
    required bool wasDefault8am,
  }) =>
      _e(AppAnalyticsEventNamesConstants.addmedDefaultTimeEdited, {
        AppAnalyticsParameterNamesConstants.scheduleType: scheduleType,
        AppAnalyticsParameterNamesConstants.timeIndex: timeIndex,
        AppAnalyticsParameterNamesConstants.wasDefault8am: wasDefault8am,
      });

  Future<void> addMedMonthlyWarningShown(int dayOfMonth) => _e(
        AppAnalyticsEventNamesConstants.addmedMonthlyWarningShown,
        {AppAnalyticsParameterNamesConstants.dayOfMonth: dayOfMonth},
      );

  Future<void> addMedLeapChoice(String choice) => _e(
        AppAnalyticsEventNamesConstants.addmedLeapChoice,
        {AppAnalyticsParameterNamesConstants.choice: choice},
      );

  Future<void> addMedCyclicConfigured(int onDays, int offDays) => _e(
        AppAnalyticsEventNamesConstants.addmedCyclicConfigured,
        {
          AppAnalyticsParameterNamesConstants.onDays: onDays,
          AppAnalyticsParameterNamesConstants.offDays: offDays,
        },
      );

  Future<void> addMedPreviewViewWithSchedule({
    required String scheduleType,
    required int nextFiresCount,
  }) =>
      _e(AppAnalyticsEventNamesConstants.addmedPreviewView, {
        AppAnalyticsParameterNamesConstants.scheduleType: scheduleType,
        AppAnalyticsParameterNamesConstants.nextFiresCount: nextFiresCount,
      });

  Future<void> addMedSavedExtended({
    required String category,
    required String scheduleType,
    required bool hasEndDate,
    required bool hasStockTracking,
    required bool hasNotes,
    required int timeInFlowSec,
  }) =>
      _e(AppAnalyticsEventNamesConstants.addmedSaved, {
        AppAnalyticsParameterNamesConstants.category: category,
        AppAnalyticsParameterNamesConstants.scheduleType: scheduleType,
        AppAnalyticsParameterNamesConstants.hasEndDate: hasEndDate,
        AppAnalyticsParameterNamesConstants.hasStockTracking: hasStockTracking,
        AppAnalyticsParameterNamesConstants.hasNotes: hasNotes,
        AppAnalyticsParameterNamesConstants.timeInFlowSec: timeInFlowSec,
      });

  // —— Edit medicine (continued) ——
  Future<void> editMedFieldChanged(String field) => _e(
        AppAnalyticsEventNamesConstants.editmedFieldChanged,
        {AppAnalyticsParameterNamesConstants.field: field},
      );

  Future<void> editMedScheduleChanged(String fromType, String toType) => _e(
        AppAnalyticsEventNamesConstants.editmedScheduleChanged,
        {
          AppAnalyticsParameterNamesConstants.fromType: fromType,
          AppAnalyticsParameterNamesConstants.toType: toType,
        },
      );

  Future<void> editMedTimeShiftPrompt(int medTimesCount) => _e(
        AppAnalyticsEventNamesConstants.editmedTimeShiftPrompt,
        {AppAnalyticsParameterNamesConstants.medTimesCount: medTimesCount},
      );

  Future<void> editMedTimeShiftResult(String result) => _e(
        AppAnalyticsEventNamesConstants.editmedTimeShiftResult,
        {AppAnalyticsParameterNamesConstants.result: result},
      );

  Future<void> editMedSavedWithFields(String medicineId, List<String> fieldsChanged) =>
      _e(AppAnalyticsEventNamesConstants.editmedSaved, {
        AppAnalyticsParameterNamesConstants.medicineId: medicineId,
        AppAnalyticsParameterNamesConstants.fieldsChanged: fieldsChanged.join(','),
      });

  // —— Medicine detail (continued) ——
  Future<void> meddetailLogNowTapped(String medicineId, int? hoursSinceLast) => _e(
        AppAnalyticsEventNamesConstants.meddetailLogNowTapped,
        {
          AppAnalyticsParameterNamesConstants.medicineId: medicineId,
          AppAnalyticsParameterNamesConstants.hoursSinceLast: hoursSinceLast ?? -1,
        },
      );

  Future<void> meddetailMaxPerDayWarn({
    required String medicineId,
    required int countToday,
    required int maxSet,
  }) =>
      _e(AppAnalyticsEventNamesConstants.meddetailMaxPerDayWarn, {
        AppAnalyticsParameterNamesConstants.medicineId: medicineId,
        AppAnalyticsParameterNamesConstants.countToday: countToday,
        AppAnalyticsParameterNamesConstants.maxSet: maxSet,
      });

  // —— Alarm (continued) ——
  Future<void> alarmPerMedMenuOpened({
    required String medicineId,
    required int position,
    required int totalMedCount,
  }) =>
      _e(AppAnalyticsEventNamesConstants.alarmPerMedMenuOpened, {
        AppAnalyticsParameterNamesConstants.medicineId: medicineId,
        AppAnalyticsParameterNamesConstants.position: position,
        AppAnalyticsParameterNamesConstants.totalMedCount: totalMedCount,
      });

  Future<void> alarmPerMedActionSelected({
    required String medicineId,
    required String action,
    required int position,
    int? snoozeDurationMin,
  }) =>
      _e(AppAnalyticsEventNamesConstants.alarmPerMedActionSelected, {
        AppAnalyticsParameterNamesConstants.medicineId: medicineId,
        AppAnalyticsParameterNamesConstants.action: action,
        AppAnalyticsParameterNamesConstants.position: position,
        if (snoozeDurationMin != null)
          AppAnalyticsParameterNamesConstants.snoozeDurationMin: snoozeDurationMin,
      });

  Future<void> alarmMixedResolution({
    required int medCount,
    required int takeCount,
    required int snoozeCount,
    required int skipCount,
  }) =>
      _e(AppAnalyticsEventNamesConstants.alarmMixedResolution, {
        AppAnalyticsParameterNamesConstants.medCount: medCount,
        AppAnalyticsParameterNamesConstants.takeCount: takeCount,
        AppAnalyticsParameterNamesConstants.snoozeCount: snoozeCount,
        AppAnalyticsParameterNamesConstants.skipCount: skipCount,
      });

  Future<void> alarmAutoMissed(String medicineId, int timeoutMin) => _e(
        AppAnalyticsEventNamesConstants.alarmAutoMissed,
        {
          AppAnalyticsParameterNamesConstants.medicineId: medicineId,
          'timeout_min': timeoutMin,
        },
      );

  // —— Notifications (continued) ——
  /// PRD §12.3, Screen 8 — fired when a notification is posted.
  Future<void> notifShown({
    required String medicineId,
    required bool isHighPriority,
  }) =>
      _e(AppAnalyticsEventNamesConstants.notifShown, {
        AppAnalyticsParameterNamesConstants.medicineId: medicineId,
        'is_high_priority': isHighPriority,
      });

  Future<void> notifDismissed(String medicineId, int secondsAfterShown) => _e(
        AppAnalyticsEventNamesConstants.notifDismissed,
        {
          AppAnalyticsParameterNamesConstants.medicineId: medicineId,
          AppAnalyticsParameterNamesConstants.secondsAfterShown: secondsAfterShown,
        },
      );

  // —— History (continued) ——
  Future<void> historyRetroLog({
    required String medicineId,
    required String action,
    required int hoursLate,
  }) =>
      _e(AppAnalyticsEventNamesConstants.historyRetroLog, {
        AppAnalyticsParameterNamesConstants.medicineId: medicineId,
        AppAnalyticsParameterNamesConstants.action: action,
        AppAnalyticsParameterNamesConstants.hoursLate: hoursLate,
      });

  Future<void> historyFilterApplied(String medicineId) => _e(
        AppAnalyticsEventNamesConstants.historyFilterApplied,
        {AppAnalyticsParameterNamesConstants.medicineId: medicineId},
      );

  // —— Settings (continued) ——
  Future<void> settingsSoundChanged(String soundId) => _e(
        AppAnalyticsEventNamesConstants.settingsSoundChanged,
        {AppAnalyticsParameterNamesConstants.soundId: soundId},
      );

  Future<void> settingsAutomissChanged(String minutes) => _e(
        AppAnalyticsEventNamesConstants.settingsAutomissChanged,
        {'minutes': minutes},
      );

  Future<void> settingsThemeChanged(String theme) => _e(
        AppAnalyticsEventNamesConstants.settingsThemeChanged,
        {'theme': theme},
      );

  Future<void> settingsRegionChanged(String fromRegion, String toRegion) async {
    await _e(
      AppAnalyticsEventNamesConstants.settingsRegionChanged,
      {
        AppAnalyticsParameterNamesConstants.fromRegion: fromRegion,
        AppAnalyticsParameterNamesConstants.toRegion: toRegion,
      },
    );
    await _analytics.syncUserRegionUserProperty(toRegion);
  }

  Future<void> settingsLanguageChanged(String fromLang, String toLang) async {
    await _e(
      AppAnalyticsEventNamesConstants.settingsLanguageChanged,
      {'from_lang': fromLang, 'to_lang': toLang},
    );
    await _analytics.syncUiLanguageUserProperty(toLang);
  }

  // —— Profiles (continued) ——
  Future<void> profileRenamed(String profileIdHash) => _e(
        AppAnalyticsEventNamesConstants.profileRenamed,
        {'profile_id_hash': profileIdHash},
      );

  Future<void> profileEdited(String profileIdHash, List<String> fieldsChanged) =>
      _e(AppAnalyticsEventNamesConstants.profileEdited, {
        'profile_id_hash': profileIdHash,
        AppAnalyticsParameterNamesConstants.fieldsChanged: fieldsChanged.join(','),
      });

  // —— Ads (continued) ——
  Future<void> adBannerClicked(String placement) => _e(
        AppAnalyticsEventNamesConstants.adBannerClicked,
        {'placement': placement},
      );

  Future<void> adAftercallBannerClicked() =>
      _e(AppAnalyticsEventNamesConstants.adAftercallBannerClicked);

  Future<void> adFullscreenViewed() =>
      _e(AppAnalyticsEventNamesConstants.adFullscreenViewed);

  Future<void> adFullscreenClicked() =>
      _e(AppAnalyticsEventNamesConstants.adFullscreenClicked);

  // —— System (continued) ——
  Future<void> sysTimezoneChanged(String fromTz, String toTz) => _e(
        AppAnalyticsEventNamesConstants.sysTimezoneChanged,
        {'from_tz': fromTz, 'to_tz': toTz},
      );

  Future<void> sysTimezoneUserChoice(String choice) => _e(
        AppAnalyticsEventNamesConstants.sysTimezoneUserChoice,
        {AppAnalyticsParameterNamesConstants.choice: choice},
      );

  Future<void> sysDstTransition({
    required String direction,
    required int affectedMedsCount,
  }) =>
      _e(AppAnalyticsEventNamesConstants.sysDstTransition, {
        'direction': direction,
        'affected_meds_count': affectedMedsCount,
      });

  Future<void> sysLowStockNotif(String medicineId, int stockRemaining) => _e(
        AppAnalyticsEventNamesConstants.sysLowStockNotif,
        {
          AppAnalyticsParameterNamesConstants.medicineId: medicineId,
          'stock_remaining': stockRemaining,
        },
      );

  Future<void> sysAlarmLate({
    required String medicineId,
    required int delaySeconds,
    required bool wasInDoze,
  }) =>
      _e(AppAnalyticsEventNamesConstants.sysAlarmLate, {
        AppAnalyticsParameterNamesConstants.medicineId: medicineId,
        'delay_seconds': delaySeconds,
        'was_in_doze': wasInDoze,
      });
}
