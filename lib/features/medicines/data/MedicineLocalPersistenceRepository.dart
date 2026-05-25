import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/MedicineReminderDataModels.dart';

/// JSON file + SharedPreferences persistence (Phase 1 local store).
class MedicineLocalPersistenceRepository {
  static const _prefsOnboardingKey = 'onboarding_completed_v1';
  static const _prefsActiveProfileKey = 'active_profile_id_v1';
  static const _dataFileName = 'medicine_reminder_app_data_v1.json';

  SharedPreferences? _prefs;
  AppPersistedDataSnapshot? _cache;

  Future<void> initializeIfNeeded() async {
    _prefs ??= await SharedPreferences.getInstance();
    _cache ??= await _loadSnapshot();
  }

  Future<bool> readOnboardingCompleted() async {
    await initializeIfNeeded();
    return _prefs!.getBool(_prefsOnboardingKey) ?? false;
  }

  Future<void> writeOnboardingCompleted(bool value) async {
    await initializeIfNeeded();
    await _prefs!.setBool(_prefsOnboardingKey, value);
  }

  Future<String> readActiveProfileId() async {
    await initializeIfNeeded();
    return _prefs!.getString(_prefsActiveProfileKey) ??
        _cache!.profiles.first.profileId;
  }

  Future<void> writeActiveProfileId(String profileId) async {
    await initializeIfNeeded();
    await _prefs!.setString(_prefsActiveProfileKey, profileId);
  }

  AppPersistedDataSnapshot readSnapshot() {
    return _cache!;
  }

  Future<void> saveSnapshot(AppPersistedDataSnapshot snapshot) async {
    await initializeIfNeeded();
    _cache = snapshot;
    final file = await _dataFile();
    await file.writeAsString(jsonEncode(snapshot.toJson()));
  }

  Future<AppPersistedDataSnapshot> _loadSnapshot() async {
    final file = await _dataFile();
    if (await file.exists()) {
      final text = await file.readAsString();
      if (text.isNotEmpty) {
        return AppPersistedDataSnapshot.fromJson(
          jsonDecode(text) as Map<String, dynamic>,
        );
      }
    }
    final defaultProfile = UserProfileRecordModel(
      profileId: 'profile_default',
      displayName: 'Me',
      avatarLetter: 'M',
    );
    return AppPersistedDataSnapshot(
      profiles: [defaultProfile],
      medicines: const [],
      doseOccurrences: const [],
      recentCustomUnits: const [],
    );
  }

  Future<File> _dataFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_dataFileName');
  }
}

class AppPersistedDataSnapshot {
  const AppPersistedDataSnapshot({
    required this.profiles,
    required this.medicines,
    required this.doseOccurrences,
    required this.recentCustomUnits,
  });

  final List<UserProfileRecordModel> profiles;
  final List<MedicineStoredRecordModel> medicines;
  final List<MedicineDoseOccurrenceRecordModel> doseOccurrences;
  final List<String> recentCustomUnits;

  Map<String, dynamic> toJson() => {
        'profiles': profiles.map((e) => e.toJson()).toList(),
        'medicines': medicines.map((e) => e.toJson()).toList(),
        'doseOccurrences': doseOccurrences.map((e) => e.toJson()).toList(),
        'recentCustomUnits': recentCustomUnits,
      };

  factory AppPersistedDataSnapshot.fromJson(Map<String, dynamic> json) {
    return AppPersistedDataSnapshot(
      profiles: (json['profiles'] as List<dynamic>)
          .map((e) => UserProfileRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      medicines: (json['medicines'] as List<dynamic>? ?? [])
          .map((e) => MedicineStoredRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      doseOccurrences: (json['doseOccurrences'] as List<dynamic>? ?? [])
          .map(
            (e) => MedicineDoseOccurrenceRecordModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      recentCustomUnits: (json['recentCustomUnits'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }

  AppPersistedDataSnapshot copyWith({
    List<UserProfileRecordModel>? profiles,
    List<MedicineStoredRecordModel>? medicines,
    List<MedicineDoseOccurrenceRecordModel>? doseOccurrences,
    List<String>? recentCustomUnits,
  }) {
    return AppPersistedDataSnapshot(
      profiles: profiles ?? this.profiles,
      medicines: medicines ?? this.medicines,
      doseOccurrences: doseOccurrences ?? this.doseOccurrences,
      recentCustomUnits: recentCustomUnits ?? this.recentCustomUnits,
    );
  }
}
