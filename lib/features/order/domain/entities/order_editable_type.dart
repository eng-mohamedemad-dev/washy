/// Order Editable Type enumeration (matching Java OrderEditableType)
enum OrderEditableType {
  normal,
  editable;

  /// Convert from string
  static OrderEditableType? fromString(String value) {
    switch (value.toLowerCase()) {
      case 'normal':
        return OrderEditableType.normal;
      case 'editable':
        return OrderEditableType.editable;
      default:
        return null;
    }
  }

  /// Convert to string
  String toApiString() {
    switch (this) {
      case OrderEditableType.normal:
        return 'normal';
      case OrderEditableType.editable:
        return 'editable';
    }
  }
}
