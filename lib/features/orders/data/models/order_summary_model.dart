import '../../../cart/domain/entities/cart_item.dart';
import '../../domain/entities/order_summary.dart';
import '../../../cart/data/models/cart_item_model.dart';

/// Data model for OrderSummary that matches Java OrderResponseData
class OrderSummaryModel extends OrderSummary {
  const OrderSummaryModel({
    required super.orderId,
    required super.dateAdded,
    required super.total,
    required super.orderStatus,
    required super.products,
    required super.pickupTimeSlotTimeStamp,
    required super.isUnpaid,
    super.isEditMode = false,
    super.isExpanded = false,
    super.orderItems,
    super.orderType,
  });

  /// Create from JSON (matching Java @SerializedName annotations)
  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryModel(
      orderId: json['order_id'] ?? 0,
      dateAdded: json['date_added'] ?? '',
      total: json['total']?.toString() ?? '0',
      orderStatus: json['order_status'] ?? '',
      products: (json['products'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item))
              .toList() ??
          [],
      pickupTimeSlotTimeStamp: json['pickup_timeslot_timestamp'] ?? 0,
      isUnpaid: (json['unpaid'] ?? 0) == 1,
      isEditMode: json['is_edit_mode'] ?? false,
      isExpanded: json['is_expanded'] ?? false,
      orderItems: json['order_items'],
      orderType: json['order_type'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'date_added': dateAdded,
      'total': total,
      'order_status': orderStatus,
      'products':
          products.map((item) => (item as CartItemModel).toJson()).toList(),
      'pickup_timeslot_timestamp': pickupTimeSlotTimeStamp,
      'unpaid': isUnpaid ? 1 : 0,
      'is_edit_mode': isEditMode,
      'is_expanded': isExpanded,
      'order_items': orderItems,
      'order_type': orderType,
    };
  }

  /// Create from domain entity
  factory OrderSummaryModel.fromEntity(OrderSummary entity) {
    return OrderSummaryModel(
      orderId: entity.orderId,
      dateAdded: entity.dateAdded,
      total: entity.total,
      orderStatus: entity.orderStatus,
      products: entity.products,
      pickupTimeSlotTimeStamp: entity.pickupTimeSlotTimeStamp,
      isUnpaid: entity.isUnpaid,
      isEditMode: entity.isEditMode,
      isExpanded: entity.isExpanded,
      orderItems: entity.orderItems,
      orderType: entity.orderType,
    );
  }

  /// Create a copy with updated fields
  @override
  OrderSummaryModel copyWith({
    int? orderId,
    String? dateAdded,
    String? total,
    String? orderStatus,
    List<CartItem>? products,
    int? pickupTimeSlotTimeStamp,
    bool? isUnpaid,
    bool? isEditMode,
    bool? isExpanded,
    String? orderItems,
    String? orderType,
  }) {
    return OrderSummaryModel(
      orderId: orderId ?? this.orderId,
      dateAdded: dateAdded ?? this.dateAdded,
      total: total ?? this.total,
      orderStatus: orderStatus ?? this.orderStatus,
      products: products ?? this.products,
      pickupTimeSlotTimeStamp:
          pickupTimeSlotTimeStamp ?? this.pickupTimeSlotTimeStamp,
      isUnpaid: isUnpaid ?? this.isUnpaid,
      isEditMode: isEditMode ?? this.isEditMode,
      isExpanded: isExpanded ?? this.isExpanded,
      orderItems: orderItems ?? this.orderItems,
      orderType: orderType ?? this.orderType,
    );
  }
}
