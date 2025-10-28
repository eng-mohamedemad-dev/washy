import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/cart_item.dart';

/// Cart Product Item Widget - matching individual product in ProductRecyclerView
class CartProductItem extends StatelessWidget {
  final CartItem product;
  final bool isEditMode;
  final Function(int newQuantity) onQuantityChanged;
  final VoidCallback onRemove;

  const CartProductItem({
    super.key,
    required this.product,
    required this.isEditMode,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey3, width: 1),
      ),
      child: Row(
        children: [
          // Product image (circular as per Java setShowCircularImages(true))
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.colorBackground,
              border: Border.all(color: AppColors.grey3, width: 1),
            ),
            child: ClipOval(
              child: product.image.isNotEmpty
                  ? Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
            ),
          ),

          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  product.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.colorTitleBlack,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Product description (if available)
                if (product.shortDescription.isNotEmpty)
                  Text(
                    product.shortDescription,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey2,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 8),

                // Price and quantity row
                Row(
                  children: [
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.special > 0) ...[
                          // Original price (crossed out)
                          Text(
                            '${product.price.toStringAsFixed(2)} ${product.currency}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey2,
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          // Special price
                          Text(
                            '${product.special.toStringAsFixed(2)} ${product.currency}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.colorCoral,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ] else ...[
                          // Regular price
                          Text(
                            '${product.price.toStringAsFixed(2)} ${product.currency}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.colorCoral,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const Spacer(),

                    // Quantity controls (matching edit mode behavior)
                    if (isEditMode) ...[
                      Row(
                        children: [
                          // Decrease quantity button
                          GestureDetector(
                            onTap: () {
                              if (product.quantity > 1) {
                                onQuantityChanged(product.quantity - 1);
                              } else {
                                onRemove();
                              }
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.grey3),
                              ),
                              child: Icon(
                                product.quantity > 1 
                                    ? Icons.remove 
                                    : Icons.delete_outline,
                                size: 16,
                                color: product.quantity > 1 
                                    ? AppColors.grey2 
                                    : AppColors.colorCoral,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Quantity display
                          Text(
                            product.quantity.toString(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.colorTitleBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Increase quantity button
                          GestureDetector(
                            onTap: () => onQuantityChanged(product.quantity + 1),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.washyGreen,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Quantity display (non-edit mode)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, 
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.colorBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'الكمية: ${product.quantity}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.colorTitleBlack,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build placeholder image widget
  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.colorBackground,
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.grey2,
        size: 24,
      ),
    );
  }
}
