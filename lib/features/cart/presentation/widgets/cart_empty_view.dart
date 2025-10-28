import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Cart Empty View Widget - matching Java EmptyLayout_RelativeLayout
class CartEmptyView extends StatelessWidget {
  final VoidCallback onBrowseItemsPressed;

  const CartEmptyView({
    super.key,
    required this.onBrowseItemsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty icon (matching Java ic_empty_icon)
          Container(
            width: 218,
            height: 130,
            margin: const EdgeInsets.only(top: 70),
            decoration: BoxDecoration(
              color: AppColors.grey3.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.shopping_basket_outlined,
              size: 80,
              color: AppColors.grey2,
            ),
          ),

          const SizedBox(height: 60),

          // Title text (matching Java no_items_in_the_basket)
          Text(
            'لا توجد عناصر في السلة',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.colorTitleBlack,
              fontSize: 27,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Description text (matching Java empty_basket_hint)
          Text(
            'ابدأ بإضافة المنتجات التي تحتاجها\nإلى سلة التسوق',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.grey2,
              fontSize: 17,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 56),

          // Browse items button (matching Java BrowseItems_TextView)
          GestureDetector(
            onTap: onBrowseItemsPressed,
            child: Container(
              width: 200,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.washyGreen,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.washyGreen.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'تصفح المنتجات',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontSize: 14,
                  letterSpacing: 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
