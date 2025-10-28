import 'package:equatable/equatable.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/entities/redeem_result.dart';
import '../../domain/entities/washy_address.dart';

/// Abstract base class for all order-related states
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the order feature is first loaded
class OrderInitial extends OrderState {
  const OrderInitial();
}

/// Loading state for various order operations
class OrderLoading extends OrderState {
  final String message;

  const OrderLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// State when addresses are successfully loaded
class AddressesLoaded extends OrderState {
  final List<WashyAddress> addresses;

  const AddressesLoaded({required this.addresses});

  @override
  List<Object?> get props => [addresses];
}

/// State when order is successfully submitted
class OrderSubmitted extends OrderState {
  final dynamic orderResponse;
  final String message;

  const OrderSubmitted({
    required this.orderResponse,
    this.message = 'Order submitted successfully',
  });

  @override
  List<Object?> get props => [orderResponse, message];
}

/// State when skip selection order is successfully submitted
class SkipSelectionOrderSubmitted extends OrderState {
  final dynamic orderResponse;
  final String message;

  const SkipSelectionOrderSubmitted({
    required this.orderResponse,
    this.message = 'Skip selection order submitted successfully',
  });

  @override
  List<Object?> get props => [orderResponse, message];
}

/// State when available time slots are loaded
class AvailableTimeSlotsLoaded extends OrderState {
  final dynamic timeSlots; // TODO: Define proper type when API model is ready

  const AvailableTimeSlotsLoaded({required this.timeSlots});

  @override
  List<Object?> get props => [timeSlots];
}

/// State when credit cards are successfully loaded
class CreditCardsLoaded extends OrderState {
  final List<CreditCard> creditCards;

  const CreditCardsLoaded({required this.creditCards});

  @override
  List<Object?> get props => [creditCards];
}

/// State when redeem code is successfully applied
class RedeemCodeApplied extends OrderState {
  final RedeemResult redeemResult;

  const RedeemCodeApplied({required this.redeemResult});

  @override
  List<Object?> get props => [redeemResult];
}

/// State when order is successfully confirmed
class OrderConfirmed extends OrderState {
  final dynamic confirmationResponse;
  final String message;

  const OrderConfirmed({
    required this.confirmationResponse,
    this.message = 'Order confirmed successfully',
  });

  @override
  List<Object?> get props => [confirmationResponse, message];
}

/// State when file is successfully uploaded
class FileUploaded extends OrderState {
  final dynamic uploadResponse;
  final String message;

  const FileUploaded({
    required this.uploadResponse,
    this.message = 'File uploaded successfully',
  });

  @override
  List<Object?> get props => [uploadResponse, message];
}

/// State when file is successfully deleted
class FileDeleted extends OrderState {
  final dynamic deleteResponse;
  final String message;

  const FileDeleted({
    required this.deleteResponse,
    this.message = 'File deleted successfully',
  });

  @override
  List<Object?> get props => [deleteResponse, message];
}

/// State when order details are loaded
class OrderDetailsLoaded extends OrderState {
  final dynamic orderDetails; // TODO: Define proper type when API model is ready

  const OrderDetailsLoaded({required this.orderDetails});

  @override
  List<Object?> get props => [orderDetails];
}

/// State when order is successfully edited
class OrderEdited extends OrderState {
  final dynamic editResponse;
  final String message;

  const OrderEdited({
    required this.editResponse,
    this.message = 'Order edited successfully',
  });

  @override
  List<Object?> get props => [editResponse, message];
}

/// State when Moto payment is processed
class MotoPaymentProcessed extends OrderState {
  final dynamic paymentResponse;
  final String message;

  const MotoPaymentProcessed({
    required this.paymentResponse,
    this.message = 'Moto payment processed successfully',
  });

  @override
  List<Object?> get props => [paymentResponse, message];
}

/// State when COD payment is processed
class CODPaymentProcessed extends OrderState {
  final dynamic paymentResponse;
  final String message;

  const CODPaymentProcessed({
    required this.paymentResponse,
    this.message = 'COD payment processed successfully',
  });

  @override
  List<Object?> get props => [paymentResponse, message];
}

/// State when all order data is cleared
class OrderDataCleared extends OrderState {
  final String message;

  const OrderDataCleared({
    this.message = 'Order data cleared successfully',
  });

  @override
  List<Object?> get props => [message];
}

/// Generic error state for order operations
class OrderError extends OrderState {
  final String message;
  final String? errorType;

  const OrderError({
    required this.message,
    this.errorType,
  });

  @override
  List<Object?> get props => [message, errorType];
}

/// Network error state (when there's no internet connection)
class OrderNetworkError extends OrderState {
  final String message;

  const OrderNetworkError({
    this.message = 'No internet connection',
  });

  @override
  List<Object?> get props => [message];
}

/// Cache error state (when cached data is not available)
class OrderCacheError extends OrderState {
  final String message;

  const OrderCacheError({
    this.message = 'Failed to load cached data',
  });

  @override
  List<Object?> get props => [message];
}

/// Server error state (when server returns an error)
class OrderServerError extends OrderState {
  final String message;

  const OrderServerError({required this.message});

  @override
  List<Object?> get props => [message];
}
