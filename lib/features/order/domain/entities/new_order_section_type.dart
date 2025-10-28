/// New Order Section Types (matching Java NewOrderSectionType)
enum NewOrderSectionType {
  newOrderHeaderSection,
  productsSection,
  redeemSection,
  recycleHanger,
  terms,
  newOrderTotalSection,
  importantNoteSection,
  paymentSection,
  address,
  time,
  payment,
  notes,
  skipSelectionDetails;

  // Static constants for backward compatibility
  static const NewOrderSectionType ADDRESS = NewOrderSectionType.address;
  static const NewOrderSectionType TIME = NewOrderSectionType.time;
  static const NewOrderSectionType PAYMENT = NewOrderSectionType.payment;
  static const NewOrderSectionType NOTES = NewOrderSectionType.notes;
  static const NewOrderSectionType SKIP_SELECTION_DETAILS = NewOrderSectionType.skipSelectionDetails;

  /// Convert from integer (matching Java fromInteger method)
  static NewOrderSectionType? fromInteger(int x) {
    switch (x) {
      case 0:
        return NewOrderSectionType.newOrderHeaderSection;
      case 1:
        return NewOrderSectionType.productsSection;
      case 2:
        return NewOrderSectionType.redeemSection;
      case 3:
        return NewOrderSectionType.recycleHanger;
      case 4:
        return NewOrderSectionType.terms;
      case 5:
        return NewOrderSectionType.newOrderTotalSection;
      case 6:
        return NewOrderSectionType.importantNoteSection;
      case 7:
        return NewOrderSectionType.paymentSection;
      case 8:
        return NewOrderSectionType.address;
      case 9:
        return NewOrderSectionType.time;
      case 10:
        return NewOrderSectionType.payment;
      case 11:
        return NewOrderSectionType.notes;
      case 12:
        return NewOrderSectionType.skipSelectionDetails;
      default:
        return null;
    }
  }

  /// Convert to integer
  int toInteger() {
    switch (this) {
      case NewOrderSectionType.newOrderHeaderSection:
        return 0;
      case NewOrderSectionType.productsSection:
        return 1;
      case NewOrderSectionType.redeemSection:
        return 2;
      case NewOrderSectionType.recycleHanger:
        return 3;
      case NewOrderSectionType.terms:
        return 4;
      case NewOrderSectionType.newOrderTotalSection:
        return 5;
      case NewOrderSectionType.importantNoteSection:
        return 6;
      case NewOrderSectionType.paymentSection:
        return 7;
      case NewOrderSectionType.address:
        return 8;
      case NewOrderSectionType.time:
        return 9;
      case NewOrderSectionType.payment:
        return 10;
      case NewOrderSectionType.notes:
        return 11;
      case NewOrderSectionType.skipSelectionDetails:
        return 12;
    }
  }
}
