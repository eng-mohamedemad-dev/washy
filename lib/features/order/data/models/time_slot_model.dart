import 'dart:convert';
import '../../domain/entities/time_slot.dart';

/// TimeSlot data model for serialization
class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.timeSlotId,
    required super.timeSlot,
    required super.fromTime,
    required super.toTime,
    super.isAvailable,
  });

  /// Create from JSON (matching Java TimeSlot)
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      timeSlotId: json['time_slot_id'] ?? 0,
      timeSlot: json['time_slot'] ?? '',
      fromTime: json['from_time'] ?? '',
      toTime: json['to_time'] ?? '',
      isAvailable: json['is_available'] ?? true,
    );
  }

  /// Convert to JSON (matching Java TimeSlot)
  Map<String, dynamic> toJson() {
    return {
      'time_slot_id': timeSlotId,
      'time_slot': timeSlot,
      'from_time': fromTime,
      'to_time': toTime,
      'is_available': isAvailable,
    };
  }

  /// Create from entity
  factory TimeSlotModel.fromEntity(TimeSlot entity) {
    return TimeSlotModel(
      timeSlotId: entity.timeSlotId,
      timeSlot: entity.timeSlot,
      fromTime: entity.fromTime,
      toTime: entity.toTime,
      isAvailable: entity.isAvailable,
    );
  }

  /// Convert to JSON string
  String toJsonString() => json.encode(toJson());

  /// Create from JSON string
  static TimeSlotModel fromJsonString(String jsonString) =>
      TimeSlotModel.fromJson(json.decode(jsonString));

  /// Copy with updated values (override to return TimeSlotModel)
  @override
  TimeSlotModel copyWith({
    int? timeSlotId,
    String? timeSlot,
    String? fromTime,
    String? toTime,
    bool? isAvailable,
  }) {
    return TimeSlotModel(
      timeSlotId: timeSlotId ?? this.timeSlotId,
      timeSlot: timeSlot ?? this.timeSlot,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
