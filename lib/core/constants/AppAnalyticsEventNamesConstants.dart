/// PRD §12.3 — every custom analytics event (not screen_view).
class AppAnalyticsEventNamesConstants {
  AppAnalyticsEventNamesConstants._();

  // Onboarding
  static const String onbStarted = 'onb_started';
  static const String onbNotifPermissionShown = 'onb_notif_permission_shown';
  static const String onbNotifPermissionResult = 'onb_notif_permission_result';
  static const String onbBatteryExemptionShown = 'onb_battery_exemption_shown';
  static const String onbBatteryExemptionResult = 'onb_battery_exemption_result';
  static const String onbAlarmsPermissionShown = 'onb_alarms_permission_shown';
  static const String onbAlarmsPermissionResult = 'onb_alarms_permission_result';
  static const String onbAutostartShown = 'onb_autostart_shown';
  static const String onbRegionDetected = 'onb_region_detected';
  static const String onbRegionChanged = 'onb_region_changed';
  static const String onbLanguageSelected = 'onb_language_selected';
  static const String onbProfileCreated = 'onb_profile_created';
  static const String onbCompleted = 'onb_completed';
  static const String onbSkipped = 'onb_skipped';

  // Home
  static const String homeViewState = 'home_view_state';
  static const String homeMedicineTapped = 'home_medicine_tapped';
  static const String homeQuickTake = 'home_quick_take';
  static const String homeQuickSkip = 'home_quick_skip';
  static const String homeAddFabTapped = 'home_add_fab_tapped';
  static const String homeProfileSwitched = 'home_profile_switched';
  static const String homePermissionWarningShown = 'home_permission_warning_shown';
  static const String homePermissionWarningTapped = 'home_permission_warning_tapped';
  static const String homeDatestripSwiped = 'home_datestrip_swiped';
  static const String homeDateSelected = 'home_date_selected';
  static const String homeTodayReturned = 'home_today_returned';
  static const String homeCalendarOpened = 'home_calendar_opened';
  static const String homeCalendarDateSelected = 'home_calendar_date_selected';
  static const String homeCalendarDismissed = 'home_calendar_dismissed';
  static const String homeViewPastDate = 'home_view_past_date';
  static const String homeViewFutureDate = 'home_view_future_date';

  // Medicines list
  static const String medlistView = 'medlist_view';
  static const String medlistSectionExpanded = 'medlist_section_expanded';
  static const String medlistMedicineTapped = 'medlist_medicine_tapped';

  // Medicine detail
  static const String meddetailView = 'meddetail_view';
  static const String meddetailEditTapped = 'meddetail_edit_tapped';
  static const String meddetailPauseToggled = 'meddetail_pause_toggled';
  static const String meddetailDeleteTapped = 'meddetail_delete_tapped';
  static const String meddetailDeleteConfirmed = 'meddetail_delete_confirmed';
  static const String meddetailLogNowTapped = 'meddetail_log_now_tapped';
  static const String meddetailMaxPerDayWarn = 'meddetail_max_per_day_warn';

  // Add medicine funnel
  static const String addmedStarted = 'addmed_started';
  static const String addmedNameScreenView = 'addmed_name_screen_view';
  static const String addmedSearchResults = 'addmed_search_results';
  static const String addmedSuggestionSelected = 'addmed_suggestion_selected';
  static const String addmedCustomAdded = 'addmed_custom_added';
  static const String addmedCategoryView = 'addmed_category_view';
  static const String addmedCategorySelected = 'addmed_category_selected';
  static const String addmedDoseView = 'addmed_dose_view';
  static const String addmedUnitSelected = 'addmed_unit_selected';
  static const String addmedUnitCustomEntered = 'addmed_unit_custom_entered';
  static const String addmedScheduleTypeView = 'addmed_schedule_type_view';
  static const String addmedScheduleSelected = 'addmed_schedule_selected';
  static const String addmedScheduleDetailsView = 'addmed_schedule_details_view';
  static const String addmedDefaultTimeEdited = 'addmed_default_time_edited';
  static const String addmedMonthlyWarningShown = 'addmed_monthly_warning_shown';
  static const String addmedLeapChoice = 'addmed_leap_choice';
  static const String addmedCyclicConfigured = 'addmed_cyclic_configured';
  static const String addmedDurationView = 'addmed_duration_view';
  static const String addmedDurationSelected = 'addmed_duration_selected';
  static const String addmedPreviewView = 'addmed_preview_view';
  static const String addmedSaved = 'addmed_saved';
  static const String addmedCancelled = 'addmed_cancelled';

  // Edit medicine
  static const String editmedView = 'editmed_view';
  static const String editmedFieldChanged = 'editmed_field_changed';
  static const String editmedScheduleChanged = 'editmed_schedule_changed';
  static const String editmedTimeShiftPrompt = 'editmed_time_shift_prompt';
  static const String editmedTimeShiftResult = 'editmed_time_shift_result';
  static const String editmedSaved = 'editmed_saved';
  static const String editmedCancelled = 'editmed_cancelled';

  // Alarm
  static const String alarmFired = 'alarm_fired';
  static const String alarmTakeTapped = 'alarm_take_tapped';
  static const String alarmSkipTapped = 'alarm_skip_tapped';
  static const String alarmSnoozeTapped = 'alarm_snooze_tapped';
  static const String alarmPerMedMenuOpened = 'alarm_per_med_menu_opened';
  static const String alarmPerMedActionSelected = 'alarm_per_med_action_selected';
  static const String alarmTakeAllTapped = 'alarm_take_all_tapped';
  static const String alarmSnoozeAllTapped = 'alarm_snooze_all_tapped';
  static const String alarmSkipAllTapped = 'alarm_skip_all_tapped';
  static const String alarmMixedResolution = 'alarm_mixed_resolution';
  static const String alarmDismissedNoAction = 'alarm_dismissed_no_action';
  static const String alarmAutoMissed = 'alarm_auto_missed';

  // Notifications
  static const String notifShown = 'notif_shown';
  static const String notifTakeAction = 'notif_take_action';
  static const String notifSnoozeAction = 'notif_snooze_action';
  static const String notifTapped = 'notif_tapped';
  static const String notifDismissed = 'notif_dismissed';

  // History
  static const String historyView = 'history_view';
  static const String historyDayTapped = 'history_day_tapped';
  static const String historyRetroLog = 'history_retro_log';
  static const String historyFilterApplied = 'history_filter_applied';

  // Settings
  static const String settingsView = 'settings_view';
  static const String settingsSoundChanged = 'settings_sound_changed';
  static const String settingsSnoozeDefaultChanged = 'settings_snooze_default_changed';
  static const String settingsAutomissChanged = 'settings_automiss_changed';
  static const String settingsLanguageChanged = 'settings_language_changed';
  static const String settingsRegionChanged = 'settings_region_changed';
  static const String settingsThemeChanged = 'settings_theme_changed';
  static const String settingsAftercallToggled = 'settings_aftercall_toggled';

  // Profiles
  static const String profileAdded = 'profile_added';
  static const String profileDeleted = 'profile_deleted';
  static const String profileEdited = 'profile_edited';
  static const String profileRenamed = 'profile_renamed';

  // Ads
  static const String adBannerLoaded = 'ad_banner_loaded';
  static const String adBannerFailed = 'ad_banner_failed';
  static const String adBannerClicked = 'ad_banner_clicked';
  static const String adFullscreenLoaded = 'ad_fullscreen_loaded';
  static const String adFullscreenViewed = 'ad_fullscreen_viewed';
  static const String adFullscreenClicked = 'ad_fullscreen_clicked';
  static const String adAftercallShown = 'ad_aftercall_shown';
  static const String adAftercallDismissed = 'ad_aftercall_dismissed';
  static const String adAftercallBannerClicked = 'ad_aftercall_banner_clicked';
  static const String adAftercallAddmedClicked = 'ad_aftercall_addmed_clicked';

  // System
  static const String sysBootReschedule = 'sys_boot_reschedule';
  static const String sysUpdateReschedule = 'sys_update_reschedule';
  static const String sysTimezoneChanged = 'sys_timezone_changed';
  static const String sysTimezoneUserChoice = 'sys_timezone_user_choice';
  static const String sysDstTransition = 'sys_dst_transition';
  static const String sysAlarmLate = 'sys_alarm_late';
  static const String sysLowStockNotif = 'sys_low_stock_notif';
  static const String medicinesRescheduled = 'medicines_rescheduled';
}
