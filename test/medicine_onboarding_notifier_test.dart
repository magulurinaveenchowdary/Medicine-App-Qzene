import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:med_reminder/features/onboarding/application/AppOnboardingCompletionNotifier.dart';

void main() {
  test('markOnboardingCompleted sets state to true', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(appOnboardingCompletionNotifierProvider), isFalse);
    container
        .read(appOnboardingCompletionNotifierProvider.notifier)
        .markOnboardingCompletedInMemory();
    expect(container.read(appOnboardingCompletionNotifierProvider), isTrue);
  });
}
