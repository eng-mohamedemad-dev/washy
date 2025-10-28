import 'package:equatable/equatable.dart';

/// Credit Card entity (matching Java CreditCard)
class CreditCard extends Equatable {
  final int creditCardId;
  final String hashedCardNumber;
  final String cardType;
  final String expiryMonth;
  final String expiryYear;
  final String cardHolderName;
  final bool isPrimary;

  const CreditCard({
    required this.creditCardId,
    required this.hashedCardNumber,
    required this.cardType,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cardHolderName,
    this.isPrimary = false,
  });

  /// Get formatted card number (e.g., **** **** **** 1234)
  String get formattedCardNumber {
    if (hashedCardNumber.length >= 4) {
      final lastFour = hashedCardNumber.substring(hashedCardNumber.length - 4);
      return '**** **** **** $lastFour';
    }
    return hashedCardNumber;
  }

  /// Get formatted expiry date (MM/YY)
  String get formattedExpiryDate => '$expiryMonth/$expiryYear';

  /// Get card display name
  String get displayName => '$cardType ending in ${hashedCardNumber.substring(hashedCardNumber.length - 4)}';

  @override
  List<Object?> get props => [
        creditCardId,
        hashedCardNumber,
        cardType,
        expiryMonth,
        expiryYear,
        cardHolderName,
        isPrimary,
      ];

  /// Copy with updated values
  CreditCard copyWith({
    int? creditCardId,
    String? hashedCardNumber,
    String? cardType,
    String? expiryMonth,
    String? expiryYear,
    String? cardHolderName,
    bool? isPrimary,
  }) {
    return CreditCard(
      creditCardId: creditCardId ?? this.creditCardId,
      hashedCardNumber: hashedCardNumber ?? this.hashedCardNumber,
      cardType: cardType ?? this.cardType,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}
