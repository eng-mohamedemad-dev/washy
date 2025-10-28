import 'dart:convert';
import '../../domain/entities/cart_category.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_item_model.dart';

/// CartCategory data model for serialization (matching Java CartModel)
class CartCategoryModel extends CartCategory {
  const CartCategoryModel({
    required super.type,
    required super.products,
    super.isAdded,
  });

  /// Create from JSON (matching Java CartModel)
  factory CartCategoryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> productsJson = json['products'] ?? [];
    final List<CartItemModel> products = productsJson
        .map((productJson) => CartItemModel.fromJson(productJson))
        .toList();

    return CartCategoryModel(
      type: json['type'] ?? '',
      products: products,
      isAdded: json['is_added'] ?? false,
    );
  }

  /// Convert to JSON (matching Java CartModel)
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'products': products
          .map((product) => CartItemModel.fromEntity(product).toJson())
          .toList(),
      'is_added': isAdded,
    };
  }

  /// Create from entity
  factory CartCategoryModel.fromEntity(CartCategory entity) {
    return CartCategoryModel(
      type: entity.type,
      products: entity.products,
      isAdded: entity.isAdded,
    );
  }

  /// Convert to JSON string
  String toJsonString() => json.encode(toJson());

  /// Create from JSON string
  static CartCategoryModel fromJsonString(String jsonString) =>
      CartCategoryModel.fromJson(json.decode(jsonString));

  /// Copy with updated values (override to return CartCategoryModel)
  @override
  CartCategoryModel copyWith({
    String? type,
    List<CartItem>? products,
    bool? isAdded,
  }) {
    return CartCategoryModel(
      type: type ?? this.type,
      products: products ?? this.products,
      isAdded: isAdded ?? this.isAdded,
    );
  }
}
