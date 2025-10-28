import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/orders_type.dart';
import '../models/order_summary_model.dart';
import '../models/order_details_model.dart';

/// Abstract local data source for orders caching
abstract class OrdersLocalDataSource {
  /// Get cached orders
  Future<List<OrderSummaryModel>> getCachedOrders(OrdersType orderType);
  
  /// Cache orders
  Future<void> cacheOrders(List<OrderSummaryModel> orders, OrdersType orderType);
  
  /// Get cached order details
  Future<OrderDetailsModel?> getCachedOrderDetails(int orderId);
  
  /// Cache order details
  Future<void> cacheOrderDetails(OrderDetailsModel orderDetails);
  
  /// Clear all cached orders
  Future<void> clearCachedOrders();
  
  /// Check if cache is valid
  Future<bool> hasValidCache(OrdersType orderType);
}

/// Keys for SharedPreferences
const String ALL_ORDERS_KEY = 'ALL_ORDERS_KEY';
const String HISTORY_ORDERS_KEY = 'HISTORY_ORDERS_KEY';
const String ORDER_DETAILS_KEY = 'ORDER_DETAILS_KEY';
const String ORDERS_CACHE_TIMESTAMP_KEY = 'ORDERS_CACHE_TIMESTAMP_KEY';

/// Cache validity duration (30 minutes)
const int CACHE_VALIDITY_MINUTES = 30;

/// Implementation of OrdersLocalDataSource
class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  final SharedPreferences sharedPreferences;

  OrdersLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<OrderSummaryModel>> getCachedOrders(OrdersType orderType) async {
    try {
      final key = _getOrdersKey(orderType);
      final jsonString = sharedPreferences.getString(key);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((item) => OrderSummaryModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      throw const CacheException('Failed to load cached orders');
    }
  }

  @override
  Future<void> cacheOrders(List<OrderSummaryModel> orders, OrdersType orderType) async {
    try {
      final key = _getOrdersKey(orderType);
      final jsonList = orders.map((order) => order.toJson()).toList();
      final jsonString = json.encode(jsonList);
      
      await sharedPreferences.setString(key, jsonString);
      
      // Update cache timestamp
      await _updateCacheTimestamp(orderType);
    } catch (e) {
      throw const CacheException('Failed to cache orders');
    }
  }

  @override
  Future<OrderDetailsModel?> getCachedOrderDetails(int orderId) async {
    try {
      final key = '${ORDER_DETAILS_KEY}_$orderId';
      final jsonString = sharedPreferences.getString(key);
      
      if (jsonString != null) {
        return OrderDetailsModel.fromJson(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      throw const CacheException('Failed to load cached order details');
    }
  }

  @override
  Future<void> cacheOrderDetails(OrderDetailsModel orderDetails) async {
    try {
      final key = '${ORDER_DETAILS_KEY}_${orderDetails.orderId}';
      final jsonString = json.encode(orderDetails.toJson());
      
      await sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw const CacheException('Failed to cache order details');
    }
  }

  @override
  Future<void> clearCachedOrders() async {
    try {
      await Future.wait([
        sharedPreferences.remove(ALL_ORDERS_KEY),
        sharedPreferences.remove(HISTORY_ORDERS_KEY),
        sharedPreferences.remove('${ORDERS_CACHE_TIMESTAMP_KEY}_${OrdersType.ALL_ORDERS.name}'),
        sharedPreferences.remove('${ORDERS_CACHE_TIMESTAMP_KEY}_${OrdersType.HISTORY_ORDERS.name}'),
      ]);

      // Clear all order details cache
      final keys = sharedPreferences.getKeys();
      final orderDetailsKeys = keys.where((key) => key.startsWith(ORDER_DETAILS_KEY));
      
      await Future.wait(
        orderDetailsKeys.map((key) => sharedPreferences.remove(key)),
      );
    } catch (e) {
      throw const CacheException('Failed to clear orders cache');
    }
  }

  @override
  Future<bool> hasValidCache(OrdersType orderType) async {
    try {
      final timestampKey = '${ORDERS_CACHE_TIMESTAMP_KEY}_${orderType.name}';
      final timestamp = sharedPreferences.getInt(timestampKey);
      
      if (timestamp == null) return false;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime).inMinutes;
      
      return difference < CACHE_VALIDITY_MINUTES;
    } catch (e) {
      return false;
    }
  }

  /// Get the key for orders based on type
  String _getOrdersKey(OrdersType orderType) {
    switch (orderType) {
      case OrdersType.ALL_ORDERS:
        return ALL_ORDERS_KEY;
      case OrdersType.HISTORY_ORDERS:
        return HISTORY_ORDERS_KEY;
    }
  }

  /// Update cache timestamp for specific order type
  Future<void> _updateCacheTimestamp(OrdersType orderType) async {
    final timestampKey = '${ORDERS_CACHE_TIMESTAMP_KEY}_${orderType.name}';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await sharedPreferences.setInt(timestampKey, timestamp);
  }
}
