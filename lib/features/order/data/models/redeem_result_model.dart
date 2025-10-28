import 'dart:convert';
import '../../domain/entities/redeem_result.dart';

/// RedeemResult data model for serialization
class RedeemResultModel extends RedeemResult {
  const RedeemResultModel({
    required super.code,
    required super.discountTotal,
    required super.subTotal,
    required super.freeShipping,
    required super.success,
    super.couponId,
    super.message,
    super.description,
  });

  /// Create from JSON (matching Java RedeemResult)
  factory RedeemResultModel.fromJson(Map<String, dynamic> json) {
    return RedeemResultModel(
      code: json['code'] ?? '',
      discountTotal: (json['discount_total'] ?? 0.0).toDouble(),
      subTotal: (json['sub_total'] ?? 0.0).toDouble(),
      freeShipping: json['free_shipping'] == 1 || json['free_shipping'] == true,
      success: json['success'] == 1 || json['success'] == true,
      couponId: json['coupon_id'],
      message: json['message'],
      description: json['description'],
    );
  }

  /// Convert to JSON (matching Java RedeemResult)
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount_total': discountTotal,
      'sub_total': subTotal,
      'free_shipping': freeShipping ? 1 : 0,
      'success': success ? 1 : 0,
      'coupon_id': couponId,
      'message': message,
      'description': description,
    };
  }

  /// Create from entity
  factory RedeemResultModel.fromEntity(RedeemResult entity) {
    return RedeemResultModel(
      code: entity.code,
      discountTotal: entity.discountTotal,
      subTotal: entity.subTotal,
      freeShipping: entity.freeShipping,
      success: entity.success,
      couponId: entity.couponId,
      message: entity.message,
      description: entity.description,
    );
  }

  /// Convert to JSON string
  String toJsonString() => json.encode(toJson());

  /// Create from JSON string
  static RedeemResultModel fromJsonString(String jsonString) =>
      RedeemResultModel.fromJson(json.decode(jsonString));

  /// Copy with updated values (override to return RedeemResultModel)
  @override
  RedeemResultModel copyWith({
    String? code,
    double? discountTotal,
    double? subTotal,
    bool? freeShipping,
    bool? success,
    int? couponId,
    String? message,
    String? description,
  }) {
    return RedeemResultModel(
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
