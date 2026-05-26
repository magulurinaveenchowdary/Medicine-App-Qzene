// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Medicine Reminder';

  @override
  String get getStarted => 'Get Started';

  @override
  String get medicineReminderTagline =>
      'Reliable reminders for your medication.\nFree. Forever.';

  @override
  String stepProgress(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get onboardingPermissionsTitle => 'Let\'s set up reliable reminders';

  @override
  String get onboardingPermissionsBody =>
      'We need four permissions so your alarms always fire on time.';

  @override
  String get permissionNotifications => 'Notifications';

  @override
  String get permissionBattery => 'Battery Optimization';

  @override
  String get permissionBatteryRequired => '*required';

  @override
  String get permissionBatterySubtitle => 'Fire alarms even when phone is idle';

  @override
  String get permissionAlarms => 'Alarms & reminders';

  @override
  String get permissionFullScreen => 'Full-Screen Alerts';

  @override
  String get permissionFullScreenSubtitle =>
      'Show alerts on top of lock screen after calls';

  @override
  String get allow => 'Allow';

  @override
  String get granted => 'Granted';

  @override
  String get denied => 'Denied';

  @override
  String get continueLabel => 'Continue';

  @override
  String get languageTitle => 'Choose your language';

  @override
  String get profileTitle => 'Who is this for?';

  @override
  String get displayNameLabel => 'DISPLAY NAME';

  @override
  String get displayNameHint => 'e.g. Margaret';

  @override
  String get finishSetup => 'Finish setup';

  @override
  String get todayTab => 'Today';

  @override
  String get medicinesTab => 'Medicines';

  @override
  String get historyTab => 'History';

  @override
  String get settingsTab => 'Settings';

  @override
  String get addMedicine => 'Add Medicine';

  @override
  String get addFirstMedicineTitle => 'Add your first medicine';

  @override
  String get addFirstMedicineBody => 'Tap the + button below to start.';

  @override
  String todaysMedicinesHeader(int count) {
    return 'today\'s medicines — $count scheduled';
  }

  @override
  String get backToToday => '← Today';

  @override
  String get medicinesListTitle => 'Medicines';

  @override
  String get medicineDetailsTitle => 'Medicine Details';

  @override
  String get edit => 'Edit';

  @override
  String get saveMedicine => 'Save Medicine';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get profilesTitle => 'Profiles';

  @override
  String get historyTitle => 'History';

  @override
  String get cancel => 'Cancel';

  @override
  String get callEndedTitle => 'Call ended';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get search => 'Search';

  @override
  String scheduledSection(int count) {
    return 'SCHEDULED — $count ACTIVE';
  }

  @override
  String onDemandSection(int count) {
    return 'ON DEMAND — $count';
  }

  @override
  String get sponsored => 'Sponsored';

  @override
  String get bannerPlaceholder => 'Banner ad · 320×50';

  @override
  String get nativeAdPlaceholder => 'Native ad area';

  @override
  String get takeAll => 'Take All ✓';

  @override
  String get snoozeAll => 'Snooze All';

  @override
  String get skipAll => 'Skip All';

  @override
  String alarmMedicineTime(String name, String time) {
    return '$name · $time';
  }

  @override
  String get openDeveloperAlarmPreview => 'Preview alarm screen (dev)';
}
