/// Response model for cancel order API
class CancelOrderResponse {
  final bool success;
  final String message;
  final CancelOrderData? data;

  CancelOrderResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Create from JSON
  factory CancelOrderResponse.fromJson(Map<String, dynamic> json) {
    return CancelOrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CancelOrderData.fromJson(json['data']) : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

/// Data part of CancelOrderResponse
class CancelOrderData {
  final int orderId;
  final bool cancelled;
  final String? cancellationReason;

  CancelOrderData({
    required this.orderId,
    required this.cancelled,
    this.cancellationReason,
  });

  /// Create from JSON
  factory CancelOrderData.fromJson(Map<String, dynamic> json) {
    return CancelOrderData(
      orderId: json['order_id'] ?? 0,
      cancelled: json['cancelled'] ?? false,
      cancellationReason: json['cancellation_reason'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'cancelled': cancelled,
      'cancellation_reason': cancellationReason,
    };
  }
}
