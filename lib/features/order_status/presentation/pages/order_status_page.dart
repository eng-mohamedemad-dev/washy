import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_status_info.dart';
import '../widgets/order_status_header.dart';
import '../widgets/order_status_tracker.dart';
import '../widgets/order_status_actions.dart';

/// Order Status Page matching Java OrderStatusActivity
/// Shows order tracking progress and current status
class OrderStatusPage extends StatefulWidget {
  final int orderId;

  const OrderStatusPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  OrderStatusInfo? orderStatusInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderStatus();
  }

  void _loadOrderStatus() {
    // Simulate loading order status
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        orderStatusInfo = OrderStatusInfo(
          orderId: widget.orderId,
          status: OrderTrackingStatus.CLEANING,
          orderDate: DateTime.now().subtract(const Duration(days: 1)),
          nextStatus: 'سيتم التوصيل قريباً',
          canCallAgent: false,
          canRate: false,
          canViewDetails: true,
        );
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.washyGreen,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'حالة الطلب',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.washyGreen),
            )
          : orderStatusInfo != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Order header info
                      OrderStatusHeader(orderStatusInfo: orderStatusInfo!),
                      
                      const SizedBox(height: 24),
                      
                      // Status tracker
                      OrderStatusTracker(status: orderStatusInfo!.status),
                      
                      const SizedBox(height: 24),
                      
                      // Action buttons
                      OrderStatusActions(
                        orderStatusInfo: orderStatusInfo!,
                        onCallAgent: _handleCallAgent,
                        onRateService: _handleRateService,
                        onViewDetails: _handleViewDetails,
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text(
                    'حدث خطأ في تحميل بيانات الطلب',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
    );
  }

  void _handleCallAgent() {
    // TODO: Implement call agent functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري الاتصال بالوكيل...'),
        backgroundColor: AppColors.washyGreen,
      ),
    );
  }

  void _handleRateService() {
    // TODO: Navigate to rating page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('صفحة التقييم قيد التطوير'),
        backgroundColor: AppColors.washyBlue,
      ),
    );
  }

  void _handleViewDetails() {
    // TODO: Navigate to order details
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تفاصيل الطلب قيد التطوير'),
        backgroundColor: AppColors.washyBlue,
      ),
    );
  }
}
