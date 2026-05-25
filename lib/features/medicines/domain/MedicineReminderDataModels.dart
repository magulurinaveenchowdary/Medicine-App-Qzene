import 'MedicineSchedulePayloadModel.dart';

/// Domain models for medicines, doses, and profiles (PRD §6).
enum MedicineDoseStatusKind {
  upcoming,
  taken,
  skipped,
  missed,
  snoozed,
}

enum MedicineScheduleKind {
  oneTime,
  daily,
  timesPerDay,
  everyXHours,
  specificDaysOfWeek,
  everyXDays,
  weekly,
  monthly,
  cyclic,
  onDemand,
}

enum MedicineDurationKind {
  ongoing,
  untilDate,
  forDays,
}

class UserProfileRecordModel {
  const UserProfileRecordModel({
    required this.profileId,
    required this.displayName,
    this.avatarLetter,
    this.ageYears,
  });

  final String profileId;
  final String displayName;
  final String? avatarLetter;
  final int? ageYears;

  UserProfileRecordModel copyWith({
    String? displayName,
    String? avatarLetter,
    int? ageYears,
  }) {
    return UserProfileRecordModel(
      profileId: profileId,
      displayName: displayName ?? this.displayName,
      avatarLetter: avatarLetter ?? this.avatarLetter,
      ageYears: ageYears ?? this.ageYears,
    );
  }

  Map<String, dynamic> toJson() => {
        'profileId': profileId,
        'displayName': displayName,
        'avatarLetter': avatarLetter,
        'ageYears': ageYears,
      };

  factory UserProfileRecordModel.fromJson(Map<String, dynamic> json) {
    return UserProfileRecordModel(
      profileId: json['profileId'] as String,
      displayName: json['displayName'] as String,
      avatarLetter: json['avatarLetter'] as String?,
      ageYears: json['ageYears'] as int?,
    );
  }
}

class MedicineStoredRecordModel {
  const MedicineStoredRecordModel({
    required this.medicineId,
    required this.profileId,
    required this.displayName,
    required this.ingredientLine,
    required this.isCustomMedicine,
    required this.categoryFormLabel,
    required this.doseAmount,
    required this.doseUnit,
    required this.scheduleKind,
    required this.doseMinutesOfDay,
    required this.durationKind,
    this.endDateIso,
    this.durationDayCount,
    this.notes,
    this.isCriticalMedicine = false,
    this.stockRemaining,
    this.isPaused = false,
    this.createdAtIso,
    this.schedulePayload = const MedicineSchedulePayloadModel(),
  });

  final String medicineId;
  final String profileId;
  final String displayName;
  final String ingredientLine;
  final bool isCustomMedicine;
  final String categoryFormLabel;
  final double doseAmount;
  final String doseUnit;
  final MedicineScheduleKind scheduleKind;
  final List<int> doseMinutesOfDay;
  final MedicineDurationKind durationKind;
  final String? endDateIso;
  final int? durationDayCount;
  final String? notes;
  final bool isCriticalMedicine;
  final double? stockRemaining;
  final bool isPaused;
  final String? createdAtIso;
  final MedicineSchedulePayloadModel schedulePayload;

  bool get isOnDemand => scheduleKind == MedicineScheduleKind.onDemand;

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,
        'profileId': profileId,
        'displayName': displayName,
        'ingredientLine': ingredientLine,
        'isCustomMedicine': isCustomMedicine,
        'categoryFormLabel': categoryFormLabel,
        'doseAmount': doseAmount,
        'doseUnit': doseUnit,
        'scheduleKind': scheduleKind.name,
        'doseMinutesOfDay': doseMinutesOfDay,
        'durationKind': durationKind.name,
        'endDateIso': endDateIso,
        'durationDayCount': durationDayCount,
        'notes': notes,
        'isCriticalMedicine': isCriticalMedicine,
        'stockRemaining': stockRemaining,
        'isPaused': isPaused,
        'createdAtIso': createdAtIso,
        'schedulePayload': schedulePayload.toJson(),
      };

  factory MedicineStoredRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicineStoredRecordModel(
      medicineId: json['medicineId'] as String,
      profileId: json['profileId'] as String,
      displayName: json['displayName'] as String,
      ingredientLine: json['ingredientLine'] as String,
      isCustomMedicine: json['isCustomMedicine'] as bool? ?? false,
      categoryFormLabel: json['categoryFormLabel'] as String,
      doseAmount: (json['doseAmount'] as num).toDouble(),
      doseUnit: json['doseUnit'] as String,
      scheduleKind: MedicineScheduleKind.values.byName(
        json['scheduleKind'] as String,
      ),
      doseMinutesOfDay: (json['doseMinutesOfDay'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      durationKind: MedicineDurationKind.values.byName(
        json['durationKind'] as String,
      ),
      endDateIso: json['endDateIso'] as String?,
      durationDayCount: json['durationDayCount'] as int?,
      notes: json['notes'] as String?,
      isCriticalMedicine: json['isCriticalMedicine'] as bool? ?? false,
      stockRemaining: (json['stockRemaining'] as num?)?.toDouble(),
      isPaused: json['isPaused'] as bool? ?? false,
      createdAtIso: json['createdAtIso'] as String?,
      schedulePayload: MedicineSchedulePayloadModel.fromJson(
        json['schedulePayload'] as Map<String, dynamic>?,
      ),
    );
  }

  MedicineStoredRecordModel copyWith({
    String? displayName,
    String? ingredientLine,
    String? categoryFormLabel,
    double? doseAmount,
    String? doseUnit,
    MedicineScheduleKind? scheduleKind,
    List<int>? doseMinutesOfDay,
    MedicineDurationKind? durationKind,
    String? endDateIso,
    int? durationDayCount,
    String? notes,
    bool? isCriticalMedicine,
    double? stockRemaining,
    bool? isPaused,
    MedicineSchedulePayloadModel? schedulePayload,
    bool clearNotes = false,
    bool clearStock = false,
  }) {
    return MedicineStoredRecordModel(
      medicineId: medicineId,
      profileId: profileId,
      displayName: displayName ?? this.displayName,
      ingredientLine: ingredientLine ?? this.ingredientLine,
      isCustomMedicine: isCustomMedicine,
      categoryFormLabel: categoryFormLabel ?? this.categoryFormLabel,
      doseAmount: doseAmount ?? this.doseAmount,
      doseUnit: doseUnit ?? this.doseUnit,
      scheduleKind: scheduleKind ?? this.scheduleKind,
      doseMinutesOfDay: doseMinutesOfDay ?? this.doseMinutesOfDay,
      durationKind: durationKind ?? this.durationKind,
      endDateIso: endDateIso ?? this.endDateIso,
      durationDayCount: durationDayCount ?? this.durationDayCount,
      notes: clearNotes ? null : (notes ?? this.notes),
      isCriticalMedicine: isCriticalMedicine ?? this.isCriticalMedicine,
      stockRemaining: clearStock ? null : (stockRemaining ?? this.stockRemaining),
      isPaused: isPaused ?? this.isPaused,
      createdAtIso: createdAtIso,
      schedulePayload: schedulePayload ?? this.schedulePayload,
    );
  }
}

class MedicineDoseOccurrenceRecordModel {
  const MedicineDoseOccurrenceRecordModel({
    required this.occurrenceId,
    required this.medicineId,
    required this.profileId,
    required this.scheduledAtIso,
    required this.statusKind,
    this.actionAtIso,
    this.snoozedUntilIso,
  });

  final String occurrenceId;
  final String medicineId;
  final String profileId;
  final String scheduledAtIso;
  final MedicineDoseStatusKind statusKind;
  final String? actionAtIso;
  final String? snoozedUntilIso;

  Map<String, dynamic> toJson() => {
        'occurrenceId': occurrenceId,
        'medicineId': medicineId,
        'profileId': profileId,
        'scheduledAtIso': scheduledAtIso,
        'statusKind': statusKind.name,
        'actionAtIso': actionAtIso,
        'snoozedUntilIso': snoozedUntilIso,
      };

  factory MedicineDoseOccurrenceRecordModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MedicineDoseOccurrenceRecordModel(
      occurrenceId: json['occurrenceId'] as String,
      medicineId: json['medicineId'] as String,
      profileId: json['profileId'] as String,
      scheduledAtIso: json['scheduledAtIso'] as String,
      statusKind: MedicineDoseStatusKind.values.byName(
        json['statusKind'] as String,
      ),
      actionAtIso: json['actionAtIso'] as String?,
      snoozedUntilIso: json['snoozedUntilIso'] as String?,
    );
  }

  MedicineDoseOccurrenceRecordModel copyWith({
    MedicineDoseStatusKind? statusKind,
    String? actionAtIso,
    String? snoozedUntilIso,
  }) {
    return MedicineDoseOccurrenceRecordModel(
      occurrenceId: occurrenceId,
      medicineId: medicineId,
      profileId: profileId,
      scheduledAtIso: scheduledAtIso,
      statusKind: statusKind ?? this.statusKind,
      actionAtIso: actionAtIso ?? this.actionAtIso,
      snoozedUntilIso: snoozedUntilIso ?? this.snoozedUntilIso,
    );
  }
}

/// Row shown on Home / History lists.
class MedicineDoseDisplayRowModel {
  const MedicineDoseDisplayRowModel({
    required this.occurrenceId,
    required this.medicineId,
    required this.medicineDisplayName,
    required this.doseDescription,
    required this.scheduledTimeLabel,
    required this.statusKind,
    this.isCriticalTint = false,
    this.useEyeDropIcon = false,
  });

  final String occurrenceId;
  final String medicineId;
  final String medicineDisplayName;
  final String doseDescription;
  final String scheduledTimeLabel;
  final MedicineDoseStatusKind statusKind;
  final bool isCriticalTint;
  final bool useEyeDropIcon;
}

class MedicineCatalogSuggestionModel {
  const MedicineCatalogSuggestionModel({
    required this.catalogEntryRaw,
    required this.displayName,
    required this.ingredientLine,
    this.isProfileCustom = false,
  });

  final String catalogEntryRaw;
  final String displayName;
  final String ingredientLine;
  final bool isProfileCustom;
}
