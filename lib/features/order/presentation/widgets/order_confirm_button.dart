import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Confirm order button that shows pricing summary and allows order submission
/// Matches the bottom button in Java NewOrderActivity
class OrderConfirmButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final VoidCallback? onPressed;

  const OrderConfirmButton({
    Key? key,
    required this.isEnabled,
    required this.isLoading,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Price summary
          if (subtotal > 0 || deliveryFee > 0 || discount > 0 || total > 0)
            _buildPriceSummary(),
          
          const SizedBox(height: 16),
          
          // Confirm button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isEnabled && !isLoading ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled
                    ? AppColors.washyGreen
                    : AppColors.lightGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'تأكيد الطلب',
                      style: TextStyle(
                        color: isEnabled ? AppColors.white : AppColors.darkGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build price summary section
  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightGrey.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Subtotal
          if (subtotal > 0)
            _buildPriceRow('المجموع الفرعي', subtotal, false),
          
          // Delivery fee
          if (deliveryFee > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow('رسوم التوصيل', deliveryFee, false),
          ],
          
          // Discount
          if (discount > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow('الخصم', discount, true),
          ],
          
          // Divider
          if (subtotal > 0 || deliveryFee > 0 || discount > 0) ...[
            const SizedBox(height: 12),
            Divider(
              color: AppColors.lightGrey.withOpacity(0.5),
              thickness: 1,
            ),
            const SizedBox(height: 12),
          ],
          
          // Total
          _buildPriceRow('الإجمالي', total, false, isTotal: true),
        ],
      ),
    );
  }

  /// Build individual price row
  Widget _buildPriceRow(
    String label,
    double amount,
    bool isDiscount, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? AppColors.darkGrey : AppColors.grey,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          '${isDiscount ? '-' : ''}${amount.toStringAsFixed(2)} ريال',
          style: TextStyle(
            color: isDiscount
                ? AppColors.washyGreen
                : isTotal
                    ? AppColors.darkGrey
                    : AppColors.grey,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
