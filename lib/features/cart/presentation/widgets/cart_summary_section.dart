import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/cart_summary.dart';

/// Cart Summary Section Widget - matching Java SubTotalSection_RelativeLayout
class CartSummarySection extends StatelessWidget {
  final CartSummary cartSummary;

  const CartSummarySection({
    super.key,
    required this.cartSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Items count (matching Java ItemsNumber_TextView)
          Text(
            cartSummary.getItemCountText(),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.colorTitleBlack,
              fontSize: 12,
              letterSpacing: 0.05,
            ),
          ),

          const Spacer(),

          // Subtotal section (matching Java LinearLayout with subtotal)
          Row(
            children: [
              // Subtotal label (matching Java subtotal_Label)
              Text(
                'المجموع الفرعي',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey2,
                  fontSize: 12,
                  letterSpacing: 0.05,
                ),
              ),

              const SizedBox(width: 1),

              // Tax included text (matching Java tax_included_with_colon)
              Text(
                'شامل الضريبة:',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 9,
                ),
              ),

              const SizedBox(width: 4),

              // Subtotal price (matching Java SubTotalPriceValue_TextView)
              Text(
                _formatPrice(cartSummary.subtotalPrice, cartSummary.currency),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.colorCoral,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.05,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Format price with currency (matching Java NumberFormatUtils.formatPrice)
  String _formatPrice(double price, String currency) {
    if (currency.isEmpty) {
      return price.toStringAsFixed(2);
    }
    return '${price.toStringAsFixed(2)} $currency';
  }
}
