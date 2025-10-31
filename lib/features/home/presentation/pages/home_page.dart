import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/features/home/domain/entities/home_service.dart';
import 'package:wash_flutter/features/home/data/services/home_api_service.dart';
import 'package:wash_flutter/features/home/data/models/landing_page_response.dart' as landing;
import 'package:wash_flutter/features/home/data/models/home_page_response.dart' as home;
import 'package:wash_flutter/injection_container.dart' as di;
import 'package:wash_flutter/l10n/app_localizations.dart';
import 'package:wash_flutter/core/config/locale_notifier.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// HomePage - Main application page (100% matching Java HomePageActivity)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  int selectedTabIndex = 0;
  int cartItemCount = 3;
  int notificationCount = 5;
  bool isHurryModeEnabled = false;

  // Network data
  List<landing.BannerItem> _banners = [];
  List<landing.LandingItem> _landingItems = [];
  List<home.HomeCategory> _categories = [];
  bool _isLoading = true;
  late final String _serverBaseUrl;
  // Banner slider state
  late final PageController _bannerController;
  int _bannerIndex = 0;
  String _appVersion = '';

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

  final List<String> categories = [
    'الكل',
    'غسيل',
    'تنظيف جاف',
    'أثاث',
    'سريع',
    'مميز'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    final prefs = di.getIt<SharedPreferences>();
    final saved = prefs.getString('server_url');
    _serverBaseUrl = (saved != null && saved.isNotEmpty)
        ? (saved.endsWith('/') ? saved : '$saved/')
        : 'https://washywash.net/';
    _bannerController = PageController(viewportFraction: 0.92);
    _loadLanding();
    _loadVersion();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() => _appVersion = info.version);
    } catch (_) {}
  }

  String _resolveUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final p = path.startsWith('/') ? path.substring(1) : path;
    return '$_serverBaseUrl$p';
  }

  Future<void> _loadLanding() async {
    try {
      final api = di.getIt<HomeApiService>();
      final res = await api.fetchLanding();
      final homeRes = await api.fetchHomePage();
      setState(() {
        _banners = res.data?.bannersItems ?? [];
        _landingItems = res.data?.landingItems ?? [];
        _categories = homeRes.data?.categories ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.colorBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildToolbar(),
            _isLoading
                ? const SizedBox(height: 220)
                : _buildBannerSlider(),
            _buildTopCategoriesGrid(),
            const SizedBox(height: 8),
            _buildQuickOrderSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      endDrawer: _buildEndDrawer(),
    );
  }

  /// Toolbar (مطابق للشكل المطلوب: جرس يسار - شعار واسم - منيو يمين)
  Widget _buildToolbar() {
    return Container(
      height: 90,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.washyBlue, AppColors.washyGreen],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Notifications icon
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/notifications'),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.notifications_none,
                      color: AppColors.white,
                      size: 26,
                    ),
                    if (notificationCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.colorRedBadge,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$notificationCount',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Middle: logo + name (مرن لمنع overflow)
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/washy_wash_word_white.png',
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Right: menu icon
              GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                child: const Icon(
                  Icons.menu,
                  color: AppColors.white,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Banner slider في المنتصف (PageView + مؤشرات)
  Widget _buildBannerSlider() {
    // إن وُجدت بيانات الشبكة استخدمها، وإلا fallback على صور الأصول
    final banners = _banners.isNotEmpty
        ? _banners
            .map((e) => _resolveUrl(e.image))
            .where((p) => p.isNotEmpty)
            .toList()
        : [
            'assets/images/background_intro_page1.png',
            'assets/images/background_intro_page2.png',
            'assets/images/background_intro_page3.png',
          ];
    return SizedBox(
      height: 240,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _bannerController,
              itemCount: banners.length,
              onPageChanged: (i) => setState(() => _bannerIndex = i),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: banners[index].startsWith('http')
                        ? Image.network(
                            banners[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: AppColors.grey3),
                          )
                        : Image.asset(
                            banners[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: AppColors.grey3),
                          ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: i == _bannerIndex ? 9 : 7,
                height: i == _bannerIndex ? 9 : 7,
                margin: const EdgeInsets.symmetric(horizontal: 3.5),
                decoration: BoxDecoration(
                  color: i == _bannerIndex ? AppColors.washyGreen : AppColors.grey3,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// القائمة الجانبية اليمنى (مطابقة لسلوك الجافا)
  Widget _buildEndDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () => di.getIt<LocaleNotifier>().toggle(),
                    child: Text(
                      Localizations.localeOf(context).languageCode == 'ar' ? 'English' : 'العربية',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Center(
                child: Image.asset('assets/images/washy_wash_word_white.png', height: 42, fit: BoxFit.contain),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                children: [
                  _drawerNavItem(AppLocalizations.of(context).t('home'), selected: true, onTap: () {
                    Navigator.pop(context);
                  }),
                  _drawerNavItem(AppLocalizations.of(context).t('orders'), onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/orders');
                  }),
                  _drawerNavItem(AppLocalizations.of(context).t('notifications'), onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/notifications');
                  }),
                  _drawerNavItem(AppLocalizations.of(context).t('profile'), onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.washyBlue),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      child: Text(AppLocalizations.of(context).t('what_is_ecoclean'), style: const TextStyle(fontSize: 16, color: AppColors.washyBlue)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${AppLocalizations.of(context).t('version')} ${_appVersion.isEmpty ? '—' : _appVersion}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: AppColors.grey2)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/terms-and-conditions');
                    },
                    child: Text(AppLocalizations.of(context).t('terms'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.washyBlue),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          color: AppColors.colorTitleBlack,
        ),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_back_ios_new, size: 14),
    );
  }

  Widget _drawerNavItem(String title, {bool selected = false, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 20,
          color: selected ? AppColors.colorTitleBlack : AppColors.grey2,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.circle, size: 12, color: AppColors.washyGreen)
          : const SizedBox(width: 12),
      onTap: onTap,
    );
  }

  /// شبكة الخدمات المختصرة (8 أيقونات) تحت السلايدر
  Widget _buildTopCategoriesGrid() {
    final items = _categories.isNotEmpty
        ? _categories
            .map((e) => {
                  'title': e.title ?? '',
                  'image': _resolveUrl(e.image),
                })
            .toList()
        : [
            {'title': 'Car detailing', 'icon': Icons.directions_car},
            {'title': 'Carpet', 'icon': Icons.layers},
            {'title': 'Furniture', 'icon': Icons.chair},
            {'title': 'Clothes', 'icon': Icons.checkroom},
            {'title': 'Offers!', 'icon': Icons.local_offer},
            {'title': 'Tailoring', 'icon': Icons.cut},
            {'title': 'Shoes', 'icon': Icons.directions_walk},
            {'title': 'House\ncleaning', 'icon': Icons.home},
          ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: .9,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              final String title = (item['title'] as String?) ?? '';
              if (title.contains('Furniture') || title.contains('أثاث')) {
                Navigator.pushNamed(context, '/furniture-service');
                return;
              }
              if (title.contains('Express') || title.contains('السريع')) {
                Navigator.pushNamed(context, '/express-delivery');
                return;
              }
              Navigator.pushNamed(
                context,
                '/home-category-details',
                arguments: {'title': title},
              );
            },
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.greyBlue,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: (item['image'] != null && (item['image'] as String).isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(
                          item['image'] as String,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported, color: AppColors.washyBlue),
                        ),
                      )
                    : Icon(
                        (item['icon'] as IconData?) ?? Icons.widgets,
                        color: AppColors.washyBlue,
                        size: 30,
                      ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  item['title'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 11,
                    height: 1.2,
                    color: AppColors.colorTitleBlack,
                  ),
                ),
              )
            ],
          ));
        },
      ),
    );
  }

  /// قسم "طلب سريع" ببطاقتين
  Widget _buildQuickOrderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            AppLocalizations.of(context).t('quick_order'),
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _quickCard(
                  image: 'assets/images/ic_intro_page2.png',
                  title: 'مستعجل؟ اطلب الآن!',
                  subtitle: 'سيقوم موظف التوصيل بأخذ طلبك',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _quickCard(
                  image: 'assets/images/ic_intro_page3.png',
                  title: 'الطلب السريع اكسبرس',
                  subtitle: 'احصل على غسيلك بسرعة مضاعفة',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickCard({required String image, required String title, required String subtitle}) {
    return GestureDetector(
      onTap: () {
        if (title.contains('مستعجل') || title.contains('اطلب') || title.contains('Order')) {
          Navigator.pushNamed(context, '/new-order');
        } else {
          Navigator.pushNamed(context, '/express-delivery');
        }
      },
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16/9,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: AppColors.grey3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorTitleBlack,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 13,
                      color: AppColors.grey2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
    
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
              child: Row(
                children: [
                  const SizedBox(width: 19),
                  const Icon(
                    Icons.search,
                    color: AppColors.colorTextNotSelected,
                    size: 20,
                  ),
                  const SizedBox(width: 19),
                  Text(
                    AppLocalizations.of(context).t('search_hint'),
                    style: const TextStyle(
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
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).t('categories'),
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
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
            mainAxisSize: MainAxisSize.min,
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

              const SizedBox(height: 8),

              // Service Title
              Text(
                service.title,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorTitleBlack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 2),

              // Service Subtitle
              Flexible(
                child: Text(
                  service.subtitle,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 11,
                    color: AppColors.greyDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
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
              Text(
                AppLocalizations.of(context).t('order_now'),
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              if (isHurryModeEnabled) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
