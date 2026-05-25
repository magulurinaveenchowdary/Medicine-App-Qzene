import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'AppPrdAnalyticsBridge.dart';
import 'AppPrdAnalyticsSupportProviders.dart';

void startAddMedicineFunnelAnalytics(WidgetRef ref, String source) {
  ref.read(addMedicineFunnelStartedAtProvider.notifier).state = DateTime.now();
  ref.read(appPrdAnalyticsBridgeProvider).addMedStarted(source);
}
