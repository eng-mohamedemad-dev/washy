import 'package:equatable/equatable.dart';
import 'cart_category.dart';
import 'cart_item.dart';

/// CartSummary entity representing the complete cart state
class CartSummary extends Equatable {
  final List<CartCategory> categories;
  final bool isEmpty;

  const CartSummary({
    required this.categories,
    this.isEmpty = false,
  });

  /// Get all cart items across all categories
  List<CartItem> get allItems {
    return categories.expand((category) => category.products).toList();
  }

  /// Get total number of items in cart
  int get totalItemCount {
    return allItems.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Get subtotal price for all items
  double get subtotalPrice {
    return categories.fold(0.0, (sum, category) => sum + category.totalPrice);
  }

  /// Get currency (from first available item)
  String get currency {
    if (categories.isEmpty) return '';
    final firstCategory = categories.firstWhere(
      (cat) => cat.hasProducts,
      orElse: () => const CartCategory(type: '', products: []),
    );
    return firstCategory.currency;
  }

  /// Check if cart has any items
  bool get hasItems => !isEmpty && categories.any((cat) => cat.hasProducts);

  /// Get formatted item count text
  String getItemCountText() {
    final count = totalItemCount;
    return count == 1 ? '$count Item' : '$count Items';
  }

  /// Check if should navigate to disinfection flow
  bool get shouldNavigateToDisinfection {
    return allItems.any((item) => item.isDisinfectionService);
  }

  /// Get categories that have products
  List<CartCategory> get nonEmptyCategories {
    return categories.where((cat) => cat.hasProducts).toList();
  }

  /// Create empty cart summary
  factory CartSummary.empty() {
    return const CartSummary(
      categories: [],
      isEmpty: true,
    );
  }

  /// Copy with updated categories
  CartSummary copyWith({
    List<CartCategory>? categories,
    bool? isEmpty,
  }) {
    return CartSummary(
      categories: categories ?? this.categories,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }

  @override
  List<Object?> get props => [categories, isEmpty];
}
