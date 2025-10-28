/// Account status enumeration (matching Java AccountStatus)
enum AccountStatus {
  newCustomer,
  notVerifiedCustomer,
  verifiedCustomer,
  enterPassword;

  // Static constants for backward compatibility
  static const AccountStatus NEW_CUSTOMER = AccountStatus.newCustomer;
  static const AccountStatus NOT_VERIFIED_CUSTOMER = AccountStatus.notVerifiedCustomer;
  static const AccountStatus VERIFIED_CUSTOMER = AccountStatus.verifiedCustomer;
  static const AccountStatus ENTER_PASSWORD = AccountStatus.enterPassword;

  /// Get display name
  String get displayName {
    switch (this) {
      case AccountStatus.newCustomer:
        return 'New Customer';
      case AccountStatus.notVerifiedCustomer:
        return 'Not Verified Customer';
      case AccountStatus.verifiedCustomer:
        return 'Verified Customer';
      case AccountStatus.enterPassword:
        return 'Enter Password';
    }
  }

  /// Convert from string
  static AccountStatus? fromString(String value) {
    switch (value.toLowerCase()) {
      case 'new_customer':
      case 'newcustomer':
        return AccountStatus.newCustomer;
      case 'not_verified_customer':
      case 'notverifiedcustomer':
        return AccountStatus.notVerifiedCustomer;
      case 'verified_customer':
      case 'verifiedcustomer':
        return AccountStatus.verifiedCustomer;
      case 'enter_password':
      case 'enterpassword':
        return AccountStatus.enterPassword;
      default:
        return null;
    }
  }

  /// Convert to API string
  String toApiString() {
    switch (this) {
      case AccountStatus.newCustomer:
        return 'new_customer';
      case AccountStatus.notVerifiedCustomer:
        return 'not_verified_customer';
      case AccountStatus.verifiedCustomer:
        return 'verified_customer';
      case AccountStatus.enterPassword:
        return 'enter_password';
    }
  }
}
