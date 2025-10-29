import 'package:equatable/equatable.dart';

/// Order status information entity
class OrderStatusInfo extends Equatable {
  final int orderId;
  final OrderTrackingStatus status;
  final DateTime orderDate;
  final String nextStatus;
  final bool canCallAgent;
  final bool canRate;
  final bool canViewDetails;

  const OrderStatusInfo({
    required this.orderId,
    required this.status,
    required this.orderDate,
    required this.nextStatus,
    required this.canCallAgent,
    required this.canRate,
    required this.canViewDetails,
  });

  @override
  List<Object?> get props => [
        orderId,
        status,
        orderDate,
        nextStatus,
        canCallAgent,
        canRate,
        canViewDetails,
      ];
}

/// Order tracking status enum matching Java OrderStatus
enum OrderTrackingStatus {
  PROCESSING,
  PICK_UP,
  CLEANING,
  DELIVERY,
  COMPLETE,
  CANCELED,
  SKIP_SELECTION;

  String get displayName {
    switch (this) {
      case OrderTrackingStatus.PROCESSING:
        return 'قيد المعالجة';
      case OrderTrackingStatus.PICK_UP:
        return 'تم الاستلام';
      case OrderTrackingStatus.CLEANING:
        return 'قيد التنظيف';
      case OrderTrackingStatus.DELIVERY:
        return 'قيد التوصيل';
      case OrderTrackingStatus.COMPLETE:
        return 'مكتمل';
      case OrderTrackingStatus.CANCELED:
        return 'ملغي';
      case OrderTrackingStatus.SKIP_SELECTION:
        return 'طلب سريع';
    }
  }

  int get stepNumber {
    switch (this) {
      case OrderTrackingStatus.PROCESSING:
        return 1;
      case OrderTrackingStatus.PICK_UP:
        return 2;
      case OrderTrackingStatus.CLEANING:
        return 3;
      case OrderTrackingStatus.DELIVERY:
        return 4;
      case OrderTrackingStatus.COMPLETE:
        return 5;
      case OrderTrackingStatus.CANCELED:
        return 0;
      case OrderTrackingStatus.SKIP_SELECTION:
        return 1;
    }
  }

  bool get isCompleted {
    return this == OrderTrackingStatus.COMPLETE;
  }

  bool get isCanceled {
    return this == OrderTrackingStatus.CANCELED;
  }
}



