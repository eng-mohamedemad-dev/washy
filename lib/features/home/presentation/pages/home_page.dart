import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/features/home/domain/entities/home_service.dart';

/// HomePage - Main application page (100% matching Java HomePageActivity)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTabIndex = 0;
  int cartItemCount = 3;
  int notificationCount = 5;
  bool isHurryModeEnabled = false;
  
  // Mock data for home services
  final List<HomeService> services = [
    HomeService(
      id: 1,
      title: 'الغسيل العادي',
      subtitle: 'ملابس قطنية وعادية',
      price: '2.500 د.أ',
      estimatedTime: '24 ساعة',
      imageUrl: 'assets/images/ic_regular_wash.png',
      color: AppColors.washyBlue,
    ),
    HomeService(
      id: 2,
      title: 'التنظيف الجاف',
      subtitle: 'بدلات وملابس حساسة',
      price: '8.000 د.أ',
      estimatedTime: '48 ساعة',
      imageUrl: 'assets/images/ic_dry_clean.png',
      color: AppColors.washyGreen,
    ),
    HomeService(
      id: 3,
      title: 'غسيل الأحذية',
      subtitle: 'جميع أنواع الأحذية',
      price: '5.000 د.أ',
      estimatedTime: '12 ساعة',
      imageUrl: 'assets/images/ic_shoes.png',
      color: AppColors.premiumColor,
    ),
    HomeService(
      id: 4,
      title: 'تنظيف الأثاث',
      subtitle: 'كنب وسجاد ومفروشات',
      price: '15.000 د.أ',
      estimatedTime: '24-48 ساعة',
      imageUrl: 'assets/images/ic_furniture.png',
      color: AppColors.colorCoral,
    ),
    HomeService(
      id: 5,
      title: 'الخدمة السريعة',
      subtitle: 'توصيل خلال ساعات',
      price: '+2.000 د.أ',
      estimatedTime: '4-6 ساعات',
      imageUrl: 'assets/images/ic_express.png',
      color: AppColors.colorRedBadge,
    ),
    HomeService(
      id: 6,
      title: 'الخدمة المميزة',
      subtitle: 'عناية فائقة بالملابس',
      price: '12.000 د.أ',
      estimatedTime: '48-72 ساعة',
      imageUrl: 'assets/images/ic_premium.png',
      color: AppColors.colorPremiumGold2,
    ),
  ];

  final List<String> categories = ['الكل', 'غسيل', 'تنظيف جاف', 'أثاث', 'سريع', 'مميز'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildToolbar(),
          _buildSearchAndFilter(),
          _buildCategories(),
          Expanded(child: _buildServicesList()),
          _buildOrderNowButton(),
        ],
      ),
    );
  }

  /// Toolbar (100% matching Java toolbar)
  Widget _buildToolbar() {
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
            
            // Logo
            Positioned(
              left: 66,
              top: 0,
              bottom: 0,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/washy_wash_word_white.png',
                  height: 30,
                  width: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            // Notification Badge
            Positioned(
              right: 80,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/notifications'),
                child: Container(
                  width: 40,
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 8,
                        top: 18,
                        child: Icon(
                          Icons.notifications_outlined,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          right: 6,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.colorRedBadge,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '$notificationCount',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 11,
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
            
            // Cart Badge
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/cart'),
                child: Container(
                  width: 40,
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 8,
                        top: 18,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                      if (cartItemCount > 0)
                        Positioned(
                          right: 6,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.colorRedBadge,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '$cartItemCount',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 11,
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

  /// Search and Filter Section (100% matching Java FilterSection_CardView)
  Widget _buildSearchAndFilter() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search Section
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to search page
              },
              child: const Row(
                children: [
                  SizedBox(width: 19),
                  Icon(
                    Icons.search,
                    color: AppColors.colorTextNotSelected,
                    size: 20,
                  ),
                  SizedBox(width: 19),
                  Text(
                    'ابحث عن خدمة الغسيل',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      color: AppColors.colorTextNotSelected,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Categories Button
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 19),
            decoration: const BoxDecoration(
              color: AppColors.washyBlue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'الفئات',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Categories TabBar (100% matching Java HomePageTabHolder_LinearLayout)
  Widget _buildCategories() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.washyGreen,
        indicatorWeight: 3,
        labelColor: AppColors.washyGreen,
        unselectedLabelColor: AppColors.colorTextNotSelected,
        labelStyle: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        tabs: categories.map((category) => Tab(text: category)).toList(),
        onTap: (index) {
          setState(() {
            selectedTabIndex = index;
          });
        },
      ),
    );
  }

  /// Services Grid (100% matching Java RecyclerView)
  Widget _buildServicesList() {
    return TabBarView(
      controller: _tabController,
      children: categories.map((category) {
        final filteredServices = _getFilteredServices(category);
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: filteredServices.length,
          itemBuilder: (context, index) {
            return _buildServiceCard(filteredServices[index]);
          },
        );
      }).toList(),
    );
  }

  /// Service Card Widget (100% matching Java HomePageAdapter items)
  Widget _buildServiceCard(HomeService service) {
    return GestureDetector(
      onTap: () => _onServiceTap(service),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                service.color.withOpacity(0.1),
                AppColors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: service.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getServiceIcon(service.id),
                  color: service.color,
                  size: 28,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Service Title
              Text(
                service.title,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorTitleBlack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // Service Subtitle
              Text(
                service.subtitle,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 12,
                  color: AppColors.greyDark,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const Spacer(),
              
              // Price and Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.price,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: service.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.grey2,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          service.estimatedTime,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 11,
                            color: AppColors.grey2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Order Now Button (100% matching Java OrderNow_TextView)
  Widget _buildOrderNowButton() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _onOrderNowPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.washyGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_shopping_cart,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                'اطلب الآن',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              if (isHurryModeEnabled) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.colorRedBadge,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'سريع',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 10,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methods
  List<HomeService> _getFilteredServices(String category) {
    if (category == 'الكل') return services;
    
    switch (category) {
      case 'غسيل':
        return services.where((s) => s.id == 1).toList();
      case 'تنظيف جاف':
        return services.where((s) => s.id == 2).toList();
      case 'أثاث':
        return services.where((s) => s.id == 4).toList();
      case 'سريع':
        return services.where((s) => s.id == 5).toList();
      case 'مميز':
        return services.where((s) => s.id == 6).toList();
      default:
        return services;
    }
  }

  IconData _getServiceIcon(int serviceId) {
    switch (serviceId) {
      case 1:
        return Icons.local_laundry_service;
      case 2:
        return Icons.dry_cleaning;
      case 3:
        return Icons.cleaning_services;
      case 4:
        return Icons.chair;
      case 5:
        return Icons.flash_on;
      case 6:
        return Icons.diamond;
      default:
        return Icons.local_laundry_service;
    }
  }

  // Action Methods
  void _onServiceTap(HomeService service) {
    // إذا كانت خدمة الأثاث انتقل مباشرة لشاشة الأثاث
    if (service.id == 4) {
      Navigator.pushNamed(context, '/furniture-service');
      return;
    }

    // إذا كانت الخدمة السريعة افتح شاشة الخدمة السريعة
    if (service.id == 5) {
      Navigator.pushNamed(context, '/express-delivery');
      return;
    }

    Navigator.pushNamed(
      context,
      '/home-category-details',
      arguments: {
        'title': service.title,
        'description': service.subtitle,
      },
    );
  }

  void _onOrderNowPressed() {
    Navigator.pushNamed(context, '/new-order');
  }
}

