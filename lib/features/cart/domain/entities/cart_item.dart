import 'package:equatable/equatable.dart';

/// CartItem entity representing a product in cart
class CartItem extends Equatable {
  final int productId;
  final int categoryId;
  final int subCategoryId;
  final String name;
  final String model;
  final double price;
  final double special; // Special/discount price
  final String image;
  final String imageSearch;
  final String currency;
  final String description;
  final String shortDescription;
  final int quantity;
  final String serviceName;
  final String percentage;
  final String deepLink;
  final int stains;
  final int deliveryWithin;
  final bool isSpecialProduct;
  final String orderType;

  const CartItem({
    required this.productId,
    required this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.model,
    required this.price,
    required this.special,
    required this.image,
    required this.imageSearch,
    required this.currency,
    required this.description,
    required this.shortDescription,
    required this.quantity,
    required this.serviceName,
    required this.percentage,
    required this.deepLink,
    required this.stains,
    required this.deliveryWithin,
    required this.isSpecialProduct,
    required this.orderType,
  });

  /// Get effective price (special price if available, otherwise regular price)
  double get effectivePrice => special > 0 ? special : price;

  /// Get total price for this item (price * quantity)
  double get totalPrice => effectivePrice * quantity;

  /// Check if this is a disinfection service
  bool get isDisinfectionService => 
      serviceName.toLowerCase().contains('disinfection') ||
      serviceName.toLowerCase().contains('x');

  /// Copy with updated quantity
  CartItem copyWithQuantity(int newQuantity) {
    return CartItem(
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

  @override
  List<Object?> get props => [
    productId,
    categoryId,
    subCategoryId,
    name,
    model,
    price,
    special,
    image,
    imageSearch,
    currency,
    description,
    shortDescription,
    quantity,
    serviceName,
    percentage,
    deepLink,
    stains,
    deliveryWithin,
    isSpecialProduct,
    orderType,
  ];
}
