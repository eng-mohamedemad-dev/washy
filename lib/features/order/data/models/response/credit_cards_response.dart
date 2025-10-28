import 'package:equatable/equatable.dart';
import '../credit_card_model.dart';

/// Credit Cards Response model (matching Java GetCreditCardsResponse)
class CreditCardsResponse extends Equatable {
  final CreditCardsData? data;
  final String? message;
  final String? status;

  const CreditCardsResponse({
    this.data,
    this.message,
    this.status,
  });

  factory CreditCardsResponse.fromJson(Map<String, dynamic> json) {
    return CreditCardsResponse(
      data: json['data'] != null 
          ? CreditCardsData.fromJson(json['data']) 
          : null,
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'message': message,
      'status': status,
    };
  }

  /// Get credit cards list for compatibility with repository  
  List<CreditCardModel> get creditCards => data?.creditCards ?? [];

  @override
  List<Object?> get props => [data, message, status];
}

/// Credit Cards Data model
class CreditCardsData extends Equatable {
  final List<CreditCardModel> creditCards;
  final int defaultCreditCard;

  const CreditCardsData({
    required this.creditCards,
    required this.defaultCreditCard,
  });

  factory CreditCardsData.fromJson(Map<String, dynamic> json) {
    return CreditCardsData(
      creditCards: json['credit_cards'] != null
          ? List<CreditCardModel>.from(
              json['credit_cards'].map((x) => CreditCardModel.fromJson(x)),
            )
          : [],
      defaultCreditCard: json['default_credit_card'] ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'credit_cards': creditCards.map((card) => card.toJson()).toList(),
      'default_credit_card': defaultCreditCard,
    };
  }

  @override
  List<Object?> get props => [creditCards, defaultCreditCard];
}
