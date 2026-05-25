import 'package:flutter_test/flutter_test.dart';
import 'package:med_reminder/core/scheduling/MedicineScheduleOccurrenceGenerator.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/features/medicines/domain/MedicineSchedulePayloadModel.dart';

void main() {
  test('monthly day 31 fires on last day of February', () {
    final medicine = MedicineStoredRecordModel(
      medicineId: 'm1',
      profileId: 'p1',
      displayName: 'Test',
      ingredientLine: 'Test',
      isCustomMedicine: false,
      categoryFormLabel: 'Tablet',
      doseAmount: 1,
      doseUnit: 'tablet(s)',
      scheduleKind: MedicineScheduleKind.monthly,
      doseMinutesOfDay: const [8 * 60],
      durationKind: MedicineDurationKind.ongoing,
      createdAtIso: DateTime(2026, 1, 1).toIso8601String(),
      schedulePayload: const MedicineSchedulePayloadModel(monthlyDayOfMonth: 31),
    );
    final feb2026 = MedicineScheduleOccurrenceGenerator.generateBetween(
      medicine: medicine,
      rangeStart: DateTime(2026, 2, 1),
      rangeEnd: DateTime(2026, 2, 28, 23, 59),
    );
    expect(feb2026.length, 1);
    expect(feb2026.first.day, 28);
  });
}
