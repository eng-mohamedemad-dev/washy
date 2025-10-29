import 'package:equatable/equatable.dart';
import '../../domain/entities/orders_type.dart';

/// Abstract base class for all orders-related events
abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all current orders
class LoadAllOrdersEvent extends OrdersEvent {
  final String token;
  final int page;
  final bool isRefresh;

  const LoadAllOrdersEvent({
    required this.token,
    this.page = 1,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [token, page, isRefresh];
}

/// Event to load order history
class LoadHistoryOrdersEvent extends OrdersEvent {
  final String token;
  final int page;
  final bool isRefresh;

  const LoadHistoryOrdersEvent({
    required this.token,
    this.page = 1,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [token, page, isRefresh];
}

/// Event to load order details (for expansion)
class LoadOrderDetailsEvent extends OrdersEvent {
  final String token;
  final int orderId;
  final int position;

  const LoadOrderDetailsEvent({
    required this.token,
    required this.orderId,
    required this.position,
  });

  @override
  List<Object?> get props => [token, orderId, position];
}

/// Event to cancel an order
class CancelOrderEvent extends OrdersEvent {
  final String token;
  final int orderId;

  const CancelOrderEvent({
    required this.token,
    required this.orderId,
  });

  @override
  List<Object?> get props => [token, orderId];
}

/// Event to switch between order types (current/history)
class SwitchOrderTypeEvent extends OrdersEvent {
  final OrdersType orderType;

  const SwitchOrderTypeEvent({
    required this.orderType,
  });

  @override
  List<Object?> get props => [orderType];
}

/// Event to expand/collapse order details
class ToggleOrderExpansionEvent extends OrdersEvent {
  final int orderId;
  final int position;
  final bool isExpanded;

  const ToggleOrderExpansionEvent({
    required this.orderId,
    required this.position,
    required this.isExpanded,
  });

  @override
  List<Object?> get props => [orderId, position, isExpanded];
}

/// Event to load more orders (pagination)
class LoadMoreOrdersEvent extends OrdersEvent {
  final String token;

  const LoadMoreOrdersEvent({
    required this.token,
  });

  @override
  List<Object?> get props => [token];
}

/// Event to refresh current orders list
class RefreshOrdersEvent extends OrdersEvent {
  final String token;

  const RefreshOrdersEvent({
    required this.token,
  });

  @override
  List<Object?> get props => [token];
}

/// Event to clear all orders data
class ClearOrdersDataEvent extends OrdersEvent {
  const ClearOrdersDataEvent();
}

/// Event to reset orders state to initial
class ResetOrdersStateEvent extends OrdersEvent {
  const ResetOrdersStateEvent();
}



