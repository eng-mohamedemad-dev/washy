import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Error view for orders when something goes wrong
class OrdersErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetryPressed;

  const OrdersErrorView({
    Key? key,
    required this.message,
    this.onRetryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(40),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Error title
          const Text(
            'حدث خطأ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
              fontFamily: 'Cairo',
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Error message
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.grey,
              fontFamily: 'Cairo',
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Retry button
          SizedBox(
            width: 180,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: onRetryPressed,
              icon: const Icon(
                Icons.refresh,
                color: AppColors.white,
                size: 20,
              ),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.washyBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

