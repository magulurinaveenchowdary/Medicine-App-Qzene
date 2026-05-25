import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Medicine Reminder'**
  String get appTitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @medicineReminderTagline.
  ///
  /// In en, this message translates to:
  /// **'Reliable reminders for your medication.\nFree. Forever.'**
  String get medicineReminderTagline;

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String stepProgress(int step, int total);

  /// No description provided for @onboardingPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up reliable reminders'**
  String get onboardingPermissionsTitle;

  /// No description provided for @onboardingPermissionsBody.
  ///
  /// In en, this message translates to:
  /// **'We need three permissions so your alarms always fire on time.'**
  String get onboardingPermissionsBody;

  /// No description provided for @permissionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permissionNotifications;

  /// No description provided for @permissionBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery Optimization'**
  String get permissionBattery;

  /// No description provided for @permissionBatteryRequired.
  ///
  /// In en, this message translates to:
  /// **'*required'**
  String get permissionBatteryRequired;

  /// No description provided for @permissionBatterySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fire alarms even when phone is idle'**
  String get permissionBatterySubtitle;

  /// No description provided for @permissionAlarms.
  ///
  /// In en, this message translates to:
  /// **'Alarms & reminders'**
  String get permissionAlarms;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @granted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get granted;

  /// No description provided for @denied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get denied;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Who is this for?'**
  String get profileTitle;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'DISPLAY NAME'**
  String get displayNameLabel;

  /// No description provided for @displayNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Margaret'**
  String get displayNameHint;

  /// No description provided for @finishSetup.
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get finishSetup;

  /// No description provided for @todayTab.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTab;

  /// No description provided for @medicinesTab.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicinesTab;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTab;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get addMedicine;

  /// No description provided for @addFirstMedicineTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first medicine'**
  String get addFirstMedicineTitle;

  /// No description provided for @addFirstMedicineBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to start.'**
  String get addFirstMedicineBody;

  /// No description provided for @todaysMedicinesHeader.
  ///
  /// In en, this message translates to:
  /// **'today\'s medicines — {count} scheduled'**
  String todaysMedicinesHeader(int count);

  /// No description provided for @backToToday.
  ///
  /// In en, this message translates to:
  /// **'← Today'**
  String get backToToday;

  /// No description provided for @medicinesListTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicinesListTitle;

  /// No description provided for @medicineDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicine Details'**
  String get medicineDetailsTitle;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @saveMedicine.
  ///
  /// In en, this message translates to:
  /// **'Save Medicine'**
  String get saveMedicine;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @profilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profilesTitle;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @callEndedTitle.
  ///
  /// In en, this message translates to:
  /// **'Call ended'**
  String get callEndedTitle;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @scheduledSection.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULED — {count} ACTIVE'**
  String scheduledSection(int count);

  /// No description provided for @onDemandSection.
  ///
  /// In en, this message translates to:
  /// **'ON DEMAND — {count}'**
  String onDemandSection(int count);

  /// No description provided for @sponsored.
  ///
  /// In en, this message translates to:
  /// **'Sponsored'**
  String get sponsored;

  /// No description provided for @bannerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Banner ad · 320×50'**
  String get bannerPlaceholder;

  /// No description provided for @nativeAdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Native ad area'**
  String get nativeAdPlaceholder;

  /// No description provided for @takeAll.
  ///
  /// In en, this message translates to:
  /// **'Take All ✓'**
  String get takeAll;

  /// No description provided for @snoozeAll.
  ///
  /// In en, this message translates to:
  /// **'Snooze All'**
  String get snoozeAll;

  /// No description provided for @skipAll.
  ///
  /// In en, this message translates to:
  /// **'Skip All'**
  String get skipAll;

  /// No description provided for @alarmMedicineTime.
  ///
  /// In en, this message translates to:
  /// **'{name} · {time}'**
  String alarmMedicineTime(String name, String time);

  /// No description provided for @openDeveloperAlarmPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview alarm screen (dev)'**
  String get openDeveloperAlarmPreview;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
