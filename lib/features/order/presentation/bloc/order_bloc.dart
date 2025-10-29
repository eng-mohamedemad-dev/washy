import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/order_type.dart';
import '../../domain/usecases/apply_redeem_code.dart';
import '../../domain/usecases/confirm_order.dart';
import '../../domain/usecases/get_all_addresses.dart';
import '../../domain/usecases/get_available_time_slots.dart';
import '../../domain/usecases/get_credit_cards.dart';
import '../../domain/usecases/submit_order.dart';
import 'order_event.dart';
import 'order_state.dart';

/// BLoC that manages all order-related state and business logic
/// This matches the Java activity pattern but with reactive state management
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetAllAddresses getAllAddresses;
  final SubmitOrder submitOrder;
  final GetAvailableTimeSlots getAvailableTimeSlots;
  final GetCreditCards getCreditCards;
  final ApplyRedeemCode applyRedeemCode;
  final ConfirmOrder confirmOrder;

  OrderBloc({
    required this.getAllAddresses,
    required this.submitOrder,
    required this.getAvailableTimeSlots,
    required this.getCreditCards,
    required this.applyRedeemCode,
    required this.confirmOrder,
  }) : super(const OrderInitial()) {
    on<LoadAllAddressesEvent>(_onLoadAllAddresses);
    on<SubmitOrderEvent>(_onSubmitOrder);
    on<SubmitSkipSelectionOrderEvent>(_onSubmitSkipSelectionOrder);
    on<LoadAvailableTimeSlotsEvent>(_onLoadAvailableTimeSlots);
    on<LoadCreditCardsEvent>(_onLoadCreditCards);
    on<ApplyRedeemCodeEvent>(_onApplyRedeemCode);
    on<ConfirmOrderEvent>(_onConfirmOrder);
    on<UploadFileEvent>(_onUploadFile);
    on<DeleteFileEvent>(_onDeleteFile);
    on<GetOrderDetailsEvent>(_onGetOrderDetails);
    on<EditOrderEvent>(_onEditOrder);
    on<CallMotoPaymentMethodEvent>(_onCallMotoPaymentMethod);
    on<CallCODPaymentMethodEvent>(_onCallCODPaymentMethod);
    on<ClearOrderDataEvent>(_onClearOrderData);
    on<ResetOrderStateEvent>(_onResetOrderState);
  }

  /// Handle loading all addresses for the user
  Future<void> _onLoadAllAddresses(
    LoadAllAddressesEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Loading addresses...'));

    final result = await getAllAddresses(NoParams());

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (addresses) => emit(AddressesLoaded(addresses: addresses)),
    );
  }

  /// Handle submitting a new order
  Future<void> _onSubmitOrder(
    SubmitOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Submitting order...'));

    final result = await submitOrder(SubmitOrderParams(
      orderRequest: event.orderRequest,
      orderType: OrderType.NORMAL,
      orderTypeTag: event.orderTypeTag,
    ));

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (response) => emit(OrderSubmitted(orderResponse: response)),
    );
  }

  /// Handle submitting a skip selection order
  Future<void> _onSubmitSkipSelectionOrder(
    SubmitSkipSelectionOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Submitting skip selection order...'));

    final result = await submitOrder(SubmitOrderParams(
      orderRequest: event.orderRequest,
      orderType: OrderType.SKIP_SELECTION,
      orderTypeTag: 'skip_selection',
    ));

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (response) => emit(SkipSelectionOrderSubmitted(orderResponse: response)),
    );
  }

  /// Handle loading available time slots
  Future<void> _onLoadAvailableTimeSlots(
    LoadAvailableTimeSlotsEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Loading available time slots...'));

    final result =
        await getAvailableTimeSlots(const GetAvailableTimeSlotsParams(
      dateSlotId: 0,
    ));

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (timeSlots) => emit(AvailableTimeSlotsLoaded(timeSlots: timeSlots)),
    );
  }

  /// Handle loading credit cards for the user
  Future<void> _onLoadCreditCards(
    LoadCreditCardsEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Loading credit cards...'));

    final result = await getCreditCards(NoParams());

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (creditCards) => emit(CreditCardsLoaded(creditCards: creditCards)),
    );
  }

  /// Handle applying a redeem/coupon code
  Future<void> _onApplyRedeemCode(
    ApplyRedeemCodeEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Applying redeem code...'));

    final result = await applyRedeemCode(ApplyRedeemCodeParams(
      redeemCode: event.redeemCode,
      orderType: event.orderTypeString,
      orderId: event.orderId,
      products: null,
    ));

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (redeemResult) => emit(RedeemCodeApplied(redeemResult: redeemResult)),
    );
  }

  /// Handle confirming an order
  Future<void> _onConfirmOrder(
    ConfirmOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Confirming order...'));

    final result = await confirmOrder(ConfirmOrderParams(
      orderId: event.orderId,
      paymentMethod: event.paymentMethod.toApiString(),
    ));

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (response) => emit(OrderConfirmed(confirmationResponse: response)),
    );
  }

  /// Handle file upload (audio/photo)
  Future<void> _onUploadFile(
    UploadFileEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Uploading file...'));

    // TODO: Implement file upload use case when ready
    emit(const OrderError(message: 'File upload not implemented yet'));
  }

  /// Handle file deletion
  Future<void> _onDeleteFile(
    DeleteFileEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Deleting file...'));

    // TODO: Implement file delete use case when ready
    emit(const OrderError(message: 'File deletion not implemented yet'));
  }

  /// Handle getting order details
  Future<void> _onGetOrderDetails(
    GetOrderDetailsEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Loading order details...'));

    // TODO: Implement get order details use case when ready
    emit(const OrderError(message: 'Get order details not implemented yet'));
  }

  /// Handle editing an existing order
  Future<void> _onEditOrder(
    EditOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Editing order...'));

    // TODO: Implement edit order use case when ready
    emit(const OrderError(message: 'Order editing not implemented yet'));
  }

  /// Handle Moto payment method
  Future<void> _onCallMotoPaymentMethod(
    CallMotoPaymentMethodEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Processing Moto payment...'));

    // TODO: Implement Moto payment use case when ready
    emit(const OrderError(message: 'Moto payment not implemented yet'));
  }

  /// Handle COD payment method
  Future<void> _onCallCODPaymentMethod(
    CallCODPaymentMethodEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Processing COD payment...'));

    // TODO: Implement COD payment use case when ready
    emit(const OrderError(message: 'COD payment not implemented yet'));
  }

  /// Handle clearing all order data
  Future<void> _onClearOrderData(
    ClearOrderDataEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading(message: 'Clearing order data...'));

    // TODO: Clear local cached data
    emit(const OrderDataCleared());
  }

  /// Handle resetting order state to initial
  Future<void> _onResetOrderState(
    ResetOrderStateEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderInitial());
  }

  /// Map failure objects to appropriate error states
  OrderState _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return OrderServerError(message: failure.message);
      case NetworkFailure:
        return const OrderNetworkError();
      case CacheFailure:
        return OrderCacheError(message: failure.message);
      default:
        return OrderError(message: failure.message);
    }
  }
}
