import 'package:equatable/equatable.dart';

/// Add Order Response model (matching Java AddOrderResponse)
class AddOrderResponse extends Equatable {
  final AddOrderData? data;
  final String? message;
  final String? status;

  const AddOrderResponse({
    this.data,
    this.message,
    this.status,
  });

  factory AddOrderResponse.fromJson(Map<String, dynamic> json) {
    return AddOrderResponse(
      data: json['data'] != null 
          ? AddOrderData.fromJson(json['data']) 
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

/// Add Order Data model
class AddOrderData extends Equatable {
  final int orderId;
  final String? message;

  const AddOrderData({
    required this.orderId,
    this.message,
  });

  factory AddOrderData.fromJson(Map<String, dynamic> json) {
    return AddOrderData(
      orderId: json['order_id'] ?? 0,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'message': message,
    };
  }

  @override
  List<Object?> get props => [orderId, message];
}
