/// Extra schedule fields per type (PRD §6.6–§6.7).
class MedicineSchedulePayloadModel {
  const MedicineSchedulePayloadModel({
    this.everyXHours = 6,
    this.weekdays = const [1, 2, 3, 4, 5, 6, 7],
    this.everyXWeeks = 1,
    this.everyXDays = 2,
    this.scheduleAnchorDateIso,
    this.monthlyDayOfMonth = 1,
    this.monthlyUseLastDayOfMonth = false,
    this.cyclicOnDays = 21,
    this.cyclicOffDays = 7,
    this.oneTimeAtIso,
    this.feb29UseFeb28InNonLeap = true,
  });

  final int everyXHours;
  final List<int> weekdays;
  final int everyXWeeks;
  final int everyXDays;
  final String? scheduleAnchorDateIso;
  final int monthlyDayOfMonth;
  final bool monthlyUseLastDayOfMonth;
  final int cyclicOnDays;
  final int cyclicOffDays;
  final String? oneTimeAtIso;
  final bool feb29UseFeb28InNonLeap;

  static const int lastDayOfMonthMarker = 32;

  Map<String, dynamic> toJson() => {
        'everyXHours': everyXHours,
        'weekdays': weekdays,
        'everyXWeeks': everyXWeeks,
        'everyXDays': everyXDays,
        'scheduleAnchorDateIso': scheduleAnchorDateIso,
        'monthlyDayOfMonth': monthlyDayOfMonth,
        'monthlyUseLastDayOfMonth': monthlyUseLastDayOfMonth,
        'cyclicOnDays': cyclicOnDays,
        'cyclicOffDays': cyclicOffDays,
        'oneTimeAtIso': oneTimeAtIso,
        'feb29UseFeb28InNonLeap': feb29UseFeb28InNonLeap,
      };

  factory MedicineSchedulePayloadModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MedicineSchedulePayloadModel();
    return MedicineSchedulePayloadModel(
      everyXHours: json['everyXHours'] as int? ?? 6,
      weekdays: (json['weekdays'] as List<dynamic>? ?? [1, 2, 3, 4, 5, 6, 7])
          .map((e) => e as int)
          .toList(),
      everyXWeeks: json['everyXWeeks'] as int? ?? 1,
      everyXDays: json['everyXDays'] as int? ?? 2,
      scheduleAnchorDateIso: json['scheduleAnchorDateIso'] as String?,
      monthlyDayOfMonth: json['monthlyDayOfMonth'] as int? ?? 1,
      monthlyUseLastDayOfMonth:
          json['monthlyUseLastDayOfMonth'] as bool? ?? false,
      cyclicOnDays: json['cyclicOnDays'] as int? ?? 21,
      cyclicOffDays: json['cyclicOffDays'] as int? ?? 7,
      oneTimeAtIso: json['oneTimeAtIso'] as String?,
      feb29UseFeb28InNonLeap:
          json['feb29UseFeb28InNonLeap'] as bool? ?? true,
    );
  }

  MedicineSchedulePayloadModel copyWith({
    int? everyXHours,
    List<int>? weekdays,
    int? everyXWeeks,
    int? everyXDays,
    String? scheduleAnchorDateIso,
    int? monthlyDayOfMonth,
    bool? monthlyUseLastDayOfMonth,
    int? cyclicOnDays,
    int? cyclicOffDays,
    String? oneTimeAtIso,
    bool? feb29UseFeb28InNonLeap,
  }) {
    return MedicineSchedulePayloadModel(
      everyXHours: everyXHours ?? this.everyXHours,
      weekdays: weekdays ?? this.weekdays,
      everyXWeeks: everyXWeeks ?? this.everyXWeeks,
      everyXDays: everyXDays ?? this.everyXDays,
      scheduleAnchorDateIso:
          scheduleAnchorDateIso ?? this.scheduleAnchorDateIso,
      monthlyDayOfMonth: monthlyDayOfMonth ?? this.monthlyDayOfMonth,
      monthlyUseLastDayOfMonth:
          monthlyUseLastDayOfMonth ?? this.monthlyUseLastDayOfMonth,
      cyclicOnDays: cyclicOnDays ?? this.cyclicOnDays,
      cyclicOffDays: cyclicOffDays ?? this.cyclicOffDays,
      oneTimeAtIso: oneTimeAtIso ?? this.oneTimeAtIso,
      feb29UseFeb28InNonLeap:
          feb29UseFeb28InNonLeap ?? this.feb29UseFeb28InNonLeap,
    );
  }
}
