/// Order type enumeration that matches Java OrderType enum
/// Used to differentiate between current orders and order history
enum OrdersType {
  /// All current/active orders
  ALL_ORDERS,
  
  /// Order history (completed/cancelled orders)
  HISTORY_ORDERS;

  /// Get the display name for the order type
  String get displayName {
    switch (this) {
      case OrdersType.ALL_ORDERS:
        return 'الطلبات الحالية';
      case OrdersType.HISTORY_ORDERS:
        return 'سجل الطلبات';
    }
  }

  /// Get the API parameter name
  String get apiName {
    switch (this) {
      case OrdersType.ALL_ORDERS:
        return 'all_orders';
      case OrdersType.HISTORY_ORDERS:
        return 'history_orders';
    }
  }

  /// Create OrdersType from string
  static OrdersType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'all_orders':
        return OrdersType.ALL_ORDERS;
      case 'history_orders':
        return OrdersType.HISTORY_ORDERS;
      default:
        return OrdersType.ALL_ORDERS;
    }
  }
}
