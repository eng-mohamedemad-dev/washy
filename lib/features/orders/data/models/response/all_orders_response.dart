import '../order_summary_model.dart';

/// Response model for all orders API matching Java AllOrdersResponse
class AllOrdersResponse {
  final bool success;
  final String message;
  final AllOrdersData? data;

  AllOrdersResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Create from JSON
  factory AllOrdersResponse.fromJson(Map<String, dynamic> json) {
    return AllOrdersResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AllOrdersData.fromJson(json['data']) : null,
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

/// Data part of AllOrdersResponse matching Java AllOrdersResponse.Data
class AllOrdersData {
  final List<OrderSummaryModel> ordersList;
  final int total;
  final int totalPages;

  AllOrdersData({
    required this.ordersList,
    required this.total,
    required this.totalPages,
  });

  /// Create from JSON (matching Java @SerializedName annotations)
  factory AllOrdersData.fromJson(Map<String, dynamic> json) {
    return AllOrdersData(
      ordersList: (json['orders'] as List<dynamic>?)
              ?.map((item) => OrderSummaryModel.fromJson(item))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'orders': ordersList.map((order) => order.toJson()).toList(),
      'total': total,
      'total_pages': totalPages,
    };
  }

  /// Check if has orders
  bool get hasOrders => ordersList.isNotEmpty;

  /// Check if has more pages
  bool get hasMorePages => totalPages > 1;
}
