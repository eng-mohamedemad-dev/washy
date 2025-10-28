import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/cart_category.dart';
import 'cart_product_item.dart';

/// Cart Category Section Widget - matching Java row_cart.xml layout
class CartCategorySection extends StatelessWidget {
  final CartCategory category;
  final bool isEditMode;
  final Function(int productId, int newQuantity) onQuantityChanged;
  final Function(int productId) onRemoveItem;
  final VoidCallback onOrderPressed;

  const CartCategorySection({
    super.key,
    required this.category,
    required this.isEditMode,
    required this.onQuantityChanged,
    required this.onRemoveItem,
    required this.onOrderPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title (matching Java categoriesTV)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              category.displayName,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.greyDark,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Products list (matching Java ProductRecyclerView)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: category.products.length,
            itemBuilder: (context, index) {
              final product = category.products[index];
              return CartProductItem(
                product: product,
                isEditMode: isEditMode,
                onQuantityChanged: (newQuantity) => 
                    onQuantityChanged(product.productId, newQuantity),
                onRemove: () => onRemoveItem(product.productId),
              );
            },
          ),

          // Bottom section with subtotal and order button
          Container(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // Subtotal row (matching Java layout in row_cart.xml)
                Row(
                  children: [
                    Text(
                      'المجموع الفرعي',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey2,
                        fontSize: 12,
                        letterSpacing: 0.05,
                      ),
                    ),
                    const SizedBox(width: 1),
                    Text(
                      'شامل الضريبة:',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatPrice(category.totalPrice, category.currency),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.colorCoral,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.05,
                      ),
                    ),
                    const Spacer(),

                    // Order button for this category (matching Java OrderNow_TextView)
                    GestureDetector(
                      onTap: onOrderPressed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.washyGreen,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.washyGreen.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          'اطلب الآن',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Separator line (matching Java separator in row_cart.xml)
                Container(
                  height: 1,
                  color: AppColors.grey3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Format price with currency
  String _formatPrice(double price, String currency) {
    if (currency.isEmpty) {
      return price.toStringAsFixed(2);
    }
    return '${price.toStringAsFixed(2)} $currency';
  }
}
