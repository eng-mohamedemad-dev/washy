import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/theme/app_colors.dart';
import 'package:wash_flutter/core/widgets/loading_widget.dart';
import 'package:wash_flutter/injection_container.dart' as di;
import '../../domain/entities/orders_type.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';
import '../widgets/orders_app_bar.dart';
import '../widgets/orders_tabs.dart';
import '../widgets/orders_list.dart';
import '../widgets/orders_empty_view.dart';
import '../widgets/orders_error_view.dart';

/// Orders Page that matches OrdersActivity functionality from Java
/// Displays current orders and order history with pagination and detailed views
class OrdersPage extends StatefulWidget {
  final bool isFromThankYouPage;

  const OrdersPage({
    super.key,
    this.isFromThankYouPage = false,
  });

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // Current selected order type (matching Java selectedOrderType)
  OrdersType selectedOrderType = OrdersType.ALL_ORDERS;

  @override
  void initState() {
    super.initState();
    _initializeOrders();
  }

  /// Initialize orders based on user login status
  void _initializeOrders() {
    // TODO: Check if user is logged in using SessionStateManager equivalent
    const isLoggedIn = true; // For now, assume user is logged in

    if (isLoggedIn) {
      // Load initial orders
      context.read<OrdersBloc>().add(
            const LoadAllOrdersEvent(
                token: 'user_token'), // TODO: Get actual token
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: OrdersAppBar(
        title: 'طلباتي',
        onBackPressed: _handleBackPressed,
      ),
      body: BlocConsumer<OrdersBloc, OrdersState>(
        listener: _handleBlocStateChanges,
        builder: (context, state) {
          return Column(
            children: [
              // Orders tabs (Current Orders / Order History)
              OrdersTabs(
                selectedOrderType: selectedOrderType,
                onTabChanged: _handleTabChanged,
              ),

              // Main content based on state
              Expanded(
                child: _buildMainContent(state),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Handle BLoC state changes
  void _handleBlocStateChanges(BuildContext context, OrdersState state) {
    if (state is OrderDetailsLoaded) {
      // Order details loaded for expansion - no action needed as it's handled in the list
    } else if (state is OrderCancelled) {
      _showSuccessMessage('تم إلغاء الطلب بنجاح');
    } else if (state is OrdersError) {
      _showErrorMessage(state.message);
    }
  }

  /// Build main content based on current state
  Widget _buildMainContent(OrdersState state) {
    if (state is OrdersInitial) {
      return const LoadingWidget();
    } else if (state is OrdersLoading && !state.isLoadingMore) {
      return const LoadingWidget();
    } else if (state is OrdersLoaded) {
      if (state.isEmpty) {
        return OrdersEmptyView(
          orderType: selectedOrderType,
          isUserLoggedIn: true, // TODO: Get actual login status
          onBrowseItemsPressed: _handleBrowseItemsPressed,
          onLoginPressed: _handleLoginPressed,
        );
      } else {
        return OrdersList(
          orders: state.currentOrders,
          orderType: selectedOrderType,
          isLoadingMore: state.isLoadingMore,
          canLoadMore: state.canLoadMore,
          expandedOrderDetails: state.expandedOrderDetails,
          expandedPosition: state.expandedPosition,
          onOrderExpanded: _handleOrderExpanded,
          onOrderCancelled: _handleOrderCancelled,
          onLoadMore: _handleLoadMore,
        );
      }
    } else if (state is OrdersEmpty) {
      return OrdersEmptyView(
        orderType: state.orderType,
        isUserLoggedIn: state.isUserLoggedIn,
        onBrowseItemsPressed: _handleBrowseItemsPressed,
        onLoginPressed: _handleLoginPressed,
      );
    } else if (state is OrdersError ||
        state is OrdersNetworkError ||
        state is OrdersCacheError ||
        state is OrdersServerError) {
      return OrdersErrorView(
        message: state is OrdersError
            ? state.message
            : state is OrdersNetworkError
                ? state.message
                : state is OrdersCacheError
                    ? state.message
                    : (state as OrdersServerError).message,
        onRetryPressed: _handleRetry,
      );
    }

    return const LoadingWidget();
  }

  /// Handle tab change between current orders and history
  void _handleTabChanged(OrdersType orderType) {
    setState(() {
      selectedOrderType = orderType;
    });

    context.read<OrdersBloc>().add(
          SwitchOrderTypeEvent(orderType: orderType),
        );

    // Load data for the selected tab if not already loaded
    if (orderType == OrdersType.HISTORY_ORDERS) {
      context.read<OrdersBloc>().add(
            const LoadHistoryOrdersEvent(
                token: 'user_token'), // TODO: Get actual token
          );
    }
  }

  /// Handle order expansion (matching Java onExpandImageViewClicked)
  void _handleOrderExpanded(int orderId, int position) {
    context.read<OrdersBloc>().add(
          LoadOrderDetailsEvent(
            token: 'user_token', // TODO: Get actual token
            orderId: orderId,
            position: position,
          ),
        );
  }

  /// Handle order cancellation (matching Java onCancelOrderClicked)
  void _handleOrderCancelled(int orderId) {
    _showCancelOrderDialog(orderId);
  }

  /// Handle load more orders (matching Java onLoadMore)
  void _handleLoadMore() {
    context.read<OrdersBloc>().add(
          const LoadMoreOrdersEvent(
              token: 'user_token'), // TODO: Get actual token
        );
  }

  /// Handle browse items button press
  void _handleBrowseItemsPressed() {
    Navigator.of(context).pop(); // Return to previous page (like Java finish())
  }

  /// Handle login button press
  void _handleLoginPressed() {
    // TODO: Navigate to login page
    Navigator.pushNamed(context, '/login');
  }

  /// Handle retry after error
  void _handleRetry() {
    if (selectedOrderType == OrdersType.ALL_ORDERS) {
      context.read<OrdersBloc>().add(
            const LoadAllOrdersEvent(token: 'user_token', isRefresh: true),
          );
    } else {
      context.read<OrdersBloc>().add(
            const LoadHistoryOrdersEvent(token: 'user_token', isRefresh: true),
          );
    }
  }

  /// Handle back button press (matching Java goBackToPreviousPage)
  void _handleBackPressed() {
    if (widget.isFromThankYouPage) {
      // Navigate back to landing page (matching Java stack navigation)
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  /// Show cancel order dialog (matching Java showCancelOrderDialog)
  void _showCancelOrderDialog(int orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'إلغاء الطلب',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                color: AppColors.grey,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<OrdersBloc>().add(
                    CancelOrderEvent(
                      token: 'user_token', // TODO: Get actual token
                      orderId: orderId,
                    ),
                  );
            },
            child: const Text(
              'تأكيد',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show success message
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: AppColors.washyGreen,
      ),
    );
  }

  /// Show error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

/// Wrapper widget to provide OrdersBloc
class OrdersPageWrapper extends StatelessWidget {
  final bool isFromThankYouPage;

  const OrdersPageWrapper({
    super.key,
    this.isFromThankYouPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<OrdersBloc>(),
      child: OrdersPage(
        isFromThankYouPage: isFromThankYouPage,
      ),
    );
  }
}

