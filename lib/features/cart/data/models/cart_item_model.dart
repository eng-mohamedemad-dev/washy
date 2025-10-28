import 'dart:convert';
import '../../domain/entities/cart_item.dart';

/// CartItem data model for serialization
class CartItemModel extends CartItem {
  const CartItemModel({
    required super.productId,
    required super.categoryId,
    required super.subCategoryId,
    required super.name,
    required super.model,
    required super.price,
    required super.special,
    required super.image,
    required super.imageSearch,
    required super.currency,
    required super.description,
    required super.shortDescription,
    required super.quantity,
    required super.serviceName,
    required super.percentage,
    required super.deepLink,
    required super.stains,
    required super.deliveryWithin,
    required super.isSpecialProduct,
    required super.orderType,
  });

  /// Create from JSON (matching Java Product class)
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      subCategoryId: json['sub_cat_id'] ?? 0,
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      special: (json['special'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      imageSearch: json['image_search'] ?? '',
      currency: json['currency'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['short_desc'] ?? '',
      quantity: json['quantity'] ?? 1,
      serviceName: json['service'] ?? '',
      percentage: json['percentage'] ?? '',
      deepLink: json['deep_link'] ?? '',
      stains: json['stains'] ?? 0,
      deliveryWithin: json['delivery_withen'] ?? 0,
      isSpecialProduct: json['is_special_product'] ?? false,
      orderType: json['order_type'] ?? 'normal',
    );
  }

  /// Convert to JSON (matching Java Product class)
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'category_id': categoryId,
      'sub_cat_id': subCategoryId,
      'name': name,
      'model': model,
      'price': price,
      'special': special,
      'image': image,
      'image_search': imageSearch,
      'currency': currency,
      'description': description,
      'short_desc': shortDescription,
      'quantity': quantity,
      'service': serviceName,
      'percentage': percentage,
      'deep_link': deepLink,
      'stains': stains,
      'delivery_withen': deliveryWithin,
      'is_special_product': isSpecialProduct,
      'order_type': orderType,
    };
  }

  /// Create from entity
  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      productId: entity.productId,
      categoryId: entity.categoryId,
      subCategoryId: entity.subCategoryId,
      name: entity.name,
      model: entity.model,
      price: entity.price,
      special: entity.special,
      image: entity.image,
      imageSearch: entity.imageSearch,
      currency: entity.currency,
      description: entity.description,
      shortDescription: entity.shortDescription,
      quantity: entity.quantity,
      serviceName: entity.serviceName,
      percentage: entity.percentage,
      deepLink: entity.deepLink,
      stains: entity.stains,
      deliveryWithin: entity.deliveryWithin,
      isSpecialProduct: entity.isSpecialProduct,
      orderType: entity.orderType,
    );
  }

  /// Convert to JSON string
  String toJsonString() => json.encode(toJson());

  /// Create from JSON string
  static CartItemModel fromJsonString(String jsonString) =>
      CartItemModel.fromJson(json.decode(jsonString));

  /// Copy with updated quantity (override to return CartItemModel)
  @override
  CartItemModel copyWithQuantity(int newQuantity) {
    return CartItemModel(
      productId: productId,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      name: name,
      model: model,
      price: price,
      special: special,
      image: image,
      imageSearch: imageSearch,
      currency: currency,
      description: description,
      shortDescription: shortDescription,
      quantity: newQuantity,
      serviceName: serviceName,
      percentage: percentage,
      deepLink: deepLink,
      stains: stains,
      deliveryWithin: deliveryWithin,
      isSpecialProduct: isSpecialProduct,
      orderType: orderType,
    );
  }
}
