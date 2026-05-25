import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../medicines/application/MedicineAppDataNotifier.dart'
    show medicinePersistenceRepositoryProvider;

/// Onboarding gate persisted locally (PRD §6.1).
class AppOnboardingCompletionNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  Future<void> markOnboardingCompleted() async {
    state = true;
    final repo = ref.read(medicinePersistenceRepositoryProvider);
    await repo.writeOnboardingCompleted(true);
  }

  void markOnboardingCompletedInMemory() {
    state = true;
  }

  void resetForTests() {
    state = false;
  }
}

final appOnboardingCompletionNotifierProvider =
    NotifierProvider<AppOnboardingCompletionNotifier, bool>(
  AppOnboardingCompletionNotifier.new,
);
