import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/order_summary.dart';
import '../../domain/entities/orders_type.dart';
import '../../domain/entities/load_more_object.dart';
import '../../domain/usecases/get_all_orders.dart';
import '../../domain/usecases/get_history_orders.dart';
import '../../domain/usecases/get_order_details.dart';
import '../../domain/usecases/cancel_order.dart';
import '../../domain/usecases/get_cached_orders.dart';
import 'orders_event.dart';
import 'orders_state.dart';

/// BLoC that manages all orders-related state and business logic
/// This matches the Java OrdersActivity pattern but with reactive state management
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetAllOrders getAllOrders;
  final GetHistoryOrders getHistoryOrders;
  final GetOrderDetails getOrderDetails;
  final CancelOrder cancelOrder;
  final GetCachedOrders getCachedOrders;

  // State management variables (matching Java OrdersActivity fields)
  List<OrderSummary> _allOrdersList = [];
  List<OrderSummary> _historyOrdersList = [];
  OrdersType _selectedOrderType = OrdersType.ALL_ORDERS;
  LoadMoreObject? _allOrdersLoadMore;
  LoadMoreObject? _historyOrdersLoadMore;

  OrdersBloc({
    required this.getAllOrders,
    required this.getHistoryOrders,
    required this.getOrderDetails,
    required this.cancelOrder,
    required this.getCachedOrders,
  }) : super(const OrdersInitial()) {
    on<LoadAllOrdersEvent>(_onLoadAllOrders);
    on<LoadHistoryOrdersEvent>(_onLoadHistoryOrders);
    on<LoadOrderDetailsEvent>(_onLoadOrderDetails);
    on<CancelOrderEvent>(_onCancelOrder);
    on<SwitchOrderTypeEvent>(_onSwitchOrderType);
    on<ToggleOrderExpansionEvent>(_onToggleOrderExpansion);
    on<LoadMoreOrdersEvent>(_onLoadMoreOrders);
    on<RefreshOrdersEvent>(_onRefreshOrders);
    on<ClearOrdersDataEvent>(_onClearOrdersData);
    on<ResetOrdersStateEvent>(_onResetOrdersState);
  }

  /// Handle loading all current orders
  Future<void> _onLoadAllOrders(
    LoadAllOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (event.isRefresh) {
      _resetAllOrdersData();
    }

    if (_allOrdersList.isEmpty) {
      emit(const OrdersLoading(message: 'Loading current orders...'));
    } else {
      emit(const OrdersLoading(message: 'Loading more orders...', isLoadingMore: true));
    }

    final result = await getAllOrders(GetAllOrdersParams(
      token: event.token,
      page: event.page,
    ));

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (orders) {
        _processAllOrdersResponse(orders, event.page);
        emit(_buildLoadedState());
      },
    );
  }

  /// Handle loading order history
  Future<void> _onLoadHistoryOrders(
    LoadHistoryOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (event.isRefresh) {
      _resetHistoryOrdersData();
    }

    if (_historyOrdersList.isEmpty) {
      emit(const OrdersLoading(message: 'Loading order history...'));
    } else {
      emit(const OrdersLoading(message: 'Loading more history...', isLoadingMore: true));
    }

    final result = await getHistoryOrders(GetHistoryOrdersParams(
      token: event.token,
      page: event.page,
    ));

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (orders) {
        _processHistoryOrdersResponse(orders, event.page);
        emit(_buildLoadedState());
      },
    );
  }

  /// Handle loading order details for expansion
  Future<void> _onLoadOrderDetails(
    LoadOrderDetailsEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading(message: 'Loading order details...'));

    final result = await getOrderDetails(GetOrderDetailsParams(
      token: event.token,
      orderId: event.orderId,
    ));

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (orderDetails) {
        emit(OrderDetailsLoaded(
          orderDetails: orderDetails,
          position: event.position,
        ));
        
        // Update the loaded state with expanded details
        emit(_buildLoadedState().copyWith(
          expandedOrderDetails: orderDetails,
          expandedPosition: event.position,
        ));
      },
    );
  }

  /// Handle cancelling an order
  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading(message: 'Cancelling order...'));

    final result = await cancelOrder(CancelOrderParams(
      token: event.token,
      orderId: event.orderId,
    ));

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (success) {
        if (success) {
          emit(OrderCancelled(orderId: event.orderId));
          
          // Refresh orders after cancellation
          _resetAllData();
          add(RefreshOrdersEvent(token: event.token));
        } else {
          emit(const OrdersError(message: 'Failed to cancel order'));
        }
      },
    );
  }

  /// Handle switching between order types (current/history)
  Future<void> _onSwitchOrderType(
    SwitchOrderTypeEvent event,
    Emitter<OrdersState> emit,
  ) async {
    _selectedOrderType = event.orderType;
    
    // Check if we have data for the selected type
    final currentOrders = _getCurrentOrdersList();
    
    if (currentOrders.isEmpty) {
      emit(OrdersEmpty(
        orderType: _selectedOrderType,
        message: _selectedOrderType == OrdersType.ALL_ORDERS 
            ? 'No current orders found' 
            : 'No order history found',
      ));
    } else {
      emit(_buildLoadedState());
    }
  }

  /// Handle toggling order expansion
  Future<void> _onToggleOrderExpansion(
    ToggleOrderExpansionEvent event,
    Emitter<OrdersState> emit,
  ) async {
    // Update the order's expansion state in the list
    _updateOrderExpansion(event.orderId, event.isExpanded);
    
    emit(_buildLoadedState().copyWith(
      expandedPosition: event.isExpanded ? event.position : null,
    ));
  }

  /// Handle loading more orders (pagination)
  Future<void> _onLoadMoreOrders(
    LoadMoreOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final loadMore = _getCurrentLoadMore();
    
    if (loadMore != null && loadMore.shouldFetchMore()) {
      if (_selectedOrderType == OrdersType.ALL_ORDERS) {
        add(LoadAllOrdersEvent(
          token: event.token,
          page: loadMore.getNextPage(),
        ));
      } else {
        add(LoadHistoryOrdersEvent(
          token: event.token,
          page: loadMore.getNextPage(),
        ));
      }
    }
  }

  /// Handle refreshing orders
  Future<void> _onRefreshOrders(
    RefreshOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    _resetAllData();
    
    // Load initial data for current type
    if (_selectedOrderType == OrdersType.ALL_ORDERS) {
      add(LoadAllOrdersEvent(token: event.token, isRefresh: true));
    } else {
      add(LoadHistoryOrdersEvent(token: event.token, isRefresh: true));
    }
  }

  /// Handle clearing all orders data
  Future<void> _onClearOrdersData(
    ClearOrdersDataEvent event,
    Emitter<OrdersState> emit,
  ) async {
    _resetAllData();
    emit(const OrdersDataCleared());
  }

  /// Handle resetting orders state to initial
  Future<void> _onResetOrdersState(
    ResetOrdersStateEvent event,
    Emitter<OrdersState> emit,
  ) async {
    _resetAllData();
    emit(const OrdersInitial());
  }

  /// Process all orders response
  void _processAllOrdersResponse(List<OrderSummary> orders, int page) {
    if (page == 1) {
      _allOrdersList = [];
    }
    
    _allOrdersList.addAll(orders);
    
    // Update load more object (simulating pagination data)
    _allOrdersLoadMore = (_allOrdersLoadMore ?? LoadMoreObject.initial())
        .copyWith(currentPage: page)
        .increasePage();
  }

  /// Process history orders response
  void _processHistoryOrdersResponse(List<OrderSummary> orders, int page) {
    if (page == 1) {
      _historyOrdersList = [];
    }
    
    _historyOrdersList.addAll(orders);
    
    // Update load more object (simulating pagination data)
    _historyOrdersLoadMore = (_historyOrdersLoadMore ?? LoadMoreObject.initial())
        .copyWith(currentPage: page)
        .increasePage();
  }

  /// Build loaded state with current data
  OrdersLoaded _buildLoadedState() {
    return OrdersLoaded(
      allOrders: _allOrdersList,
      historyOrders: _historyOrdersList,
      selectedOrderType: _selectedOrderType,
      allOrdersLoadMore: _allOrdersLoadMore,
      historyOrdersLoadMore: _historyOrdersLoadMore,
    );
  }

  /// Get current orders list based on selected type
  List<OrderSummary> _getCurrentOrdersList() {
    switch (_selectedOrderType) {
      case OrdersType.ALL_ORDERS:
        return _allOrdersList;
      case OrdersType.HISTORY_ORDERS:
        return _historyOrdersList;
    }
  }

  /// Get current load more object based on selected type
  LoadMoreObject? _getCurrentLoadMore() {
    switch (_selectedOrderType) {
      case OrdersType.ALL_ORDERS:
        return _allOrdersLoadMore;
      case OrdersType.HISTORY_ORDERS:
        return _historyOrdersLoadMore;
    }
  }

  /// Update order expansion state in the list
  void _updateOrderExpansion(int orderId, bool isExpanded) {
    final currentOrders = _getCurrentOrdersList();
    final index = currentOrders.indexWhere((order) => order.orderId == orderId);
    
    if (index != -1) {
      final updatedOrder = currentOrders[index].copyWith(isExpanded: isExpanded);
      currentOrders[index] = updatedOrder;
    }
  }

  /// Reset all orders data
  void _resetAllOrdersData() {
    _allOrdersList = [];
    _allOrdersLoadMore = null;
  }

  /// Reset history orders data
  void _resetHistoryOrdersData() {
    _historyOrdersList = [];
    _historyOrdersLoadMore = null;
  }

  /// Reset all data
  void _resetAllData() {
    _resetAllOrdersData();
    _resetHistoryOrdersData();
    _selectedOrderType = OrdersType.ALL_ORDERS;
  }

  /// Map failure objects to appropriate error states
  OrdersState _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return OrdersServerError(message: failure.message);
      case NetworkFailure:
        return const OrdersNetworkError();
      case CacheFailure:
        return OrdersCacheError(message: failure.message);
      default:
        return OrdersError(message: failure.message);
    }
  }
}

