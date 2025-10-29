import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// ExpressDeliveryPage - Express delivery service information
class ExpressDeliveryPage extends StatefulWidget {
  const ExpressDeliveryPage({super.key});

  @override
  State<ExpressDeliveryPage> createState() => _ExpressDeliveryPageState();
}

class _ExpressDeliveryPageState extends State<ExpressDeliveryPage> {
  bool isExpressSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          _buildOrderButton(),
        ],
      ),
    );
  }

  /// Header with gradient background
  Widget _buildHeader() {
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
                child: Container(
                  width: 66,
                  child: const Icon(
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
                  'التوصيل السريع',
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Express Icon & Title
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.washyBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.flash_on,
                    size: 50,
                    color: AppColors.washyBlue,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  'خدمة التوصيل السريع',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorTitleBlack,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  'احصل على ملابسك في أسرع وقت ممكن',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    color: AppColors.grey2,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Features
          _buildFeatureCard(
            icon: Icons.access_time,
            title: 'توصيل خلال ساعات',
            description: 'احصل على ملابسك نظيفة ومكوية خلال 4-6 ساعات فقط',
            color: AppColors.washyBlue,
          ),
          
          const SizedBox(height: 16),
          
          _buildFeatureCard(
            icon: Icons.star,
            title: 'جودة مضمونة',
            description: 'نفس الجودة العالية مع سرعة في التنفيذ',
            color: AppColors.washyGreen,
          ),
          
          const SizedBox(height: 16),
          
          _buildFeatureCard(
            icon: Icons.local_shipping,
            title: 'استلام وتسليم مجاني',
            description: 'خدمة الاستلام والتسليم من وإلى منزلك',
            color: AppColors.premiumColor,
          ),
          
          const SizedBox(height: 32),
          
          // Pricing Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                  const Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: AppColors.washyBlue,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'التكلفة الإضافية',
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
                  
                  const Text(
                    '+ 2.000 د.أ إضافية فقط',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.washyBlue,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  const Text(
                    'على إجمالي فاتورة الغسيل',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      color: AppColors.grey2,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Selection Toggle
                  Row(
                    children: [
                      Checkbox(
                        value: isExpressSelected,
                        onChanged: (value) {
                          setState(() {
                            isExpressSelected = value ?? false;
                          });
                        },
                        activeColor: AppColors.washyGreen,
                      ),
                      const Expanded(
                        child: Text(
                          'أريد إضافة خدمة التوصيل السريع',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 16,
                            color: AppColors.colorTitleBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Terms Note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey5,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.grey2,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'ملاحظات مهمة:',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.greyDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• خدمة التوصيل السريع متاحة من 8:00 ص إلى 8:00 م\n• يتم التوصيل خلال 4-6 ساعات من وقت الاستلام\n• غير متاح للملابس التي تحتاج تنظيف جاف\n• خاضع للتوفر والمنطقة الجغرافية',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    color: AppColors.grey2,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Feature Card Widget
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorTitleBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      color: AppColors.greyDark,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Order Button
  Widget _buildOrderButton() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () => _onOrderPressed(),
          style: ElevatedButton.styleFrom(
            backgroundColor: isExpressSelected 
                ? AppColors.washyGreen 
                : AppColors.washyBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.5),
            ),
          ),
          child: Text(
            isExpressSelected 
                ? 'طلب مع التوصيل السريع (+2.000 د.أ)'
                : 'العودة للطلب العادي',
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Actions
  void _onOrderPressed() {
    // إذا اختار المستخدم التوصيل السريع نكمل إلى إنشاء الطلب
    if (isExpressSelected) {
      Navigator.pushNamed(
        context,
        '/new-order',
        arguments: {
          'orderType': 'express',
        },
      );
      return;
    }

    // عودة للطلب العادي
    Navigator.pushNamed(context, '/new-order');
  }
}

