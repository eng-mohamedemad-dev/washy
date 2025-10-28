import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../order/domain/entities/washy_address.dart';

/// Order details entity matching Java OrderDetails class
/// Contains full order information for expanded view
class OrderDetails extends Equatable {
  final int orderId;
  final String orderStatus;
  final String dateAdded;
  final String total;
  final String? orderType;
  final List<CartItem> products;
  final WashyAddress? pickupAddress;
  final WashyAddress? deliveryAddress;
  final int pickupTimeSlotTimeStamp;
  final int? deliveryTimeSlotTimeStamp;
  final String? paymentMethod;
  final String? notes;
  final bool isUnpaid;
  final String? deliveryFee;
  final String? discount;
  final String? subtotal;
  final String? couponCode;
  final List<String>? attachedPhotos;
  final String? attachedAudio;

  const OrderDetails({
    required this.orderId,
    required this.orderStatus,
    required this.dateAdded,
    required this.total,
    this.orderType,
    required this.products,
    this.pickupAddress,
    this.deliveryAddress,
    required this.pickupTimeSlotTimeStamp,
    this.deliveryTimeSlotTimeStamp,
    this.paymentMethod,
    this.notes,
    this.isUnpaid = false,
    this.deliveryFee,
    this.discount,
    this.subtotal,
    this.couponCode,
    this.attachedPhotos,
    this.attachedAudio,
  });

  /// Create a copy with some fields updated
  OrderDetails copyWith({
    int? orderId,
    String? orderStatus,
    String? dateAdded,
    String? total,
    String? orderType,
    List<CartItem>? products,
    WashyAddress? pickupAddress,
    WashyAddress? deliveryAddress,
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
    return OrderDetails(
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

  /// Get pickup date time
  DateTime get pickupDateTime {
    return DateTime.fromMillisecondsSinceEpoch(pickupTimeSlotTimeStamp * 1000);
  }

  /// Get delivery date time
  DateTime? get deliveryDateTime {
    if (deliveryTimeSlotTimeStamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(deliveryTimeSlotTimeStamp! * 1000);
  }

  /// Get date added as DateTime
  DateTime? get dateAddedDateTime {
    try {
      return DateTime.parse(dateAdded);
    } catch (e) {
      return null;
    }
  }

  /// Get total as double
  double get totalPrice {
    try {
      return double.parse(total);
    } catch (e) {
      return 0.0;
    }
  }

  /// Get subtotal as double
  double get subtotalPrice {
    try {
      return double.parse(subtotal ?? '0');
    } catch (e) {
      return 0.0;
    }
  }

  /// Get delivery fee as double
  double get deliveryFeePrice {
    try {
      return double.parse(deliveryFee ?? '0');
    } catch (e) {
      return 0.0;
    }
  }

  /// Get discount as double
  double get discountPrice {
    try {
      return double.parse(discount ?? '0');
    } catch (e) {
      return 0.0;
    }
  }

  /// Get total items count
  int get totalItems {
    return products.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Check if order has attachments
  bool get hasAttachments {
    return (attachedPhotos?.isNotEmpty ?? false) || 
           (attachedAudio?.isNotEmpty ?? false);
  }

  /// Check if order has notes
  bool get hasNotes {
    return notes?.isNotEmpty ?? false;
  }

  /// Check if order has discount
  bool get hasDiscount {
    return discountPrice > 0;
  }

  @override
  List<Object?> get props => [
        orderId,
        orderStatus,
        dateAdded,
        total,
        orderType,
        products,
        pickupAddress,
        deliveryAddress,
        pickupTimeSlotTimeStamp,
        deliveryTimeSlotTimeStamp,
        paymentMethod,
        notes,
        isUnpaid,
        deliveryFee,
        discount,
        subtotal,
        couponCode,
        attachedPhotos,
        attachedAudio,
      ];
}
