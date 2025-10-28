import 'package:equatable/equatable.dart';

/// Payment Response model (matching Java PaymentResponse)
class PaymentResponse extends Equatable {
  final PaymentData? data;
  final String? message;
  final String? status;

  const PaymentResponse({
    this.data,
    this.message,
    this.status,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      data: json['data'] != null 
          ? PaymentData.fromJson(json['data']) 
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

  @override
  List<Object?> get props => [data, message, status];
}

/// Payment Data model
class PaymentData extends Equatable {
  final int orderId;
  final String? paymentStatus;
  final String? transactionId;

  const PaymentData({
    required this.orderId,
    this.paymentStatus,
    this.transactionId,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      orderId: json['order_id'] ?? 0,
      paymentStatus: json['payment_status'],
      transactionId: json['transaction_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'payment_status': paymentStatus,
      'transaction_id': transactionId,
    };
  }

  @override
  List<Object?> get props => [orderId, paymentStatus, transactionId];
}
