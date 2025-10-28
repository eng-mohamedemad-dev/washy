/// Order Status enumeration (100% matching Java OrderStatus)
enum OrderStatus {
  confirmed,        // تم التأكيد
  pickedUp,        // تم الاستلام  
  inProgress,      // قيد المعالجة
  readyForDelivery, // جاهز للتسليم
  outForDelivery,  // خارج للتسليم
  delivered;       // تم التسليم

  /// Get display name in Arabic
  String get displayName {
    switch (this) {
      case OrderStatus.confirmed:
        return 'تم التأكيد';
      case OrderStatus.pickedUp:
        return 'تم الاستلام';
      case OrderStatus.inProgress:
        return 'قيد المعالجة';
      case OrderStatus.readyForDelivery:
        return 'جاهز للتسليم';
      case OrderStatus.outForDelivery:
        return 'خارج للتسليم';
      case OrderStatus.delivered:
        return 'تم التسليم';
    }
  }

  /// Get status step number (0-based)
  int get stepNumber {
    return index;
  }

  /// Check if status is completed
  bool get isCompleted {
    return index < OrderStatus.delivered.index;
  }

  /// Get next status
  OrderStatus? get next {
    final nextIndex = index + 1;
    if (nextIndex < OrderStatus.values.length) {
      return OrderStatus.values[nextIndex];
    }
    return null;
  }

  /// Convert from string
  static OrderStatus? fromString(String value) {
    switch (value.toUpperCase()) {
      case 'CONFIRMED':
        return OrderStatus.confirmed;
      case 'PICKED_UP':
        return OrderStatus.pickedUp;
      case 'IN_PROGRESS':
        return OrderStatus.inProgress;
      case 'READY_FOR_DELIVERY':
        return OrderStatus.readyForDelivery;
      case 'OUT_FOR_DELIVERY':
        return OrderStatus.outForDelivery;
      case 'DELIVERED':
        return OrderStatus.delivered;
      default:
        return null;
    }
  }

  /// Convert to API string
  String toApiString() {
    switch (this) {
      case OrderStatus.confirmed:
        return 'CONFIRMED';
      case OrderStatus.pickedUp:
        return 'PICKED_UP';
      case OrderStatus.inProgress:
        return 'IN_PROGRESS';
      case OrderStatus.readyForDelivery:
        return 'READY_FOR_DELIVERY';
      case OrderStatus.outForDelivery:
        return 'OUT_FOR_DELIVERY';
      case OrderStatus.delivered:
        return 'DELIVERED';
    }
  }
}
