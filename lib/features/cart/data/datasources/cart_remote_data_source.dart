import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/cart_item_model.dart';
import '../models/cart_summary_model.dart';

/// Remote data source for cart operations (matching Java WebServiceManager cart APIs)
abstract class CartRemoteDataSource {
  Future<void> syncCartWithServer(String token, CartSummaryModel cartSummary);
  Future<void> addToCartOnServer(String token, CartItemModel item);
  Future<void> removeFromCartOnServer(String token, int productId);
}

/// Implementation of CartRemoteDataSource
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final http.Client client;

  CartRemoteDataSourceImpl({required this.client});

  @override
  Future<void> syncCartWithServer(String token, CartSummaryModel cartSummary) async {
    try {
      // Convert cart items to JSON array format expected by server
      final List<Map<String, dynamic>> cartItems = cartSummary.allItems
          .map((item) => CartItemModel.fromEntity(item).toJson())
          .toList();

      final response = await client.post(
        Uri.parse('${AppConstants.serverUrl}customer/cart/sync'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': token,
          'cart': jsonEncode(cartItems),
        },
      );

      if (response.statusCode != 200) {
        throw const ServerException('Failed to sync cart with server');
      }

      final responseData = jsonDecode(response.body);
      if (responseData['status'] != 'success') {
        throw ServerException(
          responseData['message'] ?? 'Failed to sync cart with server',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to sync cart with server');
    }
  }

  @override
  Future<void> addToCartOnServer(String token, CartItemModel item) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.serverUrl}customer/cart/add'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': token,
          'id': item.productId.toString(),
          'qty': item.quantity.toString(),
          'order_type': item.orderType,
        },
      );

      if (response.statusCode != 200) {
        throw const ServerException('Failed to add item to cart on server');
      }

      final responseData = jsonDecode(response.body);
      if (responseData['status'] != 'success') {
        throw ServerException(
          responseData['message'] ?? 'Failed to add item to cart on server',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to add item to cart on server');
    }
  }

  @override
  Future<void> removeFromCartOnServer(String token, int productId) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.serverUrl}customer/cart/delete'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': token,
          'id': productId.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw const ServerException('Failed to remove item from cart on server');
      }

      final responseData = jsonDecode(response.body);
      if (responseData['status'] != 'success') {
        throw ServerException(
          responseData['message'] ?? 'Failed to remove item from cart on server',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to remove item from cart on server');
    }
  }
}
