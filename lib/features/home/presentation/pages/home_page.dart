import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/core/constants/app_constants.dart';
import 'package:wash_flutter/features/webview/presentation/pages/webview_page.dart';
import 'package:wash_flutter/features/home/domain/entities/home_service.dart';
import 'package:wash_flutter/features/home/data/services/home_api_service.dart';
import 'package:wash_flutter/features/home/data/models/landing_page_response.dart'
    as landing;
import 'package:wash_flutter/features/home/data/models/home_page_response.dart'
    as home;
import 'package:wash_flutter/injection_container.dart' as di;
import 'package:wash_flutter/l10n/app_localizations.dart';
import 'package:wash_flutter/core/config/locale_notifier.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  double basketTotal = 0.0;

  // Network data
  List<landing.BannerItem> _banners = [];
  List<landing.LandingItem> _landingItems = [];
  List<home.HomeCategory> _categories = [];
  bool _isLoading = true;
  late final String _serverBaseUrl;
  // Banner slider state
  late final PageController _bannerController;
  int _bannerIndex = 0;
  // Categories grid state
  late final PageController _categoriesController;
  int _categoriesPageIndex = 0;
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
    _categoriesController = PageController();
    _loadLanding();
    _loadVersion();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bannerController.dispose();
    _categoriesController.dispose();
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

  void _openEcoClean() async {
    try {
      // استخدم الدومين الفعلي المحفوظ (_serverBaseUrl) مثل الجافا
      final root =
          _serverBaseUrl.endsWith('/') ? _serverBaseUrl : '$_serverBaseUrl/';
      final ecoUrl = root + 'ecoclean-mob';
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WebViewPage(
              title: AppLocalizations.of(context).t('what_is_ecoclean'),
              url: ecoUrl,
            ),
          ),
        );
      }
    } catch (_) {
      final root =
          _serverBaseUrl.endsWith('/') ? _serverBaseUrl : '$_serverBaseUrl/';
      final ecoUrl = root + 'ecoclean-mob';
      final uri = Uri.tryParse(ecoUrl);
      if (uri != null) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close,
                          color: AppColors.colorActionBlack),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'شارك مع الأصدقاء\nأخبرهم عنا.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorTitleBlack,
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/ic_invite_friends.png',
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.share,
                      size: 72, color: AppColors.washyBlue),
                ),
                const SizedBox(height: 18),
                _shareButton(
                  title: 'شارك بواسطة فيسبوك',
                  color: AppColors.progressBarBlueColor,
                  onTap: () async {
                    final url = Uri.parse(
                        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(AppConstants.googlePlayUrl)}');
                    Navigator.pop(context);
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),
                const SizedBox(height: 12),
                _shareButton(
                  title: 'شارك بواسطة جي ميل',
                  color: AppColors.colorRedBadge,
                  onTap: () async {
                    final subject = Uri.encodeComponent('WashyWash App');
                    final body = Uri.encodeComponent(
                        'جرّب تطبيق WashyWash: ${AppConstants.googlePlayUrl}');
                    final url =
                        Uri.parse('mailto:?subject=$subject&body=$body');
                    Navigator.pop(context);
                    await launchUrl(url, mode: LaunchMode.platformDefault);
                  },
                ),
                const SizedBox(height: 12),
                _shareButton(
                  title: 'شارك بواسطة الايميل',
                  color: AppColors.washyGreen,
                  onTap: () async {
                    final subject = Uri.encodeComponent('WashyWash App');
                    final body = Uri.encodeComponent(
                        'جرّب تطبيق WashyWash: ${AppConstants.googlePlayUrl}');
                    final url =
                        Uri.parse('mailto:?subject=$subject&body=$body');
                    Navigator.pop(context);
                    await launchUrl(url, mode: LaunchMode.platformDefault);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shareButton(
      {required String title,
      required Color color,
      required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 0,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.colorBackground,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _isLoading ? const SizedBox(height: 220) : _buildBannerSlider(),
                _buildTopCategoriesGrid(),
                const SizedBox(height: 8),
                _buildQuickOrderSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildHurryModeCard(),
          ),
        ],
      ),
      endDrawer: _buildEndDrawer(),
    );
  }

  /// AppBar (ثابت - لا يتحرك مع الشاشة: جرس يسار - شعار واسم - منيو يمين)
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 50, // 4.5 سم تقريباً
      flexibleSpace: Stack(
        children: [
          // الخلفية البيضاء
          Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
          ),
          // التدرج في أول 4 سم من الأعلى
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 30, // 4 سم تقريباً
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 51, 144, 110),
              ),
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      leadingWidth: 56,
      leading: IconButton(
        onPressed: () => Navigator.pushNamed(context, '/notifications'),
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.notifications_none,
              color: Colors.grey[600],
              size: 26,
            ),
            if (notificationCount > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: const BoxDecoration(
                    color: AppColors.colorRedBadge,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      notificationCount > 99 ? '99+' : '$notificationCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo_ww_icon.png',
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 1),
          Image.asset(
            'assets/images/washy_wash_word_white.png',
            height: 14,
            fit: BoxFit.contain,
            color: AppColors.greyDark, // تغيير اللون ليكون مرئي على خلفية بيضاء
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Image.asset(
              'assets/images/ic_burger_icon.png',
              width: 26,
              height: 26,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 10),
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
                  color: i == _bannerIndex
                      ? AppColors.washyGreen
                      : AppColors.grey3,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Hurry Mode card (مطابق لكارت HurryMode_CardView)
  Widget _buildHurryModeCard() {
    if (!isHurryModeEnabled) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 84),
      decoration: BoxDecoration(
        color: AppColors.washyBlue,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'طلب سريع متاح',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 16),
          ],
        ),
      ),
    );
  }

  /// Bottom bar (Basket total + Continue) مطابق لتخطيط XML
  Widget _buildBottomBar() {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(color: AppColors.white, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2)),
      ]),
      child: Row(
        children: [
          // Basket Total
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).t('basket_total'),
                style: const TextStyle(
                  color: AppColors.grey2,
                  fontSize: 14,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'JOD ${basketTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.grey2,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Continue button
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _onOrderNowPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.washyBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context).t('continue_text'),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
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
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? 'English'
                          : 'العربية',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Center(
                child: Image.asset('assets/images/washy_wash_word_white.png',
                    height: 42, fit: BoxFit.contain),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                children: [
                  _drawerNavItem(AppLocalizations.of(context).t('home'),
                      selected: true, onTap: () {
                    Navigator.pop(context);
                  }),
                  _drawerNavItem(AppLocalizations.of(context).t('orders'),
                      onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/orders');
                  }),
                  _drawerNavItem(
                      AppLocalizations.of(context).t('notifications'),
                      onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/notifications');
                  }),
                  _drawerNavItem(AppLocalizations.of(context).t('profile'),
                      onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: OutlinedButton(
                      onPressed: _openEcoClean,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.washyBlue),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                      ),
                      child: Text(
                          AppLocalizations.of(context).t('what_is_ecoclean'),
                          style: const TextStyle(
                              fontSize: 16, color: AppColors.washyBlue)),
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
                    child: Text(
                        '${AppLocalizations.of(context).t('version')} ${_appVersion.isEmpty ? '—' : _appVersion}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: AppColors.grey2)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/terms-and-conditions');
                    },
                    child: Text(AppLocalizations.of(context).t('terms'),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _drawerNavItem(String title,
      {bool selected = false, VoidCallback? onTap}) {
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

  /// شبكة الخدمات المختصرة (14 أيقونة في صفحتين: 8 + 6)
  Widget _buildTopCategoriesGrid() {
    final localizations = AppLocalizations.of(context);
    final allItems = _categories.isNotEmpty
        ? _categories
            .map((e) => {
                  'title': e.title ?? '',
                  'image': _resolveUrl(e.image),
                })
            .toList()
        : [
            // الصف الأول: Clothes, Furniture, Carpet, Car detailing
            {
              'title': localizations.t('clothes'),
              'asset': 'assets/imaes icons/Clothes.jpg'
            },
            {
              'title': localizations.t('furniture'),
              'asset': 'assets/images/Furniture.jpg'
            },
            {
              'title': localizations.t('carpet'),
              'asset': 'assets/imaes icons/Carpet.jpg'
            },
            {
              'title': localizations.t('car_detailing'),
              'asset': 'assets/imaes icons/Car detailing.jpg'
            },
            // الصف الثاني: House cleaning, Shoes, Tailoring, Offers!
            {
              'title': localizations.t('house_cleaning'),
              'asset': 'assets/imaes icons/House Cleaning.jpg'
            },
            {
              'title': localizations.t('shoes'),
              'asset': 'assets/imaes icons/Shoes.jpg'
            },
            {
              'title': localizations.t('tailoring'),
              'asset': 'assets/images/Tailoring.jpg'
            },
            {
              'title': localizations.t('offers'),
              'asset': 'assets/imaes icons/Offers!.jpg'
            },
            // الصفحة الثانية (6 عناصر)
            {
              'title': localizations.t('dresses'),
              'asset': 'assets/imaes icons/Dresses.jpg'
            },
            {
              'title': localizations.t('bags'),
              'asset': 'assets/imaes icons/Bags.jpg'
            },
            {
              'title': localizations.t('wash_and_fold'),
              'asset': 'assets/imaes icons/Wash abd Fold Per Kilo.jpg'
            },
            {
              'title': localizations.t('bedding'),
              'asset': 'assets/imaes icons/Bedding.jpg'
            },
            {
              'title': localizations.t('curtains_cleaning'),
              'asset': 'assets/imaes icons/Cutains Cleaning.jpg'
            },
            {
              'title': localizations.t('ecoclean'),
              'asset': 'assets/imaes icons/Ecoclean.jpg'
            },
          ];

    // تقسيم العناصر إلى صفحتين
    final page1Items = allItems.take(8).toList(); // الصفحة الأولى: 8 عناصر
    final page2Items =
        allItems.skip(8).take(6).toList(); // الصفحة الثانية: 6 عناصر
    final totalPages = 2;

    Widget _buildCategoryItem(item) {
      return GestureDetector(
        onTap: () {
          final String title = (item['title'] as String?) ?? '';
          final String asset = (item['asset'] as String?) ?? '';

          // التحقق من اسم الملف للتفريق بين الخدمات
          if (asset.contains('Furniture.jpg')) {
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.greyBlue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: (item['image'] != null &&
                      (item['image'] as String).isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        item['image'] as String,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(
                            Icons.image_not_supported,
                            color: AppColors.washyBlue,
                            size: 24),
                      ),
                    )
                  : (item['asset'] != null)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Transform.scale(
                            scale: (item['asset'] as String).endsWith('.jpg')
                                ? 1.5
                                : 1.0,
                            child: Image.asset(
                              item['asset'] as String,
                              fit: (item['asset'] as String).endsWith('.jpg')
                                  ? BoxFit.cover
                                  : BoxFit.contain,
                              errorBuilder: (c, e, s) => const Icon(
                                  Icons.image_not_supported,
                                  color: AppColors.washyBlue,
                                  size: 24),
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.widgets,
                          color: AppColors.washyBlue,
                          size: 24,
                        ),
            ),
            const SizedBox(height: 10),
            Text(
              item['title'] as String,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                height: 1.2,
                color: AppColors.colorTitleBlack,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      );
    }

    Widget _buildCategoryGrid(List items) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          return _buildCategoryItem(items[index]);
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: PageView.builder(
              controller: _categoriesController,
              itemCount: totalPages,
              onPageChanged: (index) =>
                  setState(() => _categoriesPageIndex = index),
              itemBuilder: (context, pageIndex) {
                if (pageIndex == 0) {
                  return _buildCategoryGrid(page1Items);
                } else {
                  return _buildCategoryGrid(page2Items);
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPages,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: i == _categoriesPageIndex ? 9 : 7,
                height: i == _categoriesPageIndex ? 9 : 7,
                margin: const EdgeInsets.symmetric(horizontal: 3.5),
                decoration: BoxDecoration(
                  color: i == _categoriesPageIndex
                      ? AppColors.washyGreen
                      : AppColors.grey3,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// قسم "طلب سريع" ببطاقتين
  Widget _buildQuickOrderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Order',
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
                  image: 'assets/images/ic_express_delivery.png',
                  title: 'Skip item selection',
                  subtitle: 'Our Laundry agent will come get your laundry',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _quickCard(
                  image: 'assets/images/ic_skip_new.png',
                  title: 'Express Delivery',
                  subtitle: 'Receive your laundry twice as fast',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickCard(
      {required String image,
      required String title,
      required String subtitle}) {
    return GestureDetector(
        onTap: () {
          if (title.contains('مستعجل') ||
              title.contains('اطلب') ||
              title.contains('Order')) {
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
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: AppColors.grey3),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorTitleBlack,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 13,
                        color: AppColors.grey2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
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
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.search,
                    color: AppColors.colorTextNotSelected,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).t('search_hint'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 14,
                        color: AppColors.colorTextNotSelected,
                      ),
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
