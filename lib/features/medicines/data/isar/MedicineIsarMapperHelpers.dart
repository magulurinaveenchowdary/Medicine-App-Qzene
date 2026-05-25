import 'dart:convert';

import '../../domain/MedicineReminderDataModels.dart';
import '../../domain/MedicineSchedulePayloadModel.dart';
import 'MedicineIsarCollections.dart';

class MedicineIsarMapperHelpers {
  static IsarUserProfileEntity toIsarProfile(UserProfileRecordModel model) {
    return IsarUserProfileEntity()
      ..profileId = model.profileId
      ..displayName = model.displayName
      ..avatarLetter = model.avatarLetter
      ..ageYears = model.ageYears;
  }

  static UserProfileRecordModel fromIsarProfile(IsarUserProfileEntity entity) {
    return UserProfileRecordModel(
      profileId: entity.profileId,
      displayName: entity.displayName,
      avatarLetter: entity.avatarLetter,
      ageYears: entity.ageYears,
    );
  }

  static IsarMedicineEntity toIsarMedicine(MedicineStoredRecordModel model) {
    return IsarMedicineEntity()
      ..medicineId = model.medicineId
      ..profileId = model.profileId
      ..displayName = model.displayName
      ..ingredientLine = model.ingredientLine
      ..isCustomMedicine = model.isCustomMedicine
      ..categoryFormLabel = model.categoryFormLabel
      ..doseAmount = model.doseAmount
      ..doseUnit = model.doseUnit
      ..scheduleKindName = model.scheduleKind.name
      ..doseMinutesOfDay = List<int>.from(model.doseMinutesOfDay)
      ..durationKindName = model.durationKind.name
      ..endDateIso = model.endDateIso
      ..durationDayCount = model.durationDayCount
      ..notes = model.notes
      ..isCriticalMedicine = model.isCriticalMedicine
      ..stockRemaining = model.stockRemaining
      ..isPaused = model.isPaused
      ..createdAtIso = model.createdAtIso
      ..schedulePayloadJson = jsonEncode(model.schedulePayload.toJson());
  }

  static MedicineStoredRecordModel fromIsarMedicine(IsarMedicineEntity entity) {
    return MedicineStoredRecordModel(
      medicineId: entity.medicineId,
      profileId: entity.profileId,
      displayName: entity.displayName,
      ingredientLine: entity.ingredientLine,
      isCustomMedicine: entity.isCustomMedicine,
      categoryFormLabel: entity.categoryFormLabel,
      doseAmount: entity.doseAmount,
      doseUnit: entity.doseUnit,
      scheduleKind: MedicineScheduleKind.values.byName(entity.scheduleKindName),
      doseMinutesOfDay: List<int>.from(entity.doseMinutesOfDay),
      durationKind: MedicineDurationKind.values.byName(entity.durationKindName),
      endDateIso: entity.endDateIso,
      durationDayCount: entity.durationDayCount,
      notes: entity.notes,
      isCriticalMedicine: entity.isCriticalMedicine,
      stockRemaining: entity.stockRemaining,
      isPaused: entity.isPaused,
      createdAtIso: entity.createdAtIso,
      schedulePayload: MedicineSchedulePayloadModel.fromJson(
        jsonDecode(entity.schedulePayloadJson) as Map<String, dynamic>?,
      ),
    );
  }

  static IsarDoseOccurrenceEntity toIsarOccurrence(
    MedicineDoseOccurrenceRecordModel model,
  ) {
    return IsarDoseOccurrenceEntity()
      ..occurrenceId = model.occurrenceId
      ..medicineId = model.medicineId
      ..profileId = model.profileId
      ..scheduledAtIso = model.scheduledAtIso
      ..statusKindName = model.statusKind.name
      ..actionAtIso = model.actionAtIso
      ..snoozedUntilIso = model.snoozedUntilIso;
  }

  static MedicineDoseOccurrenceRecordModel fromIsarOccurrence(
    IsarDoseOccurrenceEntity entity,
  ) {
    return MedicineDoseOccurrenceRecordModel(
      occurrenceId: entity.occurrenceId,
      medicineId: entity.medicineId,
      profileId: entity.profileId,
      scheduledAtIso: entity.scheduledAtIso,
      statusKind: MedicineDoseStatusKind.values.byName(entity.statusKindName),
      actionAtIso: entity.actionAtIso,
      snoozedUntilIso: entity.snoozedUntilIso,
    );
  }
}
