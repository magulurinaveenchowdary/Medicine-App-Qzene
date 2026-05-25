import 'MedicineLocalPersistenceRepository.dart';

/// Shared persistence API (Isar implementation is primary).
abstract class MedicinePersistenceRepositoryContract {
  Future<void> initializeIfNeeded();
  Future<bool> readOnboardingCompleted();
  Future<void> writeOnboardingCompleted(bool value);
  Future<String> readActiveProfileId();
  Future<void> writeActiveProfileId(String profileId);
  Future<AppPersistedDataSnapshot> readSnapshot();
  Future<void> saveSnapshot(AppPersistedDataSnapshot snapshot);
}
