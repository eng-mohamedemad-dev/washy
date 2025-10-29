import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/features/premium/domain/entities/premium_service.dart';

/// PremiumDetailsPage - Premium services details (100% matching Java PremiumDetailsActivity)
class PremiumDetailsPage extends StatefulWidget {
  const PremiumDetailsPage({super.key});

  @override
  State<PremiumDetailsPage> createState() => _PremiumDetailsPageState();
}

class _PremiumDetailsPageState extends State<PremiumDetailsPage> {
  int cartItemCount = 3;

  // Mock premium services data
  final List<PremiumService> premiumServices = [
    PremiumService(
      id: 1,
      title: 'الخدمة الذهبية',
      subtitle: 'عناية فائقة بالملابس الراقية',
      description: 'غسيل وكي متخصص للملابس الحساسة والأقمشة الفاخرة مع تعطير خاص',
      price: 15.000,
      originalPrice: 20.000,
      imageUrl: 'assets/images/premium_gold.png',
      features: [
        'غسيل يدوي للأقمشة الحساسة',
        'كي بخاري احترافي',
        'تعطير بعطر فرنسي فاخر',
        'تغليف فاخر مع شماعات خاصة',
        'ضمان 100% على جودة النظافة',
      ],
      estimatedTime: '48-72 ساعة',
    ),
    PremiumService(
      id: 2,
      title: 'خدمة البدلات الرسمية',
      subtitle: 'أناقة مثالية للمناسبات المهمة',
      description: 'تنظيف وكي متخصص للبدلات الرسمية والملابس التنفيذية',
      price: 25.000,
      originalPrice: 30.000,
      imageUrl: 'assets/images/premium_suits.png',
      features: [
        'تنظيف جاف متخصص',
        'كي بالبخار مع تشكيل احترافي',
        'إزالة البقع المستعصية',
        'حفظ شكل البدلة الأصلي',
        'خدمة طوارئ خلال 24 ساعة',
      ],
      estimatedTime: '24-48 ساعة',
    ),
    PremiumService(
      id: 3,
      title: 'عناية الأطفال الخاصة',
      subtitle: 'نظافة آمنة وصحية للأطفال',
      description: 'غسيل متخصص لملابس الأطفال بمواد آمنة وخالية من المواد الكيميائية',
      price: 12.000,
      originalPrice: 15.000,
      imageUrl: 'assets/images/premium_kids.png',
      features: [
        'مواد تنظيف طبيعية 100%',
        'خالية من المواد الكيميائية الضارة',
        'معالجة مضادة للبكتيريا والجراثيم',
        'غسيل منفصل عن ملابس الكبار',
        'فحص دقيق للأقمشة الحساسة',
      ],
      estimatedTime: '24 ساعة',
    ),
    PremiumService(
      id: 4,
      title: 'خدمة الأقمشة الفاخرة',
      subtitle: 'حرير وصوف وكشمير',
      description: 'معالجة خاصة للأقمشة الطبيعية والفاخرة مع الحفاظ على ملمسها الأصلي',
      price: 30.000,
      originalPrice: 40.000,
      imageUrl: 'assets/images/premium_luxury.png',
      features: [
        'تنظيف جاف بتقنية أوروبية',
        'معالجة خاصة للحرير والكشمير',
        'تجديد نعومة الأقمشة الطبيعية',
        'حماية من التلف والانكماش',
        'ضمان مدى الحياة على التقنية',
      ],
      estimatedTime: '72 ساعة',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPremiumBlack,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          _buildOrderButton(),
        ],
      ),
    );
  }

  /// Header with premium black background (100% matching Java layout)
  Widget _buildHeader() {
    return Container(
      height: 110,
      color: AppColors.colorPremiumBlack,
      child: SafeArea(
        child: Stack(
          children: [
            // Back Button (White)
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
            
            // Premium Gold Icon
            Positioned(
              left: 70,
              top: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.colorPremiumGold2.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.diamond,
                  color: AppColors.colorPremiumGold2,
                  size: 24,
                ),
              ),
            ),
            
            // Cart Badge
            Positioned(
              right: 20,
              top: 8,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/cart'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                      if (cartItemCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.colorRedBadge,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$cartItemCount',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
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
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.colorBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Premium Header Section
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Premium Title
                const Text(
                  'الخدمات المميزة',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorTitleBlack,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                const Text(
                  'عناية فائقة وجودة استثنائية لملابسك الثمينة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    color: AppColors.greyDark,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Premium Benefits Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBenefitItem(
                      icon: Icons.star,
                      title: 'جودة عالية',
                      color: AppColors.colorPremiumGold2,
                    ),
                    _buildBenefitItem(
                      icon: Icons.shield,
                      title: 'ضمان شامل',
                      color: AppColors.washyGreen,
                    ),
                    _buildBenefitItem(
                      icon: Icons.access_time,
                      title: 'خدمة سريعة',
                      color: AppColors.washyBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Services List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: premiumServices.length,
              itemBuilder: (context, index) {
                return _buildServiceCard(premiumServices[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Benefit Item Widget
  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Column(
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
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.colorTitleBlack,
          ),
        ),
      ],
    );
  }

  /// Premium Service Card (100% matching Java PremiumRowsAdapter)
  Widget _buildServiceCard(PremiumService service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.colorPremiumGold2.withOpacity(0.05),
              AppColors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with image and title
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Service Image
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.colorPremiumGold2.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.diamond,
                      color: AppColors.colorPremiumGold2,
                      size: 32,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.title,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorTitleBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service.subtitle,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 14,
                            color: AppColors.greyDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (service.originalPrice != null) ...[
                        Text(
                          '${service.originalPrice!.toStringAsFixed(3)} د.أ',
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12,
                            color: AppColors.grey2,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        '${service.price.toStringAsFixed(3)} د.أ',
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorPremiumGold2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                service.description,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 14,
                  color: AppColors.greyDark,
                  height: 1.4,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Features List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المميزات:',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorTitleBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...service.features.take(3).map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.colorPremiumGold2,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 13,
                              color: AppColors.greyDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Time and Order Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.grey5,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.grey2,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        service.estimatedTime,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12,
                          color: AppColors.grey2,
                        ),
                      ),
                    ],
                  ),
                  
                  ElevatedButton(
                    onPressed: () => _addToCart(service),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorPremiumGold2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_shopping_cart,
                          size: 16,
                          color: AppColors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'اطلب الآن',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ],
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

  /// Order Now Button (100% matching Java OrderNow_TextView)
  Widget _buildOrderButton() {
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
          onPressed: _onOrderAllPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.colorPremiumGold2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.5),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.diamond,
                color: AppColors.white,
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'اطلب جميع الخدمات المميزة',
                style: TextStyle(
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
    );
  }

  // Action Methods
  void _addToCart(PremiumService service) {
    // Add service to cart
    setState(() {
      cartItemCount++;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة ${service.title} إلى السلة'),
        backgroundColor: AppColors.colorPremiumGold2,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onOrderAllPressed() {
    Navigator.pushNamed(context, '/cart');
  }
}

