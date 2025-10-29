import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item.dart';

/// Order summary entity that matches OrderResponseData from Java
/// Represents a single order in the orders list
class OrderSummary extends Equatable {
  final int orderId;
  final String dateAdded;
  final String total;
  final String orderStatus;
  final List<CartItem> products;
  final int pickupTimeSlotTimeStamp;
  final bool isUnpaid;
  final bool isEditMode;
  final bool isExpanded;
  final String? orderItems;
  final String? orderType;

  const OrderSummary({
    required this.orderId,
    required this.dateAdded,
    required this.total,
    required this.orderStatus,
    required this.products,
    required this.pickupTimeSlotTimeStamp,
    required this.isUnpaid,
    this.isEditMode = false,
    this.isExpanded = false,
    this.orderItems,
    this.orderType,
  });

  /// Create a copy with some fields updated
  OrderSummary copyWith({
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
    return OrderSummary(
      orderId: orderId ?? this.orderId,
      dateAdded: dateAdded ?? this.dateAdded,
      total: total ?? this.total,
      orderStatus: orderStatus ?? this.orderStatus,
      products: products ?? this.products,
      pickupTimeSlotTimeStamp: pickupTimeSlotTimeStamp ?? this.pickupTimeSlotTimeStamp,
      isUnpaid: isUnpaid ?? this.isUnpaid,
      isEditMode: isEditMode ?? this.isEditMode,
      isExpanded: isExpanded ?? this.isExpanded,
      orderItems: orderItems ?? this.orderItems,
      orderType: orderType ?? this.orderType,
    );
  }

  /// Format the pickup timestamp to readable date
  DateTime get pickupDateTime {
    return DateTime.fromMillisecondsSinceEpoch(pickupTimeSlotTimeStamp * 1000);
  }

  /// Format the date added to readable date
  DateTime? get dateAddedDateTime {
    try {
      return DateTime.parse(dateAdded);
    } catch (e) {
      return null;
    }
  }

  /// Get formatted total price
  double get totalPrice {
    try {
      return double.parse(total);
    } catch (e) {
      return 0.0;
    }
  }

  /// Check if order can be cancelled
  bool get canBeCancelled {
    return orderStatus.toLowerCase() == 'processing' || 
           orderStatus.toLowerCase() == 'pending';
  }

  /// Check if order can be tracked
  bool get canBeTracked {
    return orderStatus.toLowerCase() != 'cancelled' && 
           orderStatus.toLowerCase() != 'completed';
  }

  /// Generate order items string from products
  String generateOrderItemsString() {
    if (products.isEmpty) return '';
    
    final items = products.map((product) => 
        'x${product.quantity} ${product.name}'
    ).join(', ');
    
    return items;
  }

  @override
  List<Object?> get props => [
        orderId,
        dateAdded,
        total,
        orderStatus,
        products,
        pickupTimeSlotTimeStamp,
        isUnpaid,
        isEditMode,
        isExpanded,
        orderItems,
        orderType,
      ];
}

