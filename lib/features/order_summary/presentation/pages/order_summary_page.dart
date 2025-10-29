import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// OrderSummaryPage - Order summary and confirmation
class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildContent()),
          _buildConfirmButton(context),
        ],
      ),
    );
  }

  /// Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.washyBlue, AppColors.washyGreen],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
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
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Title
            const Positioned(
              left: 66,
              right: 20,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ملخص الطلب',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 30,
                    color: AppColors.white,
                    letterSpacing: -0.02,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Content
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Info Card
          Card(
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
                        Icons.shopping_bag,
                        color: AppColors.washyBlue,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'تفاصيل الطلب',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorTitleBlack,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Order Number
                  _buildInfoRow('رقم الطلب', '#WW12345'),
                  _buildInfoRow('التاريخ', '2024/01/15'),
                  _buildInfoRow('الوقت المتوقع', '24 ساعة'),
                  _buildInfoRow('نوع الخدمة', 'غسيل عادي'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Items Card
          Card(
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
                        Icons.inventory,
                        color: AppColors.washyGreen,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'العناصر المطلوبة',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorTitleBlack,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Items List
                  _buildItemRow('قميص قطني', 2, 3.500),
                  _buildItemRow('بنطلون جينز', 1, 4.000),
                  _buildItemRow('فستان', 1, 8.000),
                  _buildItemRow('جاكيت', 1, 12.000),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Address Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.premiumColor,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'عنوان التسليم',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorTitleBlack,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'المنزل',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorTitleBlack,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'شارع الملك عبدالله الثاني، الدوار السابع، عمان',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      color: AppColors.greyDark,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: AppColors.grey2,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'الاستلام: غداً 10:00 ص',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: AppColors.grey2,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        Icons.local_shipping,
                        color: AppColors.grey2,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'التسليم: بعد غد 6:00 م',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: AppColors.grey2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Payment Card
          Card(
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
                        Icons.payment,
                        color: AppColors.washyBlue,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'طريقة الدفع',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorTitleBlack,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.washyGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.money,
                          color: AppColors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'الدفع نقداً عند التسليم',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 16,
                          color: AppColors.colorTitleBlack,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Total Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppColors.washyBlue.withOpacity(0.1),
                    AppColors.washyGreen.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  _buildTotalRow('المجموع الفرعي', '27.500 د.أ'),
                  _buildTotalRow('رسوم التوصيل', '2.000 د.أ'),
                  _buildTotalRow('خصم', '-3.000 د.أ', isDiscount: true),
                  const Divider(thickness: 2),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الإجمالي',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorTitleBlack,
                        ),
                      ),
                      Text(
                        '26.500 د.أ',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.washyBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
              color: AppColors.grey2,
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

  /// Item Row Widget
  Widget _buildItemRow(String name, int quantity, double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                color: AppColors.colorTitleBlack,
              ),
            ),
          ),
          Text(
            '×$quantity',
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14,
              color: AppColors.grey2,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(price * quantity).toStringAsFixed(3)} د.أ',
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.washyGreen,
            ),
          ),
        ],
      ),
    );
  }

  /// Total Row Widget
  Widget _buildTotalRow(String label, String value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 16,
              color: AppColors.greyDark,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color:
                  isDiscount ? AppColors.washyGreen : AppColors.colorTitleBlack,
            ),
          ),
        ],
      ),
    );
  }

  /// Confirm Button
  Widget _buildConfirmButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () => _confirmOrder(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.washyGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.5),
            ),
          ),
          child: const Text(
            'تأكيد الطلب',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Actions
  void _confirmOrder(BuildContext context) {
    // الانتقال إلى صفحة الدفع مع تمرير رقم الطلب والمبلغ (تماثل تدفق Java)
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'orderId': 12345, // TODO: اجلب رقم الطلب الحقيقي بعد إنشاء الطلب
        'amount': 99.99, // TODO: احسب الإجمالي الحقيقي من ملخص الطلب
      },
    );
  }
}
