import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/cart_summary.dart';
import 'cart_category_section.dart';

/// Cart Items List Widget - matching Java CartRecyclerView with CartAdapter
class CartItemsList extends StatelessWidget {
  final CartSummary cartSummary;
  final bool isEditMode;
  final Function(int productId, int newQuantity) onQuantityChanged;
  final Function(int productId) onRemoveItem;
  final Function(String categoryType) onCategoryOrderPressed;

  const CartItemsList({
    super.key,
    required this.cartSummary,
    required this.isEditMode,
    required this.onQuantityChanged,
    required this.onRemoveItem,
    required this.onCategoryOrderPressed,
  });

  @override
  Widget build(BuildContext context) {
    final nonEmptyCategories = cartSummary.nonEmptyCategories;

    if (nonEmptyCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      clipBehavior: Clip.none,
      itemCount: nonEmptyCategories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        final category = nonEmptyCategories[index];

        return CartCategorySection(
          category: category,
          isEditMode: isEditMode,
          onQuantityChanged: onQuantityChanged,
          onRemoveItem: onRemoveItem,
          onOrderPressed: () => onCategoryOrderPressed(category.type),
        );
      },
    );
  }
}
