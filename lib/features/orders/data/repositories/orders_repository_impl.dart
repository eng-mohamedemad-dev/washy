import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../../domain/entities/order_summary.dart';
import '../../domain/entities/order_details.dart';
import '../../domain/entities/orders_type.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';
import '../datasources/orders_local_data_source.dart';
import '../models/order_summary_model.dart';

/// Implementation of OrdersRepository that manages both local and remote data sources
/// This matches the API call pattern in Java OrdersActivity
class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final OrdersLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<OrderSummary>>> getAllOrders(String token, int page) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOrders = await remoteDataSource.getAllOrders(token, page);
        
        if (remoteOrders.data?.ordersList != null) {
          final orders = remoteOrders.data!.ordersList;
          
          // Cache the orders locally (only first page to avoid huge cache)
          if (page == 1) {
            await localDataSource.cacheOrders(orders, OrdersType.ALL_ORDERS);
          }
          
          return Right(orders);
        } else {
          return Left(ServerFailure(remoteOrders.message));
        }
      } on ServerException catch (e) {
        // If server fails, try to get cached orders
        return _getCachedOrders(OrdersType.ALL_ORDERS, e.message);
      } on Exception {
        return _getCachedOrders(OrdersType.ALL_ORDERS, 'Unknown server error');
      }
    } else {
      return _getCachedOrders(OrdersType.ALL_ORDERS, 'No internet connection');
    }
  }

  @override
  Future<Either<Failure, List<OrderSummary>>> getHistoryOrders(String token, int page) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOrders = await remoteDataSource.getHistoryOrders(token, page);
        
        if (remoteOrders.data?.ordersList != null) {
          final orders = remoteOrders.data!.ordersList;
          
          // Cache the orders locally (only first page to avoid huge cache)
          if (page == 1) {
            await localDataSource.cacheOrders(orders, OrdersType.HISTORY_ORDERS);
          }
          
          return Right(orders);
        } else {
          return Left(ServerFailure(remoteOrders.message));
        }
      } on ServerException catch (e) {
        // If server fails, try to get cached orders
        return _getCachedOrders(OrdersType.HISTORY_ORDERS, e.message);
      } on Exception {
        return _getCachedOrders(OrdersType.HISTORY_ORDERS, 'Unknown server error');
      }
    } else {
      return _getCachedOrders(OrdersType.HISTORY_ORDERS, 'No internet connection');
    }
  }

  @override
  Future<Either<Failure, OrderDetails>> getOrderDetails(String token, int orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOrderDetails = await remoteDataSource.getOrderDetails(token, orderId);
        
        if (remoteOrderDetails.data?.orderDetails != null) {
          final orderDetails = remoteOrderDetails.data!.orderDetails;
          
          // Cache the order details locally
          await localDataSource.cacheOrderDetails(orderDetails);
          
          return Right(orderDetails);
        } else {
          return Left(ServerFailure(remoteOrderDetails.message));
        }
      } on ServerException catch (e) {
        // If server fails, try to get cached order details
        return _getCachedOrderDetails(orderId, e.message);
      } on Exception {
        return _getCachedOrderDetails(orderId, 'Unknown server error');
      }
    } else {
      return _getCachedOrderDetails(orderId, 'No internet connection');
    }
  }

  @override
  Future<Either<Failure, bool>> cancelOrder(String token, int orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.cancelOrder(token, orderId);
        
        if (response.success && response.data?.cancelled == true) {
          // Clear cached orders since the order status has changed
          await _clearOrdersCacheAfterUpdate();
          return const Right(true);
        } else {
          return Left(ServerFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return Left(const ServerFailure('Failed to cancel order'));
      }
    } else {
      return Left(const NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<OrderSummary>>> getCachedOrders(OrdersType orderType) async {
    try {
      final localOrders = await localDataSource.getCachedOrders(orderType);
      return Right(localOrders);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> cacheOrders(List<OrderSummary> orders, OrdersType orderType) async {
    try {
      final orderModels = orders.map((order) => 
        order is OrderSummaryModel ? order : OrderSummaryModel.fromEntity(order)
      ).toList();
      
      await localDataSource.cacheOrders(orderModels, orderType);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearCachedOrders() async {
    try {
      await localDataSource.clearCachedOrders();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  /// Helper method to get cached orders when remote fails
  Future<Either<Failure, List<OrderSummary>>> _getCachedOrders(
    OrdersType orderType, 
    String errorMessage,
  ) async {
    try {
      final localOrders = await localDataSource.getCachedOrders(orderType);
      
      if (localOrders.isNotEmpty && await localDataSource.hasValidCache(orderType)) {
        return Right(localOrders);
      } else {
        return Left(CacheFailure(errorMessage));
      }
    } on CacheException {
      return Left(CacheFailure('Failed to load cached orders'));
    }
  }

  /// Helper method to get cached order details when remote fails
  Future<Either<Failure, OrderDetails>> _getCachedOrderDetails(
    int orderId, 
    String errorMessage,
  ) async {
    try {
      final localOrderDetails = await localDataSource.getCachedOrderDetails(orderId);
      
      if (localOrderDetails != null) {
        return Right(localOrderDetails);
      } else {
        return Left(CacheFailure(errorMessage));
      }
    } on CacheException {
      return Left(CacheFailure('Failed to load cached order details'));
    }
  }

  /// Clear orders cache when an order is updated/cancelled
  Future<void> _clearOrdersCacheAfterUpdate() async {
    try {
      await localDataSource.clearCachedOrders();
    } catch (e) {
      // Ignore cache clear errors as they don't affect the main operation
    }
  }
}
