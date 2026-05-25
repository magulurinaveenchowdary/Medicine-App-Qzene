import 'package:isar/isar.dart';

part 'MedicineIsarCollections.g.dart';

@collection
class IsarUserProfileEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String profileId;

  late String displayName;
  String? avatarLetter;
  int? ageYears;
}

@collection
class IsarMedicineEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String medicineId;

  @Index()
  late String profileId;

  late String displayName;
  late String ingredientLine;
  late bool isCustomMedicine;
  late String categoryFormLabel;
  late double doseAmount;
  late String doseUnit;
  late String scheduleKindName;
  late List<int> doseMinutesOfDay;
  late String durationKindName;
  String? endDateIso;
  int? durationDayCount;
  String? notes;
  late bool isCriticalMedicine;
  double? stockRemaining;
  late bool isPaused;
  String? createdAtIso;
  late String schedulePayloadJson;
}

@collection
class IsarDoseOccurrenceEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String occurrenceId;

  @Index()
  late String medicineId;

  @Index()
  late String profileId;

  late String scheduledAtIso;
  late String statusKindName;
  String? actionAtIso;
  String? snoozedUntilIso;
}

@collection
class IsarAppMetaEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String metaKey;

  late String metaValue;
}
