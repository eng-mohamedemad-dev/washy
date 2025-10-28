import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/cart_item_model.dart';
import '../models/cart_summary_model.dart';

/// Local data source for cart operations (matching Java CartManager persistence)
abstract class CartLocalDataSource {
  Future<CartSummaryModel> getCartSummary();
  Future<void> saveCartSummary(CartSummaryModel cartSummary);
  Future<void> addItem(CartItemModel item);
  Future<void> updateItemQuantity(int productId, int newQuantity);
  Future<void> removeItem(int productId);
  Future<void> clearCart();
  Future<void> clearCartByType(String orderType);
  Future<bool> isProductInCart(int productId);
  Future<int> getCartItemCount();
  Future<double> getCartTotalForType(String orderType);
}

/// Keys for SharedPreferences (matching Java CartManager)
const String CART_PRODUCTS_KEY = 'CART_PRODUCTS_KEY';
const String CART_PREFERENCES_KEY = 'Cart_PREFERENCES_KEY';

/// Implementation of CartLocalDataSource
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<CartSummaryModel> getCartSummary() async {
    try {
      final jsonString = sharedPreferences.getString(CART_PRODUCTS_KEY);
      if (jsonString != null) {
        final Map<String, dynamic> json = jsonDecode(jsonString);
        return CartSummaryModel.fromJson(json);
      }
      return CartSummaryModel.empty();
    } catch (e) {
      throw const CacheException('Failed to load cart from cache');
    }
  }

  @override
  Future<void> saveCartSummary(CartSummaryModel cartSummary) async {
    try {
      final jsonString = jsonEncode(cartSummary.toJson());
      await sharedPreferences.setString(CART_PRODUCTS_KEY, jsonString);
    } catch (e) {
      throw const CacheException('Failed to save cart to cache');
    }
  }

  @override
  Future<void> addItem(CartItemModel item) async {
    final cartSummary = await getCartSummary();
    final updatedCategories = List<CartCategoryModel>.from(
      cartSummary.categories.map((cat) => CartCategoryModel.fromEntity(cat)),
    );

    // Find or create category for this item's order type
    final categoryIndex = updatedCategories.indexWhere(
      (cat) => cat.type.toLowerCase() == item.orderType.toLowerCase(),
    );

    if (categoryIndex >= 0) {
      // Category exists, check if product already exists
      final category = updatedCategories[categoryIndex];
      final productIndex = category.products.indexWhere(
        (product) => product.productId == item.productId,
      );

      if (productIndex >= 0) {
        // Product exists, update quantity
        final existingItem = category.products[productIndex];
        final updatedProduct = existingItem.copyWithQuantity(
          existingItem.quantity + item.quantity,
        );
        final updatedProducts = List<CartItemModel>.from(category.products);
        updatedProducts[productIndex] = updatedProduct;
        updatedCategories[categoryIndex] = category.copyWith(
          products: updatedProducts,
        );
      } else {
        // Product doesn't exist, add it
        final updatedProducts = List<CartItemModel>.from(category.products)
          ..add(item);
        updatedCategories[categoryIndex] = category.copyWith(
          products: updatedProducts,
        );
      }
    } else {
      // Category doesn't exist, create new one
      final newCategory = CartCategoryModel(
        type: item.orderType,
        products: [item],
        isAdded: false,
      );
      updatedCategories.add(newCategory);
    }

    final updatedCart = cartSummary.copyWith(
      categories: updatedCategories,
      isEmpty: false,
    );

    await saveCartSummary(CartSummaryModel.fromEntity(updatedCart));
  }

  @override
  Future<void> updateItemQuantity(int productId, int newQuantity) async {
    final cartSummary = await getCartSummary();
    final updatedCategories = <CartCategoryModel>[];

    for (final category in cartSummary.categories) {
      final categoryModel = CartCategoryModel.fromEntity(category);
      final productIndex = categoryModel.products.indexWhere(
        (product) => product.productId == productId,
      );

      if (productIndex >= 0) {
        final updatedProducts = List<CartItemModel>.from(categoryModel.products);
        
        if (newQuantity <= 0) {
          // Remove product if quantity is 0 or less
          updatedProducts.removeAt(productIndex);
        } else {
          // Update quantity
          final existingItem = updatedProducts[productIndex];
          updatedProducts[productIndex] = existingItem.copyWithQuantity(newQuantity);
        }

        // Only add category if it still has products
        if (updatedProducts.isNotEmpty) {
          updatedCategories.add(categoryModel.copyWith(
            products: updatedProducts,
          ));
        }
      } else {
        // Category doesn't contain the product, keep as is
        if (categoryModel.products.isNotEmpty) {
          updatedCategories.add(categoryModel);
        }
      }
    }

    final updatedCart = cartSummary.copyWith(
      categories: updatedCategories,
      isEmpty: updatedCategories.isEmpty,
    );

    await saveCartSummary(CartSummaryModel.fromEntity(updatedCart));
  }

  @override
  Future<void> removeItem(int productId) async {
    await updateItemQuantity(productId, 0);
  }

  @override
  Future<void> clearCart() async {
    await saveCartSummary(CartSummaryModel.empty());
  }

  @override
  Future<void> clearCartByType(String orderType) async {
    final cartSummary = await getCartSummary();
    final updatedCategories = cartSummary.categories
        .where((cat) => cat.type.toLowerCase() != orderType.toLowerCase())
        .map((cat) => CartCategoryModel.fromEntity(cat))
        .toList();

    final updatedCart = cartSummary.copyWith(
      categories: updatedCategories,
      isEmpty: updatedCategories.isEmpty,
    );

    await saveCartSummary(CartSummaryModel.fromEntity(updatedCart));
  }

  @override
  Future<bool> isProductInCart(int productId) async {
    final cartSummary = await getCartSummary();
    return cartSummary.allItems.any((item) => item.productId == productId);
  }

  @override
  Future<int> getCartItemCount() async {
    final cartSummary = await getCartSummary();
    return cartSummary.totalItemCount;
  }

  @override
  Future<double> getCartTotalForType(String orderType) async {
    final cartSummary = await getCartSummary();
    final matchingCategory = cartSummary.categories.firstWhere(
      (cat) => cat.type.toLowerCase() == orderType.toLowerCase(),
      orElse: () => const CartCategoryModel(type: '', products: []),
    );
    return matchingCategory.totalPrice;
  }
}
