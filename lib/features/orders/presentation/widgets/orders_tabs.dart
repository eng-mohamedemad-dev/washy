import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/orders_type.dart';

/// Orders tabs widget matching Java OrdersTab_LinearLayout
class OrdersTabs extends StatelessWidget {
  final OrdersType selectedOrderType;
  final Function(OrdersType) onTabChanged;

  const OrdersTabs({
    Key? key,
    required this.selectedOrderType,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Current Orders Tab
          Expanded(
            child: _buildTab(
              title: 'الطلبات الحالية',
              isSelected: selectedOrderType == OrdersType.ALL_ORDERS,
              onTap: () => onTabChanged(OrdersType.ALL_ORDERS),
            ),
          ),
          
          // Order History Tab
          Expanded(
            child: _buildTab(
              title: 'سجل الطلبات',
              isSelected: selectedOrderType == OrdersType.HISTORY_ORDERS,
              onTap: () => onTabChanged(OrdersType.HISTORY_ORDERS),
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual tab
  Widget _buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppColors.washyGreen : AppColors.grey,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}
