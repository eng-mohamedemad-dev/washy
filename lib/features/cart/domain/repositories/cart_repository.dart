import 'package:dartz/dartz.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import '../entities/cart_item.dart';
import '../entities/cart_summary.dart';

/// Cart repository interface following Clean Architecture
abstract class CartRepository {
  /// Get current cart summary with all categories and items
  Future<Either<Failure, CartSummary>> getCartSummary();

  /// Add item to cart
  Future<Either<Failure, void>> addItemToCart(CartItem item);

  /// Update item quantity in cart
  Future<Either<Failure, void>> updateItemQuantity(int productId, int newQuantity);

  /// Remove item from cart
  Future<Either<Failure, void>> removeItemFromCart(int productId);

  /// Clear entire cart
  Future<Either<Failure, void>> clearCart();

  /// Clear cart by order type (normal, furniture, etc.)
  Future<Either<Failure, void>> clearCartByType(String orderType);

  /// Sync cart with server (if user logged in)
  Future<Either<Failure, void>> syncCartWithServer();

  /// Get cart total price for specific order type
  Future<Either<Failure, double>> getCartTotalForType(String orderType);

  /// Check if product exists in cart
  Future<Either<Failure, bool>> isProductInCart(int productId);

  /// Get cart item count
  Future<Either<Failure, int>> getCartItemCount();

  /// Save cart locally
  Future<Either<Failure, void>> saveCartLocally(CartSummary cartSummary);

  /// Load cart from local storage
  Future<Either<Failure, CartSummary>> loadCartFromLocal();
}
