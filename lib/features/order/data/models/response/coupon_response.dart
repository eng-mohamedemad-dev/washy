import 'package:equatable/equatable.dart';
import '../redeem_result_model.dart';

/// Coupon Response model (matching Java CouponResponse)
class CouponResponse extends Equatable {
  final CouponData? data;
  final String? message;
  final String? status;

  const CouponResponse({
    this.data,
    this.message,
    this.status,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      data: json['data'] != null 
          ? CouponData.fromJson(json['data']) 
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

  /// Get properties for compatibility with repository
  bool get success => status == 'success';
  double get discount => data?.redeemResult.discountTotal ?? 0.0;
  int get couponId => data?.redeemResult.id ?? 0;

  @override
  List<Object?> get props => [data, message, status];
}

/// Coupon Data model
class CouponData extends Equatable {
  final RedeemResultModel redeemResult;

  const CouponData({required this.redeemResult});

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      redeemResult: RedeemResultModel.fromJson(json['redeem_result'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'redeem_result': redeemResult.toJson(),
    };
  }

  @override
  List<Object?> get props => [redeemResult];
}
