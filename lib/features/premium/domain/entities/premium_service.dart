import 'package:equatable/equatable.dart';

/// Premium Service entity - represents a premium washing service
class PremiumService extends Equatable {
  final int id;
  final String title;
  final String subtitle;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> features;
  final String estimatedTime;

  const PremiumService({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.features,
    required this.estimatedTime,
  });

  /// Calculate discount percentage if original price exists
  int? get discountPercentage {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice! * 100).round();
    }
    return null;
  }

  /// Check if service has discount
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  /// Get savings amount
  double get savings => (originalPrice ?? price) - price;

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    description,
    price,
    originalPrice,
    imageUrl,
    features,
    estimatedTime,
  ];

  /// Copy with updated values
  PremiumService copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    List<String>? features,
    String? estimatedTime,
  }) {
    return PremiumService(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      features: features ?? this.features,
      estimatedTime: estimatedTime ?? this.estimatedTime,
    );
  }
}
