import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_summary.dart';
import '../entities/order_details.dart';
import '../entities/orders_type.dart';

/// Abstract repository for orders operations
/// Matches the API calls in Java OrdersActivity
abstract class OrdersRepository {
  /// Get all current orders with pagination
  /// Matches WebServiceManager.callGetAllOrders
  Future<Either<Failure, List<OrderSummary>>> getAllOrders(String token, int page);

  /// Get order history with pagination
  /// Matches WebServiceManager.getHistoryOrders
  Future<Either<Failure, List<OrderSummary>>> getHistoryOrders(String token, int page);

  /// Get detailed order information
  /// Matches WebServiceManager.callGetOrder
  Future<Either<Failure, OrderDetails>> getOrderDetails(String token, int orderId);

  /// Cancel an order
  /// Matches the cancel order functionality
  Future<Either<Failure, bool>> cancelOrder(String token, int orderId);

  /// Get cached orders for offline support
  Future<Either<Failure, List<OrderSummary>>> getCachedOrders(OrdersType orderType);

  /// Cache orders locally
  Future<Either<Failure, void>> cacheOrders(List<OrderSummary> orders, OrdersType orderType);

  /// Clear all cached orders
  Future<Either<Failure, void>> clearCachedOrders();
}
