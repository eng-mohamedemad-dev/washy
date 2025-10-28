import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/new_order_request.dart';
import '../../domain/entities/payment_method.dart';

/// Abstract base class for all order-related events
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all addresses for the user
class LoadAllAddressesEvent extends OrderEvent {
  final String token;

  const LoadAllAddressesEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

/// Event to submit a new order
class SubmitOrderEvent extends OrderEvent {
  final String token;
  final NewOrderRequest orderRequest;
  final String? orderTypeTag;

  const SubmitOrderEvent({
    required this.token,
    required this.orderRequest,
    this.orderTypeTag,
  });

  @override
  List<Object?> get props => [token, orderRequest, orderTypeTag];
}

/// Event to submit a skip selection order
class SubmitSkipSelectionOrderEvent extends OrderEvent {
  final String token;
  final NewOrderRequest orderRequest;

  const SubmitSkipSelectionOrderEvent({
    required this.token,
    required this.orderRequest,
  });

  @override
  List<Object?> get props => [token, orderRequest];
}

/// Event to load available time slots
class LoadAvailableTimeSlotsEvent extends OrderEvent {
  final String token;

  const LoadAvailableTimeSlotsEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

/// Event to load credit cards for the user
class LoadCreditCardsEvent extends OrderEvent {
  final String token;

  const LoadCreditCardsEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

/// Event to apply a redeem/coupon code
class ApplyRedeemCodeEvent extends OrderEvent {
  final String token;
  final String redeemCode;
  final String orderTypeString;
  final int? orderId;
  final List<Map<String, dynamic>>? products;

  const ApplyRedeemCodeEvent({
    required this.token,
    required this.redeemCode,
    required this.orderTypeString,
    this.orderId,
    this.products,
  });

  @override
  List<Object?> get props => [token, redeemCode, orderTypeString, orderId, products];
}

/// Event to confirm an order
class ConfirmOrderEvent extends OrderEvent {
  final String token;
  final int orderId;
  final PaymentMethod paymentMethod;

  const ConfirmOrderEvent({
    required this.token,
    required this.orderId,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [token, orderId, paymentMethod];
}

/// Event to upload a file (audio/photo)
class UploadFileEvent extends OrderEvent {
  final String token;
  final String type;
  final int editedBy;
  final File file;
  final int orderId;

  const UploadFileEvent({
    required this.token,
    required this.type,
    required this.editedBy,
    required this.file,
    required this.orderId,
  });

  @override
  List<Object?> get props => [token, type, editedBy, file, orderId];
}

/// Event to delete a file
class DeleteFileEvent extends OrderEvent {
  final String token;
  final int fileId;

  const DeleteFileEvent({
    required this.token,
    required this.fileId,
  });

  @override
  List<Object?> get props => [token, fileId];
}

/// Event to get order details
class GetOrderDetailsEvent extends OrderEvent {
  final String token;
  final int orderId;

  const GetOrderDetailsEvent({
    required this.token,
    required this.orderId,
  });

  @override
  List<Object?> get props => [token, orderId];
}

/// Event to edit an existing order
class EditOrderEvent extends OrderEvent {
  final String token;
  final NewOrderRequest orderRequest;
  final List<Map<String, dynamic>> products;
  final int orderId;

  const EditOrderEvent({
    required this.token,
    required this.orderRequest,
    required this.products,
    required this.orderId,
  });

  @override
  List<Object?> get props => [token, orderRequest, products, orderId];
}

/// Event for Moto payment method
class CallMotoPaymentMethodEvent extends OrderEvent {
  final String token;
  final int orderId;
  final int creditCardId;
  final String ipAddress;

  const CallMotoPaymentMethodEvent({
    required this.token,
    required this.orderId,
    required this.creditCardId,
    required this.ipAddress,
  });

  @override
  List<Object?> get props => [token, orderId, creditCardId, ipAddress];
}

/// Event for COD payment method
class CallCODPaymentMethodEvent extends OrderEvent {
  final String token;
  final int orderId;
  final PaymentMethod paymentMethod;

  const CallCODPaymentMethodEvent({
    required this.token,
    required this.orderId,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [token, orderId, paymentMethod];
}

/// Event to clear all order-related data
class ClearOrderDataEvent extends OrderEvent {
  const ClearOrderDataEvent();
}

/// Event to reset order state to initial
class ResetOrderStateEvent extends OrderEvent {
  const ResetOrderStateEvent();
}
