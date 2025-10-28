import 'dart:convert';
import '../../domain/entities/date_slot.dart';

/// DateSlot data model for serialization
class DateSlotModel extends DateSlot {
  const DateSlotModel({
    required super.dateSlotId,
    required super.date,
    required super.dayName,
    required super.shortDayName,
    super.isAvailable,
    super.isToday,
    super.isTomorrow,
  });

  /// Create from JSON (matching Java DateSlot)
  factory DateSlotModel.fromJson(Map<String, dynamic> json) {
    return DateSlotModel(
      dateSlotId: json['date_slot_id'] ?? 0,
      date: json['date'] ?? '',
      dayName: json['day_name'] ?? '',
      shortDayName: json['short_day_name'] ?? '',
      isAvailable: json['is_available'] ?? true,
      isToday: json['is_today'] ?? false,
      isTomorrow: json['is_tomorrow'] ?? false,
    );
  }

  /// Convert to JSON (matching Java DateSlot)
  Map<String, dynamic> toJson() {
    return {
      'date_slot_id': dateSlotId,
      'date': date,
      'day_name': dayName,
      'short_day_name': shortDayName,
      'is_available': isAvailable,
      'is_today': isToday,
      'is_tomorrow': isTomorrow,
    };
  }

  /// Create from entity
  factory DateSlotModel.fromEntity(DateSlot entity) {
    return DateSlotModel(
      dateSlotId: entity.dateSlotId,
      date: entity.date,
      dayName: entity.dayName,
      shortDayName: entity.shortDayName,
      isAvailable: entity.isAvailable,
      isToday: entity.isToday,
      isTomorrow: entity.isTomorrow,
    );
  }

  /// Convert to JSON string
  String toJsonString() => json.encode(toJson());

  /// Create from JSON string
  static DateSlotModel fromJsonString(String jsonString) =>
      DateSlotModel.fromJson(json.decode(jsonString));

  /// Copy with updated values (override to return DateSlotModel)
  @override
  DateSlotModel copyWith({
    int? dateSlotId,
    String? date,
    String? dayName,
    String? shortDayName,
    bool? isAvailable,
    bool? isToday,
    bool? isTomorrow,
  }) {
    return DateSlotModel(
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
