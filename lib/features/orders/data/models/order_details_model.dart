import '../../domain/entities/order_details.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../order/data/models/washy_address_model.dart';

/// Data model for OrderDetails that matches Java OrderDetails class
class OrderDetailsModel extends OrderDetails {
  const OrderDetailsModel({
    required super.orderId,
    required super.orderStatus,
    required super.dateAdded,
    required super.total,
    super.orderType,
    required super.products,
    super.pickupAddress,
    super.deliveryAddress,
    required super.pickupTimeSlotTimeStamp,
    super.deliveryTimeSlotTimeStamp,
    super.paymentMethod,
    super.notes,
    super.isUnpaid = false,
    super.deliveryFee,
    super.discount,
    super.subtotal,
    super.couponCode,
    super.attachedPhotos,
    super.attachedAudio,
  });

  /// Create from JSON
  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      orderId: json['order_id'] ?? 0,
      orderStatus: json['order_status'] ?? '',
      dateAdded: json['date_added'] ?? '',
      total: json['total']?.toString() ?? '0',
      orderType: json['order_type'],
      products: (json['products'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item))
              .toList() ??
          [],
      pickupAddress: json['pickup_address'] != null
          ? WashyAddressModel.fromJson(json['pickup_address'])
          : null,
      deliveryAddress: json['delivery_address'] != null
          ? WashyAddressModel.fromJson(json['delivery_address'])
          : null,
      pickupTimeSlotTimeStamp: json['pickup_timeslot_timestamp'] ?? 0,
      deliveryTimeSlotTimeStamp: json['delivery_timeslot_timestamp'],
      paymentMethod: json['payment_method'],
      notes: json['notes'],
      isUnpaid: (json['unpaid'] ?? 0) == 1,
      deliveryFee: json['delivery_fee']?.toString(),
      discount: json['discount']?.toString(),
      subtotal: json['subtotal']?.toString(),
      couponCode: json['coupon_code'],
      attachedPhotos: (json['attached_photos'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
      attachedAudio: json['attached_audio'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'order_status': orderStatus,
      'date_added': dateAdded,
      'total': total,
      'order_type': orderType,
      'products': products.map((item) => (item as CartItemModel).toJson()).toList(),
      'pickup_address': pickupAddress != null 
          ? (pickupAddress as WashyAddressModel).toJson() 
          : null,
      'delivery_address': deliveryAddress != null 
          ? (deliveryAddress as WashyAddressModel).toJson() 
          : null,
      'pickup_timeslot_timestamp': pickupTimeSlotTimeStamp,
      'delivery_timeslot_timestamp': deliveryTimeSlotTimeStamp,
      'payment_method': paymentMethod,
      'notes': notes,
      'unpaid': isUnpaid ? 1 : 0,
      'delivery_fee': deliveryFee,
      'discount': discount,
      'subtotal': subtotal,
      'coupon_code': couponCode,
      'attached_photos': attachedPhotos,
      'attached_audio': attachedAudio,
    };
  }

  /// Create from domain entity
  factory OrderDetailsModel.fromEntity(OrderDetails entity) {
    return OrderDetailsModel(
      orderId: entity.orderId,
      orderStatus: entity.orderStatus,
      dateAdded: entity.dateAdded,
      total: entity.total,
      orderType: entity.orderType,
      products: entity.products,
      pickupAddress: entity.pickupAddress,
      deliveryAddress: entity.deliveryAddress,
      pickupTimeSlotTimeStamp: entity.pickupTimeSlotTimeStamp,
      deliveryTimeSlotTimeStamp: entity.deliveryTimeSlotTimeStamp,
      paymentMethod: entity.paymentMethod,
      notes: entity.notes,
      isUnpaid: entity.isUnpaid,
      deliveryFee: entity.deliveryFee,
      discount: entity.discount,
      subtotal: entity.subtotal,
      couponCode: entity.couponCode,
      attachedPhotos: entity.attachedPhotos,
      attachedAudio: entity.attachedAudio,
    );
  }

  /// Create a copy with updated fields
  OrderDetailsModel copyWith({
    int? orderId,
    String? orderStatus,
    String? dateAdded,
    String? total,
    String? orderType,
    List<dynamic>? products,
    dynamic pickupAddress,
    dynamic deliveryAddress,
    int? pickupTimeSlotTimeStamp,
    int? deliveryTimeSlotTimeStamp,
    String? paymentMethod,
    String? notes,
    bool? isUnpaid,
    String? deliveryFee,
    String? discount,
    String? subtotal,
    String? couponCode,
    List<String>? attachedPhotos,
    String? attachedAudio,
  }) {
    return OrderDetailsModel(
      orderId: orderId ?? this.orderId,
      orderStatus: orderStatus ?? this.orderStatus,
      dateAdded: dateAdded ?? this.dateAdded,
      total: total ?? this.total,
      orderType: orderType ?? this.orderType,
      products: products ?? this.products,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      pickupTimeSlotTimeStamp: pickupTimeSlotTimeStamp ?? this.pickupTimeSlotTimeStamp,
      deliveryTimeSlotTimeStamp: deliveryTimeSlotTimeStamp ?? this.deliveryTimeSlotTimeStamp,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      isUnpaid: isUnpaid ?? this.isUnpaid,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      subtotal: subtotal ?? this.subtotal,
      couponCode: couponCode ?? this.couponCode,
      attachedPhotos: attachedPhotos ?? this.attachedPhotos,
      attachedAudio: attachedAudio ?? this.attachedAudio,
    );
  }
}

