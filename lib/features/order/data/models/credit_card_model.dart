import 'dart:convert';
import '../../domain/entities/credit_card.dart';

/// CreditCard data model for serialization
class CreditCardModel extends CreditCard {
  const CreditCardModel({
    required super.creditCardId,
    required super.hashedCardNumber,
    required super.cardType,
    required super.expiryMonth,
    required super.expiryYear,
    required super.cardHolderName,
    super.isPrimary,
  });

  /// Create from JSON (matching Java CreditCard)
  factory CreditCardModel.fromJson(Map<String, dynamic> json) {
    return CreditCardModel(
      creditCardId: json['credit_card_id'] ?? 0,
      hashedCardNumber: json['hashed_card_number'] ?? '',
      cardType: json['card_type'] ?? '',
      expiryMonth: json['expiry_month'] ?? '',
      expiryYear: json['expiry_year'] ?? '',
      cardHolderName: json['card_holder_name'] ?? '',
      isPrimary: json['is_primary'] ?? false,
    );
  }

  /// Convert to JSON (matching Java CreditCard)
  Map<String, dynamic> toJson() {
    return {
      'credit_card_id': creditCardId,
      'hashed_card_number': hashedCardNumber,
      'card_type': cardType,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'card_holder_name': cardHolderName,
      'is_primary': isPrimary,
    };
  }

  /// Create from entity
  factory CreditCardModel.fromEntity(CreditCard entity) {
    return CreditCardModel(
      creditCardId: entity.creditCardId,
      hashedCardNumber: entity.hashedCardNumber,
      cardType: entity.cardType,
      expiryMonth: entity.expiryMonth,
      expiryYear: entity.expiryYear,
      cardHolderName: entity.cardHolderName,
      isPrimary: entity.isPrimary,
    );
  }

  /// Convert to JSON string
  String toJsonString() => json.encode(toJson());

  /// Create from JSON string
  static CreditCardModel fromJsonString(String jsonString) =>
      CreditCardModel.fromJson(json.decode(jsonString));

  /// Convert to entity
  CreditCard toEntity() => this;

  /// Copy with updated values (override to return CreditCardModel)
  @override
  CreditCardModel copyWith({
    int? creditCardId,
    String? hashedCardNumber,
    String? cardType,
    String? expiryMonth,
    String? expiryYear,
    String? cardHolderName,
    bool? isPrimary,
  }) {
    return CreditCardModel(
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
