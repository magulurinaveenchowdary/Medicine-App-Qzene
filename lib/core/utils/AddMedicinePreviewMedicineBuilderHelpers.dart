import '../../features/medicines/application/AddMedicineDraftNotifier.dart';
import '../../features/medicines/domain/MedicineReminderDataModels.dart';

/// Builds a [MedicineStoredRecordModel] for schedule preview / fire calculation (PRD §6.3 step 25).
class AddMedicinePreviewMedicineBuilderHelpers {
  AddMedicinePreviewMedicineBuilderHelpers._();

  static MedicineStoredRecordModel buildFromDraft(AddMedicineDraftStateModel draft) {
    return MedicineStoredRecordModel(
      medicineId: 'preview',
      profileId: 'preview',
      displayName: draft.displayName,
      ingredientLine: draft.ingredientLine,
      isCustomMedicine: draft.isCustomMedicine,
      categoryFormLabel: draft.categoryFormLabel,
      doseAmount: draft.doseAmount,
      doseUnit: draft.doseUnit,
      scheduleKind: draft.scheduleKind,
      doseMinutesOfDay: List<int>.from(draft.doseMinutesOfDay),
      durationKind: draft.durationKind,
      endDateIso: draft.endDate?.toIso8601String(),
      durationDayCount: draft.durationDayCount,
      notes: draft.notes,
      isCriticalMedicine: draft.isCriticalMedicine,
      stockRemaining: draft.stockRemaining,
      createdAtIso: DateTime.now().toIso8601String(),
      schedulePayload: draft.schedulePayload,
    );
  }
}
