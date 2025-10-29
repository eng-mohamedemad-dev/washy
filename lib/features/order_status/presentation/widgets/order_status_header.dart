import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_status_info.dart';

/// Order status header widget
class OrderStatusHeader extends StatelessWidget {
  final OrderStatusInfo orderStatusInfo;

  const OrderStatusHeader({
    Key? key,
    required this.orderStatusInfo,
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
        children: [
          // Order ID and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب #${orderStatusInfo.orderId}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                _formatDate(orderStatusInfo.orderDate),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Current Status
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getStatusColor(),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                orderStatusInfo.status.displayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(),
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Next Status
          if (orderStatusInfo.nextStatus.isNotEmpty)
            Text(
              orderStatusInfo.nextStatus,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
                fontFamily: 'Cairo',
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (orderStatusInfo.status.isCanceled) {
      return Colors.red;
    } else if (orderStatusInfo.status.isCompleted) {
      return AppColors.washyGreen;
    } else {
      return AppColors.washyBlue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}



