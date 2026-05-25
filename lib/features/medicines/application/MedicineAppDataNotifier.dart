import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/analytics/AppAnalyticsMappingHelpers.dart';
import '../../../core/constants/AppAnalyticsEventNamesConstants.dart';
import '../../../core/constants/AppAnalyticsParameterNamesConstants.dart';
import '../../../core/providers/AppLocalNotificationsServiceProvider.dart';
import '../../../core/scheduling/MedicineScheduleFireCalculator.dart';
import '../../../core/analytics/AppPrdAnalyticsBridge.dart';
import '../../../core/analytics/AppPrdAnalyticsSupportProviders.dart';
import '../../../core/services/AppFirebaseAnalyticsLoggingService.dart';
import '../data/MedicineLocalPersistenceRepository.dart';
import '../data/MedicinePersistenceRepositoryContract.dart';
import '../data/isar/MedicineIsarPersistenceRepository.dart';
import '../domain/MedicineReminderDataModels.dart';
import '../../../core/scheduling/MedicineScheduleOccurrenceGenerator.dart';
import 'AddMedicineDraftNotifier.dart';

const _uuid = Uuid();

/// Central app data: profiles, medicines, dose occurrences (replaces mock repo).
class MedicineAppDataNotifier extends AsyncNotifier<AppPersistedDataSnapshot> {
  @override
  Future<AppPersistedDataSnapshot> build() async {
    final repo = ref.read(medicinePersistenceRepositoryProvider);
    await repo.initializeIfNeeded();
    return await repo.readSnapshot();
  }

  Future<void> _persist(AppPersistedDataSnapshot snapshot) async {
    final repo = ref.read(medicinePersistenceRepositoryProvider);
    await repo.saveSnapshot(snapshot);
    state = AsyncData(snapshot);
  }

  UserProfileRecordModel activeProfile() {
    final snapshot = state.requireValue;
    final activeId = ref.read(activeUserProfileIdProvider);
    return snapshot.profiles.firstWhere(
      (p) => p.profileId == activeId,
      orElse: () => snapshot.profiles.first,
    );
  }

  List<MedicineStoredRecordModel> medicinesForActiveProfile() {
    final profileId = ref.read(activeUserProfileIdProvider);
    return state.requireValue.medicines
        .where((m) => m.profileId == profileId && !m.isPaused)
        .toList();
  }

  List<MedicineStoredRecordModel> allMedicinesForActiveProfile() {
    final profileId = ref.read(activeUserProfileIdProvider);
    return state.requireValue.medicines
        .where((m) => m.profileId == profileId)
        .toList();
  }

  MedicineStoredRecordModel? medicineById(String medicineId) {
    try {
      return state.requireValue.medicines
          .firstWhere((m) => m.medicineId == medicineId);
    } catch (_) {
      return null;
    }
  }

  Future<void> upsertProfile(UserProfileRecordModel profile) async {
    final snapshot = state.requireValue;
    final profiles = [...snapshot.profiles];
    final index = profiles.indexWhere((p) => p.profileId == profile.profileId);
    if (index >= 0) {
      profiles[index] = profile;
    } else {
      profiles.add(profile);
    }
    await _persist(snapshot.copyWith(profiles: profiles));
  }

  Future<String> saveMedicineFromDraft(AddMedicineDraftStateModel draft) async {
    if (draft.editingMedicineId != null) {
      await updateMedicineFromDraft(
        medicineId: draft.editingMedicineId!,
        draft: draft,
      );
      ref.read(addMedicineDraftNotifierProvider.notifier).resetDraft();
      return draft.editingMedicineId!;
    }
    final snapshot = state.requireValue;
    final profileId = ref.read(activeUserProfileIdProvider);
    final medicineId = _uuid.v4();
    final now = DateTime.now();

    final medicine = MedicineStoredRecordModel(
      medicineId: medicineId,
      profileId: profileId,
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
      createdAtIso: now.toIso8601String(),
      schedulePayload: draft.schedulePayload,
    );

    final newOccurrences = _generateOccurrencesForMedicine(
      medicine: medicine,
      from: now,
      daysAhead: 90,
    );

    final updatedSnapshot = snapshot.copyWith(
      medicines: [...snapshot.medicines, medicine],
      doseOccurrences: [...snapshot.doseOccurrences, ...newOccurrences],
    );
    await _persist(updatedSnapshot);
    await _rescheduleNotifications();
    ref.read(addMedicineDraftNotifierProvider.notifier).resetDraft();
    await _logAddMedicineSaved(medicine);
    return medicineId;
  }

  List<MedicineDoseOccurrenceRecordModel> _generateOccurrencesForMedicine({
    required MedicineStoredRecordModel medicine,
    required DateTime from,
    required int daysAhead,
  }) {
    if (medicine.isOnDemand) return const [];
    final fireTimes = MedicineScheduleOccurrenceGenerator.generateBetween(
      medicine: medicine,
      rangeStart: from,
      rangeEnd: from.add(Duration(days: daysAhead)),
    );
    return fireTimes
        .map(
          (fireAt) => MedicineDoseOccurrenceRecordModel(
            occurrenceId: _uuid.v4(),
            medicineId: medicine.medicineId,
            profileId: medicine.profileId,
            scheduledAtIso: fireAt.toIso8601String(),
            statusKind: MedicineDoseStatusKind.upcoming,
          ),
        )
        .toList();
  }

  Future<void> updateMedicineFromDraft({
    required String medicineId,
    required AddMedicineDraftStateModel draft,
  }) async {
    final existing = medicineById(medicineId);
    if (existing == null) return;
    final updated = existing.copyWith(
      displayName: draft.displayName,
      ingredientLine: draft.ingredientLine,
      categoryFormLabel: draft.categoryFormLabel,
      doseAmount: draft.doseAmount,
      doseUnit: draft.doseUnit,
      scheduleKind: draft.scheduleKind,
      doseMinutesOfDay: List<int>.from(draft.doseMinutesOfDay),
      durationKind: draft.durationKind,
      endDateIso: draft.endDate?.toIso8601String(),
      durationDayCount: draft.durationDayCount,
      notes: draft.notes,
      clearNotes: draft.notes == null,
      isCriticalMedicine: draft.isCriticalMedicine,
      stockRemaining: draft.stockRemaining,
      clearStock: draft.stockRemaining == null,
      schedulePayload: draft.schedulePayload,
    );
    await _replaceMedicineAndRegenerateOccurrences(updated);
  }

  Future<void> updateMedicineFromDraftWithAnalytics({
    required String medicineId,
    required AddMedicineDraftStateModel draft,
    required MedicineStoredRecordModel originalMedicine,
    List<String> fieldsChanged = const [],
  }) async {
    final scheduleChanged = originalMedicine.scheduleKind != draft.scheduleKind;
    if (scheduleChanged) {
      await ref.read(appPrdAnalyticsBridgeProvider).editMedScheduleChanged(
            AppAnalyticsMappingHelpers.scheduleTypeValue(originalMedicine.scheduleKind),
            AppAnalyticsMappingHelpers.scheduleTypeValue(draft.scheduleKind),
          );
    }
    for (final field in fieldsChanged) {
      await ref.read(appPrdAnalyticsBridgeProvider).editMedFieldChanged(field);
    }
    await updateMedicineFromDraft(medicineId: medicineId, draft: draft);
    final saved = medicineById(medicineId);
    if (saved != null) {
      await _logEditMedicineSaved(saved, fieldsChanged: fieldsChanged);
      await logLowStockIfNeeded(saved);
    }
  }

  Future<void> setMedicinePaused(String medicineId, bool isPaused) async {
    final medicine = medicineById(medicineId);
    if (medicine == null) return;
    await _replaceMedicineAndRegenerateOccurrences(
      medicine.copyWith(isPaused: isPaused),
    );
  }

  Future<void> deleteMedicine(String medicineId) async {
    final snapshot = state.requireValue;
    await _persist(
      snapshot.copyWith(
        medicines: snapshot.medicines
            .where((m) => m.medicineId != medicineId)
            .toList(),
        doseOccurrences: snapshot.doseOccurrences
            .where((o) => o.medicineId != medicineId)
            .toList(),
      ),
    );
    await _rescheduleNotifications();
    final analytics = ref.read(appFirebaseAnalyticsLoggingServiceProvider);
    await analytics.syncMedicinesCountUserProperty(
      medicineCountForProfile(ref.read(activeUserProfileIdProvider)),
    );
  }

  Future<void> _replaceMedicineAndRegenerateOccurrences(
    MedicineStoredRecordModel medicine,
  ) async {
    final snapshot = state.requireValue;
    final now = DateTime.now();
    final keptOccurrences = snapshot.doseOccurrences
        .where((o) => o.medicineId != medicine.medicineId)
        .toList();
    final newOccurrences = _generateOccurrencesForMedicine(
      medicine: medicine,
      from: now,
      daysAhead: 90,
    );
    final medicines = snapshot.medicines
        .map((m) => m.medicineId == medicine.medicineId ? medicine : m)
        .toList();
    await _persist(
      snapshot.copyWith(
        medicines: medicines,
        doseOccurrences: [...keptOccurrences, ...newOccurrences],
      ),
    );
    await _rescheduleNotifications();
    final analytics = ref.read(appFirebaseAnalyticsLoggingServiceProvider);
    await analytics.syncMedicinesCountUserProperty(
      medicineCountForProfile(ref.read(activeUserProfileIdProvider)),
    );
  }

  Future<void> switchActiveProfile(String profileId) async {
    final repo = ref.read(medicinePersistenceRepositoryProvider);
    await repo.writeActiveProfileId(profileId);
    ref.read(activeUserProfileIdProvider.notifier).state = profileId;
    state = AsyncData(state.requireValue);
    await _rescheduleNotifications();
    final analytics = ref.read(appFirebaseAnalyticsLoggingServiceProvider);
    await analytics.logPrdEvent(
      AppAnalyticsEventNamesConstants.homeProfileSwitched,
      {
        AppAnalyticsParameterNamesConstants.toProfileIdHash:
            AppAnalyticsMappingHelpers.hashProfileIdForAnalytics(profileId),
      },
    );
  }

  Future<UserProfileRecordModel?> addProfile(String displayName) async {
    final snapshot = state.requireValue;
    if (snapshot.profiles.length >= 3) return null;
    final profile = UserProfileRecordModel(
      profileId: _uuid.v4(),
      displayName: displayName,
      avatarLetter: displayName.isNotEmpty ? displayName[0].toUpperCase() : 'M',
    );
    await _persist(
      snapshot.copyWith(profiles: [...snapshot.profiles, profile]),
    );
    final analytics = ref.read(appFirebaseAnalyticsLoggingServiceProvider);
    await ref.read(appPrdAnalyticsBridgeProvider).profileAddedWithCount(
          state.requireValue.profiles.length,
        );
    await analytics.syncProfileCountUserProperty(state.requireValue.profiles.length);
    return profile;
  }

  Future<void> deleteProfile(String profileId) async {
    final snapshot = state.requireValue;
    if (snapshot.profiles.length <= 1) return;
    await _persist(
      snapshot.copyWith(
        profiles:
            snapshot.profiles.where((p) => p.profileId != profileId).toList(),
        medicines:
            snapshot.medicines.where((m) => m.profileId != profileId).toList(),
        doseOccurrences: snapshot.doseOccurrences
            .where((o) => o.profileId != profileId)
            .toList(),
      ),
    );
    final activeId = ref.read(activeUserProfileIdProvider);
    if (activeId == profileId) {
      final nextId = state.requireValue.profiles.first.profileId;
      await switchActiveProfile(nextId);
    }
  }

  int medicineCountForProfile(String profileId) {
    return state.requireValue.medicines
        .where((m) => m.profileId == profileId)
        .length;
  }

  Map<int, int> adherencePercentByDayForMonth(DateTime month) {
    final profileId = ref.read(activeUserProfileIdProvider);
    final occurrences = state.requireValue.doseOccurrences
        .where((o) => o.profileId == profileId)
        .toList();
    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    final map = <int, int>{};
    for (var d = 1; d <= lastDay; d++) {
      final day = DateTime(month.year, month.month, d);
      final percent = MedicineScheduleOccurrenceGenerator.adherencePercentForDay(
        occurrences: occurrences,
        day: day,
      );
      if (percent >= 0) map[d] = percent;
    }
    return map;
  }

  List<MedicineDoseDisplayRowModel> upcomingDoseRowsWithinMinutes(int minutes) {
    final profileId = ref.read(activeUserProfileIdProvider);
    final now = DateTime.now();
    final windowEnd = now.add(Duration(minutes: minutes));
    final rows = <MedicineDoseDisplayRowModel>[];
    for (final occurrence in state.requireValue.doseOccurrences) {
      if (occurrence.profileId != profileId) continue;
      if (occurrence.statusKind != MedicineDoseStatusKind.upcoming) continue;
      final scheduled = DateTime.parse(occurrence.scheduledAtIso);
      if (scheduled.isBefore(now.subtract(const Duration(minutes: 2))) ||
          scheduled.isAfter(windowEnd)) {
        continue;
      }
      final medicine = medicineById(occurrence.medicineId);
      if (medicine == null || medicine.isPaused) continue;
      rows.add(
        MedicineDoseDisplayRowModel(
          occurrenceId: occurrence.occurrenceId,
          medicineId: medicine.medicineId,
          medicineDisplayName: medicine.displayName,
          doseDescription: MedicineScheduleFireCalculator.buildDoseDescription(
            amount: medicine.doseAmount,
            unit: medicine.doseUnit,
            notes: medicine.notes,
          ),
          scheduledTimeLabel: MedicineScheduleFireCalculator.formatMinutesOfDay(
            scheduled.hour * 60 + scheduled.minute,
          ),
          statusKind: occurrence.statusKind,
          isCriticalTint: medicine.isCriticalMedicine,
          useEyeDropIcon: medicine.categoryFormLabel == 'Drops',
        ),
      );
    }
    return rows;
  }

  Future<void> markDoseTakenByNotification(String occurrenceId) async {
    await markDoseTaken(occurrenceId);
  }

  List<MedicineDoseDisplayRowModel> doseRowsForDate(DateTime calendarDay) {
    final profileId = ref.read(activeUserProfileIdProvider);
    final dayStart = DateTime(calendarDay.year, calendarDay.month, calendarDay.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final now = DateTime.now();

    final rows = <MedicineDoseDisplayRowModel>[];
    for (final occurrence in state.requireValue.doseOccurrences) {
      if (occurrence.profileId != profileId) continue;
      final scheduled = DateTime.parse(occurrence.scheduledAtIso);
      if (scheduled.isBefore(dayStart) || !scheduled.isBefore(dayEnd)) continue;

      final medicine = medicineById(occurrence.medicineId);
      if (medicine == null || medicine.isPaused || medicine.isOnDemand) continue;

      var status = occurrence.statusKind;
      if (status == MedicineDoseStatusKind.upcoming &&
          scheduled.isBefore(now.subtract(const Duration(minutes: 60)))) {
        status = MedicineDoseStatusKind.missed;
      }

      rows.add(
        MedicineDoseDisplayRowModel(
          occurrenceId: occurrence.occurrenceId,
          medicineId: medicine.medicineId,
          medicineDisplayName: medicine.displayName,
          doseDescription: MedicineScheduleFireCalculator.buildDoseDescription(
            amount: medicine.doseAmount,
            unit: medicine.doseUnit,
            notes: medicine.notes,
          ),
          scheduledTimeLabel: MedicineScheduleFireCalculator.formatMinutesOfDay(
            scheduled.hour * 60 + scheduled.minute,
          ),
          statusKind: status,
          isCriticalTint: medicine.isCriticalMedicine,
          useEyeDropIcon: medicine.categoryFormLabel == 'Drops',
        ),
      );
    }
    rows.sort((a, b) => a.scheduledTimeLabel.compareTo(b.scheduledTimeLabel));
    return rows;
  }

  bool get hasAnyMedicinesForProfile {
    return medicinesForActiveProfile().isNotEmpty ||
        state.requireValue.medicines
            .where((m) => m.profileId == ref.read(activeUserProfileIdProvider))
            .isNotEmpty;
  }

  Future<void> markDoseTaken(String occurrenceId) async {
    await _updateOccurrenceStatus(
      occurrenceId,
      MedicineDoseStatusKind.taken,
    );
  }

  Future<void> markDoseSkipped(String occurrenceId) async {
    await _updateOccurrenceStatus(
      occurrenceId,
      MedicineDoseStatusKind.skipped,
    );
  }

  Future<void> markDoseSnoozed(String occurrenceId, int snoozeMinutes) async {
    final snapshot = state.requireValue;
    final index = snapshot.doseOccurrences.indexWhere(
      (o) => o.occurrenceId == occurrenceId,
    );
    if (index < 0) return;
    final existing = snapshot.doseOccurrences[index];
    final snoozeUntil = DateTime.now().add(Duration(minutes: snoozeMinutes));

    final occurrences = [...snapshot.doseOccurrences];
    occurrences[index] = existing.copyWith(
      statusKind: MedicineDoseStatusKind.snoozed,
      snoozedUntilIso: snoozeUntil.toIso8601String(),
    );

    final medicine = medicineById(existing.medicineId);
    if (medicine != null) {
      occurrences.add(
        MedicineDoseOccurrenceRecordModel(
          occurrenceId: _uuid.v4(),
          medicineId: medicine.medicineId,
          profileId: medicine.profileId,
          scheduledAtIso: snoozeUntil.toIso8601String(),
          statusKind: MedicineDoseStatusKind.upcoming,
        ),
      );
    }

    await _persist(snapshot.copyWith(doseOccurrences: occurrences));
    await _rescheduleNotifications();
  }

  Future<void> _updateOccurrenceStatus(
    String occurrenceId,
    MedicineDoseStatusKind status,
  ) async {
    final snapshot = state.requireValue;
    final occurrences = snapshot.doseOccurrences.map((o) {
      if (o.occurrenceId != occurrenceId) return o;
      return o.copyWith(
        statusKind: status,
        actionAtIso: DateTime.now().toIso8601String(),
      );
    }).toList();

    var medicines = snapshot.medicines;
    if (status == MedicineDoseStatusKind.taken) {
      final occurrence = snapshot.doseOccurrences
          .firstWhere((o) => o.occurrenceId == occurrenceId);
      medicines = medicines.map((m) {
        if (m.medicineId != occurrence.medicineId || m.stockRemaining == null) {
          return m;
        }
        return m.copyWith(stockRemaining: m.stockRemaining! - m.doseAmount);
      }).toList();
    }

    await _persist(
      snapshot.copyWith(
        doseOccurrences: occurrences,
        medicines: medicines,
      ),
    );
    await _rescheduleNotifications();
  }

  List<(DateTime date, String label, int taken, int total)> adherenceByDay({
    required DateTime month,
  }) {
    final profileId = ref.read(activeUserProfileIdProvider);
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    final results = <(DateTime, String, int, int)>[];
    for (var d = first.day; d <= last.day; d++) {
      final day = DateTime(month.year, month.month, d);
      final dayRows = state.requireValue.doseOccurrences.where((o) {
        if (o.profileId != profileId) return false;
        final scheduled = DateTime.parse(o.scheduledAtIso);
        return scheduled.year == day.year &&
            scheduled.month == day.month &&
            scheduled.day == day.day;
      });
      final total = dayRows.length;
      final taken = dayRows
          .where((o) => o.statusKind == MedicineDoseStatusKind.taken)
          .length;
      results.add((day, DateFormat('d').format(day), taken, total));
    }
    return results;
  }

  MedicineDoseOccurrenceRecordModel? occurrenceById(String occurrenceId) {
    try {
      return state.requireValue.doseOccurrences
          .firstWhere((o) => o.occurrenceId == occurrenceId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _logAddMedicineSaved(MedicineStoredRecordModel medicine) async {
    final bridge = ref.read(appPrdAnalyticsBridgeProvider);
    final startedAt = ref.read(addMedicineFunnelStartedAtProvider);
    final timeInFlowSec = startedAt != null
        ? DateTime.now().difference(startedAt).inSeconds
        : 0;
    ref.read(addMedicineFunnelStartedAtProvider.notifier).state = null;
    await bridge.addMedSavedExtended(
      category: AppAnalyticsMappingHelpers.categorySlug(medicine.categoryFormLabel),
      scheduleType: AppAnalyticsMappingHelpers.scheduleTypeValue(medicine.scheduleKind),
      hasEndDate: medicine.endDateIso != null,
      hasStockTracking: medicine.stockRemaining != null,
      hasNotes: medicine.notes != null && medicine.notes!.isNotEmpty,
      timeInFlowSec: timeInFlowSec,
    );
    final analytics = ref.read(appFirebaseAnalyticsLoggingServiceProvider);
    await analytics.syncMedicinesCountUserProperty(
      medicineCountForProfile(medicine.profileId),
    );
  }

  Future<void> _logEditMedicineSaved(
    MedicineStoredRecordModel medicine, {
    List<String> fieldsChanged = const [],
  }) async {
    final bridge = ref.read(appPrdAnalyticsBridgeProvider);
    if (fieldsChanged.isEmpty) {
      await bridge.editMedSavedWithFields(medicine.medicineId, ['name']);
    } else {
      await bridge.editMedSavedWithFields(medicine.medicineId, fieldsChanged);
    }
  }

  Future<void> markDoseAutoMissed(String occurrenceId, {int timeoutMin = 60}) async {
    final occurrence = occurrenceById(occurrenceId);
    if (occurrence == null) return;
    await _updateOccurrenceStatus(occurrenceId, MedicineDoseStatusKind.missed);
    await ref.read(appPrdAnalyticsBridgeProvider).alarmAutoMissed(
          occurrence.medicineId,
          timeoutMin,
        );
  }

  Future<void> logLowStockIfNeeded(MedicineStoredRecordModel medicine) async {
    final stock = medicine.stockRemaining;
    if (stock == null || stock > 5) return;
    await ref.read(appPrdAnalyticsBridgeProvider).sysLowStockNotif(
          medicine.medicineId,
          stock.toInt(),
        );
  }

  Future<void> refreshDoseNotifications() => _rescheduleNotifications();

  Future<void> _rescheduleNotifications() async {
    final notifications = ref.read(
      appLocalNotificationsSchedulingServiceProvider,
    );
    final profileId = ref.read(activeUserProfileIdProvider);
    final analytics = ref.read(appFirebaseAnalyticsLoggingServiceProvider);
    final upcoming = <({
      String occurrenceId,
      int notificationId,
      DateTime scheduledAt,
      String title,
      String body,
      bool isCritical,
      String medicineId,
    })>[];
    for (final o in state.requireValue.doseOccurrences) {
      if (o.profileId != profileId ||
          o.statusKind != MedicineDoseStatusKind.upcoming) {
        continue;
      }
      final medicine = medicineById(o.medicineId);
      upcoming.add(
        (
          occurrenceId: o.occurrenceId,
          notificationId: o.occurrenceId.hashCode,
          scheduledAt: DateTime.parse(o.scheduledAtIso),
          title: medicine?.displayName ?? 'Medicine',
          body: medicine != null
              ? MedicineScheduleFireCalculator.buildDoseDescription(
                  amount: medicine.doseAmount,
                  unit: medicine.doseUnit,
                  notes: medicine.notes,
                )
              : 'Time for your dose',
          isCritical: medicine?.isCriticalMedicine ?? false,
          medicineId: o.medicineId,
        ),
      );
    }
    await notifications.rescheduleUpcomingDoseReminders(upcoming);
    await analytics.logPrdEvent(
      AppAnalyticsEventNamesConstants.medicinesRescheduled,
      {'medicines_rescheduled': upcoming.length},
    );
  }
}

final medicinePersistenceRepositoryProvider =
    Provider<MedicinePersistenceRepositoryContract>(
  (ref) => MedicineIsarPersistenceRepository(),
);

final medicineLocalPersistenceRepositoryProvider =
    medicinePersistenceRepositoryProvider;

final medicineAppDataNotifierProvider =
    AsyncNotifierProvider<MedicineAppDataNotifier, AppPersistedDataSnapshot>(
  MedicineAppDataNotifier.new,
);

final activeUserProfileIdProvider = StateProvider<String>((ref) {
  return 'profile_default';
});
