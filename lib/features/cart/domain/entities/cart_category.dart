import 'package:equatable/equatable.dart';
import 'cart_item.dart';

/// CartCategory entity representing a category of products in cart
/// Matches CartModel from Java project
class CartCategory extends Equatable {
  final String type;
  final List<CartItem> products;
  final bool isAdded;

  const CartCategory({
    required this.type,
    required this.products,
    this.isAdded = false,
  });

  /// Get total price for all products in this category
  double get totalPrice {
    return products.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Get total quantity for all products in this category
  int get totalQuantity {
    return products.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Get display name for category type
  String get displayName {
    switch (type.toLowerCase()) {
      case 'normal':
        return 'Normal Products';
      case 'furniture':
        return 'Furniture';
      case 'housekeeping':
        return 'Housekeeping';
      case 'car_cleaning':
        return 'Car Cleaning';
      case 'disinfection':
        return 'Disinfection';
      default:
        return type;
    }
  }

  /// Check if category has any products
  bool get hasProducts => products.isNotEmpty;

  /// Get currency from first product (all should have same currency)
  String get currency {
    if (products.isEmpty) return '';
    return products.first.currency;
  }

  /// Copy with updated products list
  CartCategory copyWith({
    String? type,
    List<CartItem>? products,
    bool? isAdded,
  }) {
    return CartCategory(
      type: type ?? this.type,
      products: products ?? this.products,
      isAdded: isAdded ?? this.isAdded,
    );
  }

  @override
  List<Object?> get props => [type, products, isAdded];
}
