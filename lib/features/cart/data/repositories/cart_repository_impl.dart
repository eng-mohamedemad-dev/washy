import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_summary.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_item_model.dart';
import '../models/cart_summary_model.dart';

/// Implementation of CartRepository (matching Java CartManager functionality)
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  final CartRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CartSummary>> getCartSummary() async {
    try {
      final cartSummary = await localDataSource.getCartSummary();
      return Right(cartSummary);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get cart summary'));
    }
  }

  @override
  Future<Either<Failure, void>> addItemToCart(CartItem item) async {
    try {
      final itemModel = CartItemModel.fromEntity(item);
      await localDataSource.addItem(itemModel);

      // Sync with server if connected and logged in
      // Note: User login check should be done at the presentation layer
      // For now, we'll skip server sync in this method
      // In a real implementation, you'd get user token and sync if available

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to add item to cart'));
    }
  }

  @override
  Future<Either<Failure, void>> updateItemQuantity(int productId, int newQuantity) async {
    try {
      await localDataSource.updateItemQuantity(productId, newQuantity);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to update item quantity'));
    }
  }

  @override
  Future<Either<Failure, void>> removeItemFromCart(int productId) async {
    try {
      await localDataSource.removeItem(productId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to remove item from cart'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to clear cart'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCartByType(String orderType) async {
    try {
      await localDataSource.clearCartByType(orderType);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to clear cart by type'));
    }
  }

  @override
  Future<Either<Failure, void>> syncCartWithServer() async {
    if (await networkInfo.isConnected) {
      try {
        final cartSummary = await localDataSource.getCartSummary();
        
        // Note: In real implementation, get user token from auth repository
        // For now, we'll return success without actual server sync
        // await remoteDataSource.syncCartWithServer(userToken, cartSummary);
        
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to sync cart with server'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, double>> getCartTotalForType(String orderType) async {
    try {
      final total = await localDataSource.getCartTotalForType(orderType);
      return Right(total);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get cart total for type'));
    }
  }

  @override
  Future<Either<Failure, bool>> isProductInCart(int productId) async {
    try {
      final isInCart = await localDataSource.isProductInCart(productId);
      return Right(isInCart);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to check if product is in cart'));
    }
  }

  @override
  Future<Either<Failure, int>> getCartItemCount() async {
    try {
      final count = await localDataSource.getCartItemCount();
      return Right(count);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get cart item count'));
    }
  }

  @override
  Future<Either<Failure, void>> saveCartLocally(CartSummary cartSummary) async {
    try {
      final cartSummaryModel = CartSummaryModel.fromEntity(cartSummary);
      await localDataSource.saveCartSummary(cartSummaryModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to save cart locally'));
    }
  }

  @override
  Future<Either<Failure, CartSummary>> loadCartFromLocal() async {
    try {
      final cartSummary = await localDataSource.getCartSummary();
      return Right(cartSummary);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to load cart from local storage'));
    }
  }
}
