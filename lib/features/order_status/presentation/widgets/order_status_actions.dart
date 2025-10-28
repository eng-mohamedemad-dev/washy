import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_status_info.dart';

/// Order status actions widget with action buttons
class OrderStatusActions extends StatelessWidget {
  final OrderStatusInfo orderStatusInfo;
  final VoidCallback? onCallAgent;
  final VoidCallback? onRateService;
  final VoidCallback? onViewDetails;

  const OrderStatusActions({
    Key? key,
    required this.orderStatusInfo,
    this.onCallAgent,
    this.onRateService,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الإجراءات المتاحة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
              fontFamily: 'Cairo',
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Column(
            children: [
              // View Details button (always available)
              if (orderStatusInfo.canViewDetails)
                _buildActionButton(
                  icon: Icons.info_outline,
                  title: 'عرض تفاصيل الطلب',
                  color: AppColors.washyBlue,
                  onPressed: onViewDetails,
                ),
              
              // Call Agent button (for delivery status)
              if (orderStatusInfo.canCallAgent) ...[
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.phone,
                  title: 'الاتصال بالوكيل',
                  color: AppColors.washyGreen,
                  onPressed: onCallAgent,
                ),
              ],
              
              // Rate Service button (for completed orders)
              if (orderStatusInfo.canRate) ...[
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.star_outline,
                  title: 'تقييم الخدمة',
                  color: Colors.orange,
                  onPressed: onRateService,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.white, size: 20),
        label: Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
