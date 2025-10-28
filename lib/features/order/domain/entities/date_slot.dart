import 'package:equatable/equatable.dart';

/// Date Slot entity (matching Java DateSlot)
class DateSlot extends Equatable {
  final int dateSlotId;
  final String date;
  final String dayName;
  final String shortDayName;
  final bool isAvailable;
  final bool isToday;
  final bool isTomorrow;

  const DateSlot({
    required this.dateSlotId,
    required this.date,
    required this.dayName,
    required this.shortDayName,
    this.isAvailable = true,
    this.isToday = false,
    this.isTomorrow = false,
  });

  /// Get formatted date display
  String get displayDate {
    if (isToday) return 'Today - $shortDayName';
    if (isTomorrow) return 'Tomorrow - $shortDayName';
    return '$shortDayName - $date';
  }

  /// Get short display date
  String get shortDisplayDate => shortDayName;

  @override
  List<Object?> get props => [
        dateSlotId,
        date,
        dayName,
        shortDayName,
        isAvailable,
        isToday,
        isTomorrow,
      ];

  /// Copy with updated values
  DateSlot copyWith({
    int? dateSlotId,
    String? date,
    String? dayName,
    String? shortDayName,
    bool? isAvailable,
    bool? isToday,
    bool? isTomorrow,
  }) {
    return DateSlot(
      dateSlotId: dateSlotId ?? this.dateSlotId,
      date: date ?? this.date,
      dayName: dayName ?? this.dayName,
      shortDayName: shortDayName ?? this.shortDayName,
      isAvailable: isAvailable ?? this.isAvailable,
      isToday: isToday ?? this.isToday,
      isTomorrow: isTomorrow ?? this.isTomorrow,
    );
  }
}
