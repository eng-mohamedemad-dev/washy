/// Address Navigation Type (100% matching Java AddressNavigationType)
enum AddressNavigationType {
  openAddressPageFromProfile,
  addAddressReturnToOrderPage,
  selectAddressFromOrderPage;

  /// Convert to string (matching Java enum names)
  String get name {
    switch (this) {
      case AddressNavigationType.openAddressPageFromProfile:
        return 'OPEN_ADDRESS_PAGE_FROM_PROFILE';
      case AddressNavigationType.addAddressReturnToOrderPage:
        return 'ADD_ADDRESS_RETURN_TO_ORDER_PAGE';
      case AddressNavigationType.selectAddressFromOrderPage:
        return 'SELECT_ADDRESS_FROM_ORDER_PAGE';
    }
  }

  /// Create from string
  static AddressNavigationType? fromString(String value) {
    switch (value) {
      case 'OPEN_ADDRESS_PAGE_FROM_PROFILE':
        return AddressNavigationType.openAddressPageFromProfile;
      case 'ADD_ADDRESS_RETURN_TO_ORDER_PAGE':
        return AddressNavigationType.addAddressReturnToOrderPage;
      case 'SELECT_ADDRESS_FROM_ORDER_PAGE':
        return AddressNavigationType.selectAddressFromOrderPage;
      default:
        return null;
    }
  }
}

