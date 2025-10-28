import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/cart_summary.dart';

/// Cart Order Button Widget - matching Java OrderNow_TextView at bottom
class CartOrderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final CartSummary cartSummary;

  const CartOrderButton({
    super.key,
    required this.onPressed,
    required this.cartSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.washyGreen,
          foregroundColor: AppColors.white,
          elevation: 4,
          shadowColor: AppColors.washyGreen.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'اطلب الآن',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.white,
                fontSize: 19,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.05,
              ),
            ),

            const SizedBox(width: 12),

            // Cart summary info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${cartSummary.totalItemCount} عنصر',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
