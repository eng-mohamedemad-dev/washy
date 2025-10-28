import 'package:equatable/equatable.dart';

/// Order Available Time Slots entity (matching Java OrderAvailableTimeSlots)
class OrderAvailableTimeSlots extends Equatable {
  final String startTime;
  final String endTime;
  final int buffer;
  final int deliveryWithin;
  final bool afterThursday;
  final bool afterWednesday;

  const OrderAvailableTimeSlots({
    required this.startTime,
    required this.endTime,
    required this.buffer,
    required this.deliveryWithin,
    required this.afterThursday,
    required this.afterWednesday,
  });

  /// Get time window display
  String get timeWindow => '$startTime - $endTime';

  /// Get buffer display in hours
  String get bufferDisplay => '${buffer}h buffer';

  /// Get delivery within display
  String get deliveryWithinDisplay => 'Within ${deliveryWithin}h';

  @override
  List<Object?> get props => [
        startTime,
        endTime,
        buffer,
        deliveryWithin,
        afterThursday,
        afterWednesday,
      ];

  /// Copy with updated values
  OrderAvailableTimeSlots copyWith({
    String? startTime,
    String? endTime,
    int? buffer,
    int? deliveryWithin,
    bool? afterThursday,
    bool? afterWednesday,
  }) {
    return OrderAvailableTimeSlots(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      buffer: buffer ?? this.buffer,
      deliveryWithin: deliveryWithin ?? this.deliveryWithin,
      afterThursday: afterThursday ?? this.afterThursday,
      afterWednesday: afterWednesday ?? this.afterWednesday,
    );
  }
}
