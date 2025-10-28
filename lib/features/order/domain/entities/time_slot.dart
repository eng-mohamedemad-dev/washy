import 'package:equatable/equatable.dart';

/// Time Slot entity (matching Java TimeSlot)
class TimeSlot extends Equatable {
  final int timeSlotId;
  final String timeSlot;
  final String fromTime;
  final String toTime;
  final bool isAvailable;

  const TimeSlot({
    required this.timeSlotId,
    required this.timeSlot,
    required this.fromTime,
    required this.toTime,
    this.isAvailable = true,
  });

  /// Get formatted time display
  String get displayTime => '$fromTime - $toTime';

  /// Get short display time
  String get shortDisplayTime => timeSlot;

  @override
  List<Object?> get props => [
        timeSlotId,
        timeSlot,
        fromTime,
        toTime,
        isAvailable,
      ];

  /// Copy with updated values
  TimeSlot copyWith({
    int? timeSlotId,
    String? timeSlot,
    String? fromTime,
    String? toTime,
    bool? isAvailable,
  }) {
    return TimeSlot(
      timeSlotId: timeSlotId ?? this.timeSlotId,
      timeSlot: timeSlot ?? this.timeSlot,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
