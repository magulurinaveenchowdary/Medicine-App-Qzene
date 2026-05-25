import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/AppLocalNotificationsSchedulingService.dart';

final appLocalNotificationsSchedulingServiceProvider =
    Provider<AppLocalNotificationsSchedulingService>(
  (ref) => AppLocalNotificationsSchedulingService(),
);
