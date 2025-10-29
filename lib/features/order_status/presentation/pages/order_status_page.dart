import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/features/order_status/domain/entities/order_status.dart';
import 'package:wash_flutter/features/order_status/presentation/widgets/order_status_view.dart';
import 'package:url_launcher/url_launcher.dart';

/// OrderStatusPage - Order status tracking (100% matching Java OrderStatusActivity)
class OrderStatusPage extends StatefulWidget {
  final int orderId;

  const OrderStatusPage({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  OrderStatus currentStatus = OrderStatus.confirmed;
  bool isLoading = true;
  String orderIdAndDate = '';
  String statusTitle = '';
  String statusDescription = '';
  String actionButtonText = '';
  bool showActionButton = false;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  /// Header Section (100% matching Java Header_RelativeLayout)
  Widget _buildHeader() {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.colorViewSeparators,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Back Button
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const SizedBox(
                  width: 66,
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.colorTitleBlack,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Center Content
            Positioned(
              left: 66,
              right: 66,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Order Status Label
                  const Text(
                    'حالة الطلب',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 19,
                      color: AppColors.colorTitleBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Order ID and Date
                  Text(
                    orderIdAndDate.isEmpty
                        ? 'طلب #${widget.orderId} - اليوم'
                        : orderIdAndDate,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                      color: AppColors.colorTextNotSelected,
                    ),
                  ),
                ],
              ),
            ),

            // Order Details Button
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _onOrderDetailsPressed,
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'تفاصيل الطلب',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14.3,
                      color: AppColors.colorTitleBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Content Section (100% matching Java EmptyLayout_RelativeLayout)
  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.washyBlue,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 35),

          // Order Status View (Custom progress indicator)
          OrderStatusView(
            currentStatus: currentStatus,
            orderId: widget.orderId,
          ),

          const SizedBox(height: 15),

          // Next Status Text
          Text(
            _getNextStatusText(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 18,
              color: AppColors.colorTextNotSelected,
            ),
          ),

          const SizedBox(height: 35),

          // Status Icon
          Container(
            width: 218,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.grey5,
            ),
            child: Icon(
              _getStatusIcon(),
              size: 80,
              color: _getStatusColor(),
            ),
          ),

          const SizedBox(height: 26),

          // Status Title
          Text(
            statusTitle.isEmpty ? _getStatusTitle() : statusTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 15),

          // Status Description
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              statusDescription.isEmpty
                  ? _getStatusDescription()
                  : statusDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                color: AppColors.greyDark,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Action Button
          if (showActionButton || _shouldShowActionButton())
            Container(
              width: double.infinity,
              height: 55,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: _onActionButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getActionButtonColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getActionButtonIcon(),
                      color: AppColors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      actionButtonText.isEmpty
                          ? _getActionButtonText()
                          : actionButtonText,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 40),

          // Additional Info Card
          _buildInfoCard(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// Additional Info Card
  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.washyBlue,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'معلومات إضافية',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorTitleBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('رقم الطلب', '#WW${widget.orderId}'),
            _buildInfoRow('تاريخ الطلب', '15/01/2024'),
            _buildInfoRow('الوقت المقدر', _getEstimatedTime()),
            _buildInfoRow('طريقة الدفع', 'الدفع نقداً'),
            if (currentStatus == OrderStatus.inProgress) ...[
              const Divider(height: 20),
              const Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: AppColors.washyGreen,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'الوقت المتبقي: ',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      color: AppColors.greyDark,
                    ),
                  ),
                  Text(
                    '12 ساعة',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.washyGreen,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Info Row Widget
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14,
              color: AppColors.greyDark,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.colorTitleBlack,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods (100% matching Java logic)
  String _getNextStatusText() {
    switch (currentStatus) {
      case OrderStatus.confirmed:
        return 'في انتظار الاستلام';
      case OrderStatus.pickedUp:
        return 'جاري المعالجة';
      case OrderStatus.inProgress:
        return 'جاري التنظيف والكي';
      case OrderStatus.readyForDelivery:
        return 'جاهز للتسليم';
      case OrderStatus.outForDelivery:
        return 'في الطريق إليك';
      case OrderStatus.delivered:
        return 'تم التسليم بنجاح';
      default:
        return '';
    }
  }

  String _getStatusTitle() {
    switch (currentStatus) {
      case OrderStatus.confirmed:
        return 'تم تأكيد طلبك';
      case OrderStatus.pickedUp:
        return 'تم استلام الملابس';
      case OrderStatus.inProgress:
        return 'جاري معالجة طلبك';
      case OrderStatus.readyForDelivery:
        return 'طلبك جاهز للتسليم';
      case OrderStatus.outForDelivery:
        return 'طلبك في الطريق';
      case OrderStatus.delivered:
        return 'تم تسليم طلبك';
      default:
        return 'حالة الطلب';
    }
  }

  String _getStatusDescription() {
    switch (currentStatus) {
      case OrderStatus.confirmed:
        return 'سيتم التواصل معك قريباً لتحديد موعد الاستلام من عنوانك.';
      case OrderStatus.pickedUp:
        return 'تم استلام ملابسك بنجاح وهي الآن في مركز الغسيل لدينا.';
      case OrderStatus.inProgress:
        return 'يتم الآن غسل وكي ملابسك بعناية فائقة وفقاً لأعلى معايير الجودة.';
      case OrderStatus.readyForDelivery:
        return 'ملابسك جاهزة ونظيفة! سيتم التواصل معك لتحديد موعد التسليم.';
      case OrderStatus.outForDelivery:
        return 'السائق في الطريق إليك الآن. يرجى التأكد من وجودك في العنوان المحدد.';
      case OrderStatus.delivered:
        return 'تم تسليم طلبك بنجاح. نشكرك لاختيار واشي واش ونتطلع لخدمتك مرة أخرى.';
      default:
        return '';
    }
  }

  IconData _getStatusIcon() {
    switch (currentStatus) {
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.pickedUp:
        return Icons.local_shipping;
      case OrderStatus.inProgress:
        return Icons.settings;
      case OrderStatus.readyForDelivery:
        return Icons.done_all;
      case OrderStatus.outForDelivery:
        return Icons.delivery_dining;
      case OrderStatus.delivered:
        return Icons.celebration;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor() {
    switch (currentStatus) {
      case OrderStatus.confirmed:
        return AppColors.washyBlue;
      case OrderStatus.pickedUp:
        return AppColors.premiumColor;
      case OrderStatus.inProgress:
        return AppColors.washyGreen;
      case OrderStatus.readyForDelivery:
        return AppColors.washyGreen;
      case OrderStatus.outForDelivery:
        return AppColors.colorCoral;
      case OrderStatus.delivered:
        return AppColors.washyGreen;
      default:
        return AppColors.grey2;
    }
  }

  bool _shouldShowActionButton() {
    return currentStatus == OrderStatus.outForDelivery ||
        currentStatus == OrderStatus.delivered;
  }

  String _getActionButtonText() {
    switch (currentStatus) {
      case OrderStatus.outForDelivery:
        return 'اتصل بالسائق';
      case OrderStatus.delivered:
        return 'قيّم الخدمة';
      default:
        return '';
    }
  }

  IconData _getActionButtonIcon() {
    switch (currentStatus) {
      case OrderStatus.outForDelivery:
        return Icons.phone;
      case OrderStatus.delivered:
        return Icons.star_rate;
      default:
        return Icons.info;
    }
  }

  Color _getActionButtonColor() {
    switch (currentStatus) {
      case OrderStatus.outForDelivery:
        return AppColors.colorCoral;
      case OrderStatus.delivered:
        return AppColors.washyGreen;
      default:
        return AppColors.washyBlue;
    }
  }

  String _getEstimatedTime() {
    switch (currentStatus) {
      case OrderStatus.confirmed:
      case OrderStatus.pickedUp:
      case OrderStatus.inProgress:
        return '24 ساعة';
      case OrderStatus.readyForDelivery:
        return 'خلال ساعات';
      case OrderStatus.outForDelivery:
        return '30 دقيقة';
      case OrderStatus.delivered:
        return 'مكتمل';
      default:
        return 'غير محدد';
    }
  }

  // Action Methods (100% matching Java handleOrderActionClicked)
  void _onActionButtonPressed() {
    switch (currentStatus) {
      case OrderStatus.outForDelivery:
        _callDriver();
        break;
      case OrderStatus.delivered:
        _rateService();
        break;
      default:
        break;
    }
  }

  void _callDriver() async {
    const phoneNumber = '+962799123456'; // Mock driver number
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا يمكن إجراء المكالمة الآن'),
            backgroundColor: AppColors.colorRedError,
          ),
        );
      }
    }
  }

  void _rateService() {
    Navigator.pushNamed(
      context,
      '/rate-service',
      arguments: {
        'orderId': widget.orderId,
        'orderType': 'regular',
      },
    );
  }

  void _onOrderDetailsPressed() {
    Navigator.pushNamed(
      context,
      '/order-details',
      arguments: {'orderId': widget.orderId},
    );
  }

  // Mock data loading (In real app, this would call API)
  void _loadOrderDetails() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
      orderIdAndDate = 'طلب #WW${widget.orderId} - 15 يناير 2024';
      // Mock different statuses for demo
      currentStatus =
          OrderStatus.values[widget.orderId % OrderStatus.values.length];
    });
  }
}
