import 'dart:convert';
import '../../domain/entities/cart_category.dart';
import '../../domain/entities/cart_summary.dart';
import 'cart_category_model.dart';

/// CartSummary data model for serialization
class CartSummaryModel extends CartSummary {
  const CartSummaryModel({
    required super.categories,
    super.isEmpty,
  });

  /// Create from JSON
  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> categoriesJson = json['categories'] ?? [];
    final List<CartCategoryModel> categories = categoriesJson
        .map((categoryJson) => CartCategoryModel.fromJson(categoryJson))
        .toList();

    return CartSummaryModel(
      categories: categories,
      isEmpty: json['is_empty'] ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'categories': categories
          .map((category) => CartCategoryModel.fromEntity(category).toJson())
          .toList(),
      'is_empty': isEmpty,
    };
  }

  /// Create from entity
  factory CartSummaryModel.fromEntity(CartSummary entity) {
    return CartSummaryModel(
      categories: entity.categories,
      isEmpty: entity.isEmpty,
    );
  }

  /// Create empty cart summary model
  factory CartSummaryModel.empty() {
    return const CartSummaryModel(
      categories: [],
      isEmpty: true,
    );
  }

  /// Convert to JSON string
  String toJsonString() => json.encode(toJson());

  /// Create from JSON string
  static CartSummaryModel fromJsonString(String jsonString) =>
      CartSummaryModel.fromJson(json.decode(jsonString));

  /// Copy with updated values (override to return CartSummaryModel)
  @override
  CartSummaryModel copyWith({
    List<CartCategory>? categories,
    bool? isEmpty,
  }) {
    return CartSummaryModel(
      categories: categories ?? this.categories,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}
