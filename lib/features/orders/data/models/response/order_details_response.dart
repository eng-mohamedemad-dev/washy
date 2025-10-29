import '../order_details_model.dart';

/// Response model for order details API matching Java OrderDetailsResponse
class OrderDetailsResponse {
  final bool success;
  final String message;
  final OrderDetailsData? data;

  OrderDetailsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Create from JSON
  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? OrderDetailsData.fromJson(json['data']) : null,
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

/// Data part of OrderDetailsResponse matching Java OrderDetailsResponse.Data
class OrderDetailsData {
  final OrderDetailsModel orderDetails;

  OrderDetailsData({
    required this.orderDetails,
  });

  /// Create from JSON (matching Java @SerializedName("order"))
  factory OrderDetailsData.fromJson(Map<String, dynamic> json) {
    return OrderDetailsData(
      orderDetails: OrderDetailsModel.fromJson(json['order'] ?? {}),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'order': orderDetails.toJson(),
    };
  }
}



