import 'package:equatable/equatable.dart';

/// Redeem Result entity (matching Java RedeemResult)
class RedeemResult extends Equatable {
  final String code;
  final double discountTotal;
  final double subTotal;
  final bool freeShipping;
  final bool success;
  final int? couponId;
  final String? message;
  final String? description;

  const RedeemResult({
    required this.code,
    required this.discountTotal,
    required this.subTotal,
    required this.freeShipping,
    required this.success,
    this.couponId,
    this.message,
    this.description,
  });

  /// Check if free shipping is enabled
  bool get isFreeShippingEnabled => freeShipping;

  /// Check if discount is applied
  bool get hasDiscount => discountTotal > 0;

  /// Alias for discountTotal (for compatibility)
  double get discount => discountTotal;

  /// Get discount percentage (if applicable)
  double getDiscountPercentage(double originalAmount) {
    if (originalAmount <= 0) return 0;
    return (discountTotal / originalAmount) * 100;
  }

  @override
  List<Object?> get props => [
        code,
        discountTotal,
        subTotal,
        freeShipping,
        success,
        couponId,
        message,
        description,
      ];

  /// Copy with updated values
  RedeemResult copyWith({
    String? code,
    double? discountTotal,
    double? subTotal,
    bool? freeShipping,
    bool? success,
    int? couponId,
    String? message,
    String? description,
  }) {
    return RedeemResult(
      code: code ?? this.code,
      discountTotal: discountTotal ?? this.discountTotal,
      subTotal: subTotal ?? this.subTotal,
      freeShipping: freeShipping ?? this.freeShipping,
      success: success ?? this.success,
      couponId: couponId ?? this.couponId,
      message: message ?? this.message,
      description: description ?? this.description,
    );
  }
}
