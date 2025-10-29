import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/orders_type.dart';

/// Empty view for orders matching Java EmptyLayout_LinearLayout
class OrdersEmptyView extends StatelessWidget {
  final OrdersType orderType;
  final bool isUserLoggedIn;
  final VoidCallback? onBrowseItemsPressed;
  final VoidCallback? onLoginPressed;

  const OrdersEmptyView({
    Key? key,
    required this.orderType,
    required this.isUserLoggedIn,
    this.onBrowseItemsPressed,
    this.onLoginPressed,
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
          // Empty orders icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 60,
              color: AppColors.grey,
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Title
          Text(
            isUserLoggedIn ? 'لا توجد طلبات' : 'لا توجد طلبات',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
              fontFamily: 'Cairo',
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            isUserLoggedIn 
                ? _getEmptyMessage()
                : 'يرجى تسجيل الدخول لعرض طلباتك',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.grey,
              fontFamily: 'Cairo',
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Action button
          SizedBox(
            width: 180,
            height: 46,
            child: ElevatedButton(
              onPressed: isUserLoggedIn ? onBrowseItemsPressed : onLoginPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.washyGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
                elevation: 0,
              ),
              child: Text(
                isUserLoggedIn ? 'تصفح المنتجات' : 'تسجيل الدخول',
                style: const TextStyle(
                  color: AppColors.white,
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

  /// Get empty message based on order type
  String _getEmptyMessage() {
    switch (orderType) {
      case OrdersType.ALL_ORDERS:
        return 'لم تقم بإجراء أي طلبات حتى الآن. ابدأ بتصفح منتجاتنا واطلب خدمة الغسيل!';
      case OrdersType.HISTORY_ORDERS:
        return 'لا يوجد سجل طلبات سابقة. ستظهر هنا الطلبات المكتملة والملغية.';
    }
  }
}



