/// Order Type enumeration (matching Java OrderType)
enum OrderType {
  normal,
  isSkipSelection;

  // Static constants for backward compatibility
  static const OrderType NORMAL = OrderType.normal;
  static const OrderType SKIP_SELECTION = OrderType.isSkipSelection;

  /// Get display name
  String get displayName {
    switch (this) {
      case OrderType.normal:
        return 'Normal Order';
      case OrderType.isSkipSelection:
        return 'Skip Selection';
    }
  }

  /// Convert from string
  static OrderType? fromString(String value) {
    switch (value.toLowerCase()) {
      case 'normal':
        return OrderType.normal;
      case 'is_skip_selection':
      case 'skip_selection':
        return OrderType.isSkipSelection;
      default:
        return null;
    }
  }

  /// Convert to string
  String toApiString() {
    switch (this) {
      case OrderType.normal:
        return 'normal';
      case OrderType.isSkipSelection:
        return 'skip_selection';
    }
  }
}
