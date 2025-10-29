/// Payment Method enumeration (matching Java PaymentMethod)
enum PaymentMethod {
  cod, // Cash on Delivery
  ccod, // Credit Card on Delivery
  creditCard, // Online Credit Card
  wallet, // Digital Wallet
  bankTransfer; // Bank Transfer

  // Static constants for backward compatibility
  static const PaymentMethod CASH = PaymentMethod.cod;
  static const PaymentMethod CREDIT_CARD = PaymentMethod.creditCard;
  static const PaymentMethod WALLET = PaymentMethod.wallet;
  static const PaymentMethod BANK_TRANSFER = PaymentMethod.bankTransfer;

  /// Get display name
  String get displayName {
    switch (this) {
      case PaymentMethod.cod:
        return 'Cash';
      case PaymentMethod.ccod:
        return 'Credit Card on Delivery';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.wallet:
        return 'Digital Wallet';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
    }
  }

  /// Get display name in Arabic
  String get arabicDisplayName {
    switch (this) {
      case PaymentMethod.cod:
        return 'الدفع نقداً';
      case PaymentMethod.ccod:
        return 'بطاقة ائتمان عند التسليم';
      case PaymentMethod.creditCard:
        return 'بطاقة ائتمان';
      case PaymentMethod.wallet:
        return 'المحفظة الرقمية';
      case PaymentMethod.bankTransfer:
        return 'حوالة بنكية';
    }
  }

  /// Convert from string
  static PaymentMethod? fromString(String value) {
    switch (value.toUpperCase()) {
      case 'COD':
        return PaymentMethod.cod;
      case 'CCOD':
        return PaymentMethod.ccod;
      case 'CREDIT_CARD':
      case 'CREDITCARD':
        return PaymentMethod.creditCard;
      case 'WALLET':
        return PaymentMethod.wallet;
      case 'BANK_TRANSFER':
      case 'BANKTRANSFER':
        return PaymentMethod.bankTransfer;
      default:
        return null;
    }
  }

  /// Convert to API string
  String toApiString() {
    switch (this) {
      case PaymentMethod.cod:
        return 'COD';
      case PaymentMethod.ccod:
        return 'CCOD';
      case PaymentMethod.creditCard:
        return 'CREDIT_CARD';
      case PaymentMethod.wallet:
        return 'WALLET';
      case PaymentMethod.bankTransfer:
        return 'BANK_TRANSFER';
    }
  }
}
