import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/CatalogMedicineFormLabelInferenceConstants.dart';
import '../../../core/constants/CategoryFormUnitMappingConstants.dart';
import '../../../core/constants/MedicineScheduleDefaultTimesConstants.dart';
import '../../../core/scheduling/MedicineScheduleFireCalculator.dart';
import '../domain/MedicineReminderDataModels.dart';
import '../domain/MedicineSchedulePayloadModel.dart';

/// In-memory draft for add/edit medicine funnel (PRD §6.3).
class AddMedicineDraftStateModel {
  const AddMedicineDraftStateModel({
    this.editingMedicineId,
    this.displayName = '',
    this.ingredientLine = '',
    this.isCustomMedicine = false,
    this.categoryFormLabel = 'Tablet',
    this.doseAmount = 1,
    this.doseUnit = 'tablet(s)',
    this.scheduleKind = MedicineScheduleKind.daily,
    this.timesPerDay = 1,
    this.doseMinutesOfDay = const [8 * 60],
    this.durationKind = MedicineDurationKind.ongoing,
    this.endDate,
    this.durationDayCount,
    this.notes,
    this.isCriticalMedicine = false,
    this.stockRemaining,
    this.editingTimeIndex = 0,
    this.schedulePayload = const MedicineSchedulePayloadModel(),
  });

  final String? editingMedicineId;
  final String displayName;
  final String ingredientLine;
  final bool isCustomMedicine;
  final String categoryFormLabel;
  final double doseAmount;
  final String doseUnit;
  final MedicineScheduleKind scheduleKind;
  final int timesPerDay;
  final List<int> doseMinutesOfDay;
  final MedicineDurationKind durationKind;
  final DateTime? endDate;
  final int? durationDayCount;
  final String? notes;
  final bool isCriticalMedicine;
  final double? stockRemaining;
  final int editingTimeIndex;
  final MedicineSchedulePayloadModel schedulePayload;

  bool get isEditMode => editingMedicineId != null;

  AddMedicineDraftStateModel copyWith({
    String? editingMedicineId,
    String? displayName,
    String? ingredientLine,
    bool? isCustomMedicine,
    String? categoryFormLabel,
    double? doseAmount,
    String? doseUnit,
    MedicineScheduleKind? scheduleKind,
    int? timesPerDay,
    List<int>? doseMinutesOfDay,
    MedicineDurationKind? durationKind,
    DateTime? endDate,
    int? durationDayCount,
    String? notes,
    bool? isCriticalMedicine,
    double? stockRemaining,
    int? editingTimeIndex,
    MedicineSchedulePayloadModel? schedulePayload,
    bool clearNotes = false,
    bool clearStock = false,
    bool clearEditingId = false,
    bool clearEndDate = false,
    bool clearDurationDayCount = false,
  }) {
    return AddMedicineDraftStateModel(
      editingMedicineId:
          clearEditingId ? null : (editingMedicineId ?? this.editingMedicineId),
      displayName: displayName ?? this.displayName,
      ingredientLine: ingredientLine ?? this.ingredientLine,
      isCustomMedicine: isCustomMedicine ?? this.isCustomMedicine,
      categoryFormLabel: categoryFormLabel ?? this.categoryFormLabel,
      doseAmount: doseAmount ?? this.doseAmount,
      doseUnit: doseUnit ?? this.doseUnit,
      scheduleKind: scheduleKind ?? this.scheduleKind,
      timesPerDay: timesPerDay ?? this.timesPerDay,
      doseMinutesOfDay: doseMinutesOfDay ?? this.doseMinutesOfDay,
      durationKind: durationKind ?? this.durationKind,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      durationDayCount:
          clearDurationDayCount ? null : (durationDayCount ?? this.durationDayCount),
      notes: clearNotes ? null : (notes ?? this.notes),
      isCriticalMedicine: isCriticalMedicine ?? this.isCriticalMedicine,
      stockRemaining: clearStock ? null : (stockRemaining ?? this.stockRemaining),
      editingTimeIndex: editingTimeIndex ?? this.editingTimeIndex,
      schedulePayload: schedulePayload ?? this.schedulePayload,
    );
  }
}

class AddMedicineDraftNotifier extends Notifier<AddMedicineDraftStateModel> {
  @override
  AddMedicineDraftStateModel build() => const AddMedicineDraftStateModel();

  void resetDraft() {
    state = const AddMedicineDraftStateModel();
  }

  void loadFromMedicine(MedicineStoredRecordModel medicine) {
    state = AddMedicineDraftStateModel(
      editingMedicineId: medicine.medicineId,
      displayName: medicine.displayName,
      ingredientLine: medicine.ingredientLine,
      isCustomMedicine: medicine.isCustomMedicine,
      categoryFormLabel: medicine.categoryFormLabel,
      doseAmount: medicine.doseAmount,
      doseUnit: medicine.doseUnit,
      scheduleKind: medicine.scheduleKind,
      timesPerDay: medicine.doseMinutesOfDay.length,
      doseMinutesOfDay: List<int>.from(medicine.doseMinutesOfDay),
      durationKind: medicine.durationKind,
      endDate: medicine.endDateIso != null
          ? DateTime.tryParse(medicine.endDateIso!)
          : null,
      durationDayCount: medicine.durationDayCount,
      notes: medicine.notes,
      isCriticalMedicine: medicine.isCriticalMedicine,
      stockRemaining: medicine.stockRemaining,
      schedulePayload: medicine.schedulePayload,
    );
  }

  void applyCatalogSuggestion(MedicineCatalogSuggestionModel suggestion) {
    _applyMedicineNameWithInferredForm(
      displayName: suggestion.displayName,
      ingredientLine: suggestion.ingredientLine,
      isCustomMedicine: false,
      catalogEntryRaw: suggestion.catalogEntryRaw,
    );
  }

  void applyCustomMedicineName(String name) {
    _applyMedicineNameWithInferredForm(
      displayName: name,
      ingredientLine: 'Custom medicine',
      isCustomMedicine: true,
    );
  }

  void _applyMedicineNameWithInferredForm({
    required String displayName,
    required String ingredientLine,
    required bool isCustomMedicine,
    String catalogEntryRaw = '',
  }) {
    final formLabel = CatalogMedicineFormLabelInferenceConstants.inferFormLabel(
      displayName: displayName,
      catalogEntryRaw: catalogEntryRaw,
    );
    state = state.copyWith(
      displayName: displayName,
      ingredientLine: ingredientLine,
      isCustomMedicine: isCustomMedicine,
      categoryFormLabel: formLabel,
      doseUnit: CategoryFormUnitMappingConstants.defaultUnitForForm(formLabel),
    );
  }

  void applyCategoryForm(String formLabel) {
    final defaultUnit = CategoryFormUnitMappingConstants.defaultUnitForForm(
      formLabel,
    );
    state = state.copyWith(
      categoryFormLabel: formLabel,
      doseUnit: defaultUnit,
    );
  }

  void applyDoseAmount(String text) {
    final parsed = double.tryParse(text.trim());
    if (parsed != null && parsed > 0) {
      state = state.copyWith(doseAmount: parsed);
    }
  }

  void applyDoseUnit(String unit) {
    state = state.copyWith(doseUnit: unit);
  }

  void applyScheduleKind(MedicineScheduleKind kind) {
    var minutes = state.doseMinutesOfDay;
    var payload = state.schedulePayload;
    var timesPerDay = state.timesPerDay;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final defaultMorning =
        MedicineScheduleDefaultTimesConstants.defaultMorningMinutes;

    switch (kind) {
      case MedicineScheduleKind.daily:
        minutes = [defaultMorning];
      case MedicineScheduleKind.timesPerDay:
        timesPerDay = timesPerDay.clamp(
          MedicineScheduleDefaultTimesConstants.timesPerDayMin,
          MedicineScheduleDefaultTimesConstants.timesPerDayMax,
        );
        if (timesPerDay < MedicineScheduleDefaultTimesConstants.timesPerDayMin) {
          timesPerDay = MedicineScheduleDefaultTimesConstants.defaultTimesPerDay;
        }
        minutes = MedicineScheduleFireCalculator.defaultMinutesForTimesPerDay(
          timesPerDay,
        );
      case MedicineScheduleKind.onDemand:
        minutes = const [];
      case MedicineScheduleKind.oneTime:
        minutes = const [];
        payload = payload.copyWith(
          oneTimeAtIso: MedicineScheduleFireCalculator.defaultOneTimeDateTime(now)
              .toIso8601String(),
        );
      case MedicineScheduleKind.everyXHours:
        final hours = MedicineScheduleDefaultTimesConstants.defaultEveryXHoursInterval;
        minutes = MedicineScheduleFireCalculator.everyXHoursSlotMinutes(
          intervalHours: hours,
          dayStartMinutes: defaultMorning,
        );
        payload = payload.copyWith(
          everyXHours: hours,
          scheduleAnchorDateIso: MedicineScheduleFireCalculator
              .anchorOnDateWithMinutes(date: today, minutesOfDay: defaultMorning)
              .toIso8601String(),
        );
      case MedicineScheduleKind.specificDaysOfWeek:
        minutes = [defaultMorning];
        payload = payload.copyWith(
          weekdays: [
            MedicineScheduleDefaultTimesConstants.weekdayCodeFromDateTime(now),
          ],
        );
      case MedicineScheduleKind.everyXDays:
        minutes = [defaultMorning];
        payload = payload.copyWith(
          everyXDays: MedicineScheduleDefaultTimesConstants.defaultEveryXDays,
          scheduleAnchorDateIso: MedicineScheduleFireCalculator
              .anchorOnDateWithMinutes(date: today, minutesOfDay: defaultMorning)
              .toIso8601String(),
        );
      case MedicineScheduleKind.weekly:
        minutes = [defaultMorning];
        payload = payload.copyWith(
          everyXWeeks: MedicineScheduleDefaultTimesConstants.defaultEveryXWeeks,
          weekdays: [
            MedicineScheduleDefaultTimesConstants.weekdayCodeFromDateTime(now),
          ],
          scheduleAnchorDateIso: MedicineScheduleFireCalculator
              .anchorOnDateWithMinutes(date: today, minutesOfDay: defaultMorning)
              .toIso8601String(),
        );
      case MedicineScheduleKind.monthly:
        minutes = [MedicineScheduleDefaultTimesConstants.defaultMonthlyMinutes];
        payload = payload.copyWith(
          monthlyDayOfMonth: 1,
          monthlyUseLastDayOfMonth: false,
        );
      case MedicineScheduleKind.cyclic:
        minutes = [defaultMorning];
        payload = payload.copyWith(
          cyclicOnDays: MedicineScheduleDefaultTimesConstants.cyclicOnDaysDefault,
          cyclicOffDays:
              MedicineScheduleDefaultTimesConstants.cyclicOffDaysDefault,
        );
    }
    state = state.copyWith(
      scheduleKind: kind,
      timesPerDay: timesPerDay,
      doseMinutesOfDay: minutes,
      schedulePayload: payload,
    );
  }

  void applyTimesPerDay(int count) {
    final clamped = count.clamp(
      MedicineScheduleDefaultTimesConstants.timesPerDayMin,
      MedicineScheduleDefaultTimesConstants.timesPerDayMax,
    );
    state = state.copyWith(
      timesPerDay: clamped,
      doseMinutesOfDay:
          MedicineScheduleFireCalculator.defaultMinutesForTimesPerDay(clamped),
    );
  }

  void applyEveryXHoursInterval(int hours) {
    final clamped = hours.clamp(
      MedicineScheduleDefaultTimesConstants.everyXHoursMin,
      MedicineScheduleDefaultTimesConstants.everyXHoursMax,
    );
    final dayStart = state.doseMinutesOfDay.isEmpty
        ? MedicineScheduleDefaultTimesConstants.defaultMorningMinutes
        : state.doseMinutesOfDay.first;
    final anchor = _anchorFromPayloadOrToday(dayStart);
    state = state.copyWith(
      doseMinutesOfDay: MedicineScheduleFireCalculator.everyXHoursSlotMinutes(
        intervalHours: clamped,
        dayStartMinutes: dayStart,
      ),
      schedulePayload: state.schedulePayload.copyWith(
        everyXHours: clamped,
        scheduleAnchorDateIso: anchor.toIso8601String(),
      ),
    );
  }

  void applyEveryXHoursDayStart(int minutesOfDay) {
    final hours = state.schedulePayload.everyXHours;
    final anchor = _anchorFromPayloadOrToday(minutesOfDay);
    state = state.copyWith(
      doseMinutesOfDay: MedicineScheduleFireCalculator.everyXHoursSlotMinutes(
        intervalHours: hours,
        dayStartMinutes: minutesOfDay,
      ),
      schedulePayload: state.schedulePayload.copyWith(
        scheduleAnchorDateIso: anchor.toIso8601String(),
      ),
    );
  }

  void applyOneTimeAt(DateTime at) {
    state = state.copyWith(
      schedulePayload: state.schedulePayload.copyWith(oneTimeAtIso: at.toIso8601String()),
    );
  }

  void applyScheduleAnchorDate(DateTime date) {
    final minutes = state.doseMinutesOfDay.isEmpty
        ? MedicineScheduleDefaultTimesConstants.defaultMorningMinutes
        : state.doseMinutesOfDay.first;
    state = state.copyWith(
      schedulePayload: state.schedulePayload.copyWith(
        scheduleAnchorDateIso: MedicineScheduleFireCalculator.anchorOnDateWithMinutes(
          date: DateTime(date.year, date.month, date.day),
          minutesOfDay: minutes,
        ).toIso8601String(),
      ),
    );
  }

  void toggleWeekday(int weekdayCode) {
    final current = List<int>.from(state.schedulePayload.weekdays);
    if (current.contains(weekdayCode)) {
      if (current.length <= 1) return;
      current.remove(weekdayCode);
    } else {
      current.add(weekdayCode);
    }
    current.sort();
    state = state.copyWith(
      schedulePayload: state.schedulePayload.copyWith(weekdays: current),
    );
  }

  DateTime _anchorFromPayloadOrToday(int minutesOfDay) {
    final parsed = DateTime.tryParse(
      state.schedulePayload.scheduleAnchorDateIso ?? '',
    );
    final date = parsed ?? DateTime.now();
    return MedicineScheduleFireCalculator.anchorOnDateWithMinutes(
      date: DateTime(date.year, date.month, date.day),
      minutesOfDay: minutesOfDay,
    );
  }

  void applyTimeAtIndex(int index, int minutesOfDay) {
    final updated = List<int>.from(state.doseMinutesOfDay);
    if (index >= updated.length) {
      updated.add(minutesOfDay);
    } else {
      updated[index] = minutesOfDay;
    }
    updated.sort();
    state = state.copyWith(doseMinutesOfDay: updated);
  }

  void applyDurationKind(MedicineDurationKind kind) {
    switch (kind) {
      case MedicineDurationKind.ongoing:
        state = state.copyWith(
          durationKind: kind,
          clearEndDate: true,
          clearDurationDayCount: true,
        );
      case MedicineDurationKind.untilDate:
        state = state.copyWith(
          durationKind: kind,
          endDate: state.endDate ??
              DateTime.now().add(const Duration(days: 30)),
          clearDurationDayCount: true,
        );
      case MedicineDurationKind.forDays:
        state = state.copyWith(
          durationKind: kind,
          durationDayCount: state.durationDayCount ?? 7,
          clearEndDate: true,
        );
    }
  }

  void applyDurationEndDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    state = state.copyWith(endDate: normalized);
  }

  void applyDurationDayCount(int dayCount) {
    state = state.copyWith(durationDayCount: dayCount.clamp(1, 9999));
  }

  void applySchedulePayload(MedicineSchedulePayloadModel payload) {
    state = state.copyWith(schedulePayload: payload);
  }

  void applyNotes(String? notes) {
    state = state.copyWith(
      notes: notes?.trim().isEmpty == true ? null : notes?.trim(),
      clearNotes: notes?.trim().isEmpty == true,
    );
  }

  void applyCriticalFlag(bool value) {
    state = state.copyWith(isCriticalMedicine: value);
  }

  void applyStock(String? text) {
    if (text == null || text.trim().isEmpty) {
      state = state.copyWith(clearStock: true);
      return;
    }
    final parsed = double.tryParse(text.trim());
    if (parsed != null) {
      state = state.copyWith(stockRemaining: parsed);
    }
  }
}

final addMedicineDraftNotifierProvider =
    NotifierProvider<AddMedicineDraftNotifier, AddMedicineDraftStateModel>(
  AddMedicineDraftNotifier.new,
);
