import 'package:equatable/equatable.dart';
import '../../domain/entities/order_summary.dart';
import '../../domain/entities/order_details.dart';
import '../../domain/entities/orders_type.dart';
import '../../domain/entities/load_more_object.dart';

/// Abstract base class for all orders-related states
abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the orders feature is first loaded
class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

/// Loading state for various orders operations
class OrdersLoading extends OrdersState {
  final String message;
  final bool isLoadingMore;

  const OrdersLoading({
    this.message = 'Loading orders...',
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [message, isLoadingMore];
}

/// State when orders are successfully loaded
class OrdersLoaded extends OrdersState {
  final List<OrderSummary> allOrders;
  final List<OrderSummary> historyOrders;
  final OrdersType selectedOrderType;
  final LoadMoreObject? allOrdersLoadMore;
  final LoadMoreObject? historyOrdersLoadMore;
  final OrderDetails? expandedOrderDetails;
  final int? expandedPosition;

  const OrdersLoaded({
    required this.allOrders,
    required this.historyOrders,
    required this.selectedOrderType,
    this.allOrdersLoadMore,
    this.historyOrdersLoadMore,
    this.expandedOrderDetails,
    this.expandedPosition,
  });

  /// Get current orders list based on selected type
  List<OrderSummary> get currentOrders {
    switch (selectedOrderType) {
      case OrdersType.ALL_ORDERS:
        return allOrders;
      case OrdersType.HISTORY_ORDERS:
        return historyOrders;
    }
  }

  /// Get current load more object based on selected type
  LoadMoreObject? get currentLoadMore {
    switch (selectedOrderType) {
      case OrdersType.ALL_ORDERS:
        return allOrdersLoadMore;
      case OrdersType.HISTORY_ORDERS:
        return historyOrdersLoadMore;
    }
  }

  /// Check if current list is empty
  bool get isEmpty => currentOrders.isEmpty;

  /// Check if can load more
  bool get canLoadMore => currentLoadMore?.shouldFetchMore() ?? false;

  /// Check if is loading more
  bool get isLoadingMore => currentLoadMore?.isLoading ?? false;

  /// Get total items count for current type
  int get totalItems => currentLoadMore?.totalItems ?? 0;

  @override
  List<Object?> get props => [
        allOrders,
        historyOrders,
        selectedOrderType,
        allOrdersLoadMore,
        historyOrdersLoadMore,
        expandedOrderDetails,
        expandedPosition,
      ];

  /// Create a copy with updated fields
  OrdersLoaded copyWith({
    List<OrderSummary>? allOrders,
    List<OrderSummary>? historyOrders,
    OrdersType? selectedOrderType,
    LoadMoreObject? allOrdersLoadMore,
    LoadMoreObject? historyOrdersLoadMore,
    OrderDetails? expandedOrderDetails,
    int? expandedPosition,
  }) {
    return OrdersLoaded(
      allOrders: allOrders ?? this.allOrders,
      historyOrders: historyOrders ?? this.historyOrders,
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      allOrdersLoadMore: allOrdersLoadMore ?? this.allOrdersLoadMore,
      historyOrdersLoadMore: historyOrdersLoadMore ?? this.historyOrdersLoadMore,
      expandedOrderDetails: expandedOrderDetails ?? this.expandedOrderDetails,
      expandedPosition: expandedPosition ?? this.expandedPosition,
    );
  }
}

/// State when order details are successfully loaded (for expansion)
class OrderDetailsLoaded extends OrdersState {
  final OrderDetails orderDetails;
  final int position;
  final String message;

  const OrderDetailsLoaded({
    required this.orderDetails,
    required this.position,
    this.message = 'Order details loaded successfully',
  });

  @override
  List<Object?> get props => [orderDetails, position, message];
}

/// State when order is successfully cancelled
class OrderCancelled extends OrdersState {
  final int orderId;
  final String message;

  const OrderCancelled({
    required this.orderId,
    this.message = 'Order cancelled successfully',
  });

  @override
  List<Object?> get props => [orderId, message];
}

/// State when orders are refreshed
class OrdersRefreshed extends OrdersState {
  final String message;

  const OrdersRefreshed({
    this.message = 'Orders refreshed successfully',
  });

  @override
  List<Object?> get props => [message];
}

/// State when all orders data is cleared
class OrdersDataCleared extends OrdersState {
  final String message;

  const OrdersDataCleared({
    this.message = 'Orders data cleared successfully',
  });

  @override
  List<Object?> get props => [message];
}

/// Empty state when no orders are found
class OrdersEmpty extends OrdersState {
  final OrdersType orderType;
  final String message;
  final bool isUserLoggedIn;

  const OrdersEmpty({
    required this.orderType,
    this.message = 'No orders found',
    this.isUserLoggedIn = true,
  });

  @override
  List<Object?> get props => [orderType, message, isUserLoggedIn];
}

/// Generic error state for orders operations
class OrdersError extends OrdersState {
  final String message;
  final String? errorType;

  const OrdersError({
    required this.message,
    this.errorType,
  });

  @override
  List<Object?> get props => [message, errorType];
}

/// Network error state (when there's no internet connection)
class OrdersNetworkError extends OrdersState {
  final String message;

  const OrdersNetworkError({
    this.message = 'No internet connection',
  });

  @override
  List<Object?> get props => [message];
}

/// Cache error state (when cached data is not available)
class OrdersCacheError extends OrdersState {
  final String message;

  const OrdersCacheError({
    this.message = 'Failed to load cached orders',
  });

  @override
  List<Object?> get props => [message];
}

/// Server error state (when server returns an error)
class OrdersServerError extends OrdersState {
  final String message;

  const OrdersServerError({required this.message});

  @override
  List<Object?> get props => [message];
}



