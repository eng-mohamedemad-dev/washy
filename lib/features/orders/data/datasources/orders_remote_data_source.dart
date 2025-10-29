import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/response/all_orders_response.dart';
import '../models/response/order_details_response.dart';
import '../models/response/cancel_order_response.dart';

/// Abstract remote data source for orders API calls
/// Matches the WebServiceManager calls in Java OrdersActivity
abstract class OrdersRemoteDataSource {
  /// Get all current orders with pagination
  /// Matches WebServiceManager.callGetAllOrders
  Future<AllOrdersResponse> getAllOrders(String token, int page);

  /// Get order history with pagination  
  /// Matches WebServiceManager.getHistoryOrders
  Future<AllOrdersResponse> getHistoryOrders(String token, int page);

  /// Get detailed order information
  /// Matches WebServiceManager.callGetOrder
  Future<OrderDetailsResponse> getOrderDetails(String token, int orderId);

  /// Cancel an order
  /// Matches the cancel order API call
  Future<CancelOrderResponse> cancelOrder(String token, int orderId);
}

/// Implementation of OrdersRemoteDataSource
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final http.Client client;

  OrdersRemoteDataSourceImpl({required this.client});

  @override
  Future<AllOrdersResponse> getAllOrders(String token, int page) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}customer/order/get-all'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'token': token,
        'page': page.toString(),
      },
    );

    if (response.statusCode == 200) {
      return AllOrdersResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to get all orders: ${response.statusCode}');
    }
  }

  @override
  Future<AllOrdersResponse> getHistoryOrders(String token, int page) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}customer/order/get-history'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'token': token,
        'page': page.toString(),
      },
    );

    if (response.statusCode == 200) {
      return AllOrdersResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to get order history: ${response.statusCode}');
    }
  }

  @override
  Future<OrderDetailsResponse> getOrderDetails(String token, int orderId) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}customer/order/get'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'token': token,
        'order_id': orderId.toString(),
      },
    );

    if (response.statusCode == 200) {
      return OrderDetailsResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to get order details: ${response.statusCode}');
    }
  }

  @override
  Future<CancelOrderResponse> cancelOrder(String token, int orderId) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}customer/order/cancel-order'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'token': token,
        'order_id': orderId.toString(),
      },
    );

    if (response.statusCode == 200) {
      return CancelOrderResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to cancel order: ${response.statusCode}');
    }
  }
}

