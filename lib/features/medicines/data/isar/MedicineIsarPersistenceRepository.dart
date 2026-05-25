import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MedicineLocalPersistenceRepository.dart';
import 'MedicineIsarCollections.dart';
import 'MedicineIsarMapperHelpers.dart';

import '../MedicinePersistenceRepositoryContract.dart';

/// Isar-backed persistence with one-time JSON migration (build spec §7).
class MedicineIsarPersistenceRepository
    implements MedicinePersistenceRepositoryContract {
  Isar? _isar;
  SharedPreferences? _prefs;

  static const _prefsOnboardingKey = 'onboarding_completed_v1';
  static const _prefsActiveProfileKey = 'active_profile_id_v1';
  static const _jsonMigratedKey = 'isar_json_migrated_v1';

  Future<Isar> _openIsar() async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        IsarUserProfileEntitySchema,
        IsarMedicineEntitySchema,
        IsarDoseOccurrenceEntitySchema,
        IsarAppMetaEntitySchema,
      ],
      directory: dir.path,
    );
    return _isar!;
  }

  @override
  Future<void> initializeIfNeeded() async {
    _prefs ??= await SharedPreferences.getInstance();
    final isar = await _openIsar();
    final migrated = _prefs!.getBool(_jsonMigratedKey) ?? false;
    if (!migrated) {
      await _migrateFromJsonIfPresent(isar);
      await _prefs!.setBool(_jsonMigratedKey, true);
    }
    if (await isar.isarUserProfileEntitys.count() == 0) {
      await isar.writeTxn(() async {
        await isar.isarUserProfileEntitys.put(
          IsarUserProfileEntity()
            ..profileId = 'profile_default'
            ..displayName = 'Me'
            ..avatarLetter = 'M',
        );
      });
    }
  }

  Future<void> _migrateFromJsonIfPresent(Isar isar) async {
    final legacy = MedicineLocalPersistenceRepository();
    await legacy.initializeIfNeeded();
    final snapshot = legacy.readSnapshot();
    if (snapshot.medicines.isEmpty &&
        snapshot.profiles.length <= 1 &&
        snapshot.doseOccurrences.isEmpty) {
      return;
    }
    await isar.writeTxn(() async {
      await isar.isarUserProfileEntitys.clear();
      await isar.isarMedicineEntitys.clear();
      await isar.isarDoseOccurrenceEntitys.clear();
      for (final profile in snapshot.profiles) {
        await isar.isarUserProfileEntitys.put(
          MedicineIsarMapperHelpers.toIsarProfile(profile),
        );
      }
      for (final medicine in snapshot.medicines) {
        await isar.isarMedicineEntitys.put(
          MedicineIsarMapperHelpers.toIsarMedicine(medicine),
        );
      }
      for (final occurrence in snapshot.doseOccurrences) {
        await isar.isarDoseOccurrenceEntitys.put(
          MedicineIsarMapperHelpers.toIsarOccurrence(occurrence),
        );
      }
    });
  }

  @override
  Future<bool> readOnboardingCompleted() async {
    await initializeIfNeeded();
    return _prefs!.getBool(_prefsOnboardingKey) ?? false;
  }

  @override
  Future<void> writeOnboardingCompleted(bool value) async {
    await initializeIfNeeded();
    await _prefs!.setBool(_prefsOnboardingKey, value);
  }

  @override
  Future<String> readActiveProfileId() async {
    await initializeIfNeeded();
    return _prefs!.getString(_prefsActiveProfileKey) ?? 'profile_default';
  }

  @override
  Future<void> writeActiveProfileId(String profileId) async {
    await initializeIfNeeded();
    await _prefs!.setString(_prefsActiveProfileKey, profileId);
  }

  @override
  Future<AppPersistedDataSnapshot> readSnapshot() async {
    final isar = await _openIsar();
    final profiles = await isar.isarUserProfileEntitys.where().findAll();
    final medicines = await isar.isarMedicineEntitys.where().findAll();
    final occurrences = await isar.isarDoseOccurrenceEntitys.where().findAll();
    return AppPersistedDataSnapshot(
      profiles: profiles.map(MedicineIsarMapperHelpers.fromIsarProfile).toList(),
      medicines:
          medicines.map(MedicineIsarMapperHelpers.fromIsarMedicine).toList(),
      doseOccurrences: occurrences
          .map(MedicineIsarMapperHelpers.fromIsarOccurrence)
          .toList(),
      recentCustomUnits: const [],
    );
  }

  @override
  Future<void> saveSnapshot(AppPersistedDataSnapshot snapshot) async {
    final isar = await _openIsar();
    await isar.writeTxn(() async {
      await isar.isarUserProfileEntitys.clear();
      await isar.isarMedicineEntitys.clear();
      await isar.isarDoseOccurrenceEntitys.clear();
      for (final profile in snapshot.profiles) {
        await isar.isarUserProfileEntitys.put(
          MedicineIsarMapperHelpers.toIsarProfile(profile),
        );
      }
      for (final medicine in snapshot.medicines) {
        await isar.isarMedicineEntitys.put(
          MedicineIsarMapperHelpers.toIsarMedicine(medicine),
        );
      }
      for (final occurrence in snapshot.doseOccurrences) {
        await isar.isarDoseOccurrenceEntitys.put(
          MedicineIsarMapperHelpers.toIsarOccurrence(occurrence),
        );
      }
    });
  }
}
