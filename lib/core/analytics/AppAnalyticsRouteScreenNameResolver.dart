import '../constants/AppAnalyticsScreenNameConstants.dart';

/// Maps GoRouter matched paths to PRD §12.3 screen_name values.
class AppAnalyticsRouteScreenNameResolver {
  AppAnalyticsRouteScreenNameResolver._();

  static String? screenNameForRouteName(String? routeName) {
    if (routeName == null || routeName.isEmpty) return null;
    if (routeName.startsWith('/')) {
      return screenNameForMatchedLocation(routeName);
    }
    return screenNameForMatchedLocation('/$routeName');
  }

  static String? screenNameForMatchedLocation(String matchedLocation) {
    if (matchedLocation.startsWith('/onboarding')) {
      return AppAnalyticsScreenNameConstants.onboarding;
    }
    if (matchedLocation == '/main/today' ||
        matchedLocation.startsWith('/main/today/')) {
      return AppAnalyticsScreenNameConstants.homeToday;
    }
    if (matchedLocation.startsWith('/main/medicines/detail') &&
        matchedLocation.endsWith('/edit')) {
      return AppAnalyticsScreenNameConstants.editMedicine;
    }
    if (matchedLocation.startsWith('/main/medicines/detail')) {
      return AppAnalyticsScreenNameConstants.medicineDetail;
    }
    if (matchedLocation.startsWith('/main/medicines')) {
      return AppAnalyticsScreenNameConstants.medicinesList;
    }
    if (matchedLocation.startsWith('/main/history')) {
      return AppAnalyticsScreenNameConstants.historyCalendar;
    }
    if (matchedLocation.startsWith('/main/settings')) {
      return AppAnalyticsScreenNameConstants.settingsMain;
    }
    if (matchedLocation == '/add-medicine/name') {
      return AppAnalyticsScreenNameConstants.addMedicineName;
    }
    if (matchedLocation == '/add-medicine/category') {
      return AppAnalyticsScreenNameConstants.addMedicineCategory;
    }
    if (matchedLocation == '/add-medicine/dose') {
      return AppAnalyticsScreenNameConstants.addMedicineDose;
    }
    if (matchedLocation == '/add-medicine/schedule-type') {
      return AppAnalyticsScreenNameConstants.addMedicineScheduleType;
    }
    if (matchedLocation == '/add-medicine/schedule-details') {
      return AppAnalyticsScreenNameConstants.addMedicineScheduleDetails;
    }
    if (matchedLocation == '/add-medicine/duration') {
      return AppAnalyticsScreenNameConstants.addMedicineDuration;
    }
    if (matchedLocation == '/add-medicine/more') {
      return AppAnalyticsScreenNameConstants.addMedicineMore;
    }
    if (matchedLocation == '/add-medicine/preview') {
      return AppAnalyticsScreenNameConstants.addMedicinePreview;
    }
    if (matchedLocation.startsWith('/alarm')) {
      return AppAnalyticsScreenNameConstants.alarmFullscreen;
    }
    if (matchedLocation.startsWith('/aftercall')) {
      return AppAnalyticsScreenNameConstants.adAftercall;
    }
    return null;
  }
}
