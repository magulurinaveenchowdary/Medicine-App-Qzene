import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/AppFirebaseAnalyticsLoggingService.dart';
import '../../features/medicines/application/MedicineAppDataNotifier.dart';
import '../../features/medicines/data/MedicineCatalogSearchService.dart';
import '../../features/onboarding/application/AppOnboardingCompletionNotifier.dart';

/// Loads persistence, catalog, and onboarding flag at app start.
final appBootstrapInitializationProvider = FutureProvider<void>((ref) async {
  final persistence = ref.read(medicineLocalPersistenceRepositoryProvider);
  await persistence.initializeIfNeeded();

  final completed = await persistence.readOnboardingCompleted();
  if (completed) {
    ref
        .read(appOnboardingCompletionNotifierProvider.notifier)
        .markOnboardingCompletedInMemory();
  }

  final activeProfileId = await persistence.readActiveProfileId();
  ref.read(activeUserProfileIdProvider.notifier).state = activeProfileId;

  await ref.read(medicineAppDataNotifierProvider.future);

  if (Firebase.apps.isNotEmpty) {
    await ref
        .read(appFirebaseAnalyticsLoggingServiceProvider)
        .logOnboardingStartedOnce();
    final snapshot = ref.read(medicineAppDataNotifierProvider).valueOrNull;
    if (snapshot != null) {
      final analytics = ref.read(appFirebaseAnalyticsLoggingServiceProvider);
      await analytics.syncProfileCountUserProperty(snapshot.profiles.length);
      final profileId = ref.read(activeUserProfileIdProvider);
      final medCount = snapshot.medicines
          .where((m) => m.profileId == profileId)
          .length;
      await analytics.syncMedicinesCountUserProperty(medCount);
    }
  }
});

final medicineCatalogSearchServiceProvider = Provider<MedicineCatalogSearchService>(
  (ref) => MedicineCatalogSearchService(),
);
