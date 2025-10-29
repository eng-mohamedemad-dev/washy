import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_status_info.dart';

/// Order status tracker widget showing progress steps
class OrderStatusTracker extends StatelessWidget {
  final OrderTrackingStatus status;

  const OrderStatusTracker({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = [
      'قيد المعالجة',
      'تم الاستلام',
      'قيد التنظيف',
      'قيد التوصيل',
      'مكتمل',
    ];

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
            'تتبع الطلب',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
              fontFamily: 'Cairo',
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Progress steps
          Column(
            children: List.generate(steps.length, (index) {
              final stepNumber = index + 1;
              final isCompleted = stepNumber <= status.stepNumber;
              final isCurrent = stepNumber == status.stepNumber;
              
              return _buildStep(
                stepNumber: stepNumber,
                title: steps[index],
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isLast: index == steps.length - 1,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required int stepNumber,
    required String title,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step indicator
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.washyGreen : AppColors.lightGrey,
                border: Border.all(
                  color: isCurrent ? AppColors.washyBlue : 
                         isCompleted ? AppColors.washyGreen : AppColors.lightGrey,
                  width: 2,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 14,
                      )
                    : Text(
                        stepNumber.toString(),
                        style: TextStyle(
                          color: isCurrent ? AppColors.washyBlue : AppColors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            
            // Connecting line
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? AppColors.washyGreen : AppColors.lightGrey,
              ),
          ],
        ),
        
        const SizedBox(width: 12),
        
        // Step title
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                color: isCompleted ? AppColors.darkGrey : 
                       isCurrent ? AppColors.washyBlue : AppColors.grey,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

