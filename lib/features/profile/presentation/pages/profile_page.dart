import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/features/profile/domain/entities/profile_item.dart';
import 'package:wash_flutter/features/profile/domain/entities/profile_item_type.dart';

/// ProfilePage - 100% matching Java ProfileActivity
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  
  // Mock data - should come from session/auth state
  bool isUserLoggedIn = true;
  String userName = "أحمد محمد";
  String userBalance = "رصيدك: 45.50 ريال";
  int notificationCount = 3;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startProfileAnimation();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _bounceAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceInOut,
    );
  }

  void _startProfileAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: _buildProfileList(),
          ),
        ],
      ),
    );
  }

  /// Profile Header (matching Java ProfileHeader_RelativeLayout)
  Widget _buildProfileHeader() {
    return Container(
      height: 197,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_profile_header.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Back Icon (disabled as per Java)
          Positioned(
            top: 35,
            left: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: 24,
              ),
            ),
          ),
          
          // Notification Badge (if user logged in)
          if (isUserLoggedIn)
            Positioned(
              top: 25,
              right: 20,
              child: GestureDetector(
                onTap: _onNotificationTapped,
                child: SizedBox(
                  width: 28,
                  height: 42,
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 0,
                        top: 11,
                        child: Icon(
                          Icons.notifications_outlined,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppColors.colorRedBadge,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                notificationCount.toString(),
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 11.7,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Profile Icon (116x95 as per Java)
          Positioned(
            left: 26,
            top: 70,
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.5 + (_bounceAnimation.value * 0.5),
                  child: Container(
                    width: 116,
                    height: 95,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/ic_profile_header_icon.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Hi There Text (30sp as per Java)
          Positioned(
            top: 55,
            left: 144, // 26 + 116 + 2 as per Java layout
            child: const Text(
              'مرحباً',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.white,
                fontSize: 30,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          
          // User Name (19sp as per Java)
          Positioned(
            top: 90, // Below HiThere_TextView
            left: 144,
            child: Text(
              userName,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.white,
                fontSize: 19,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          
          // Balance Text (15sp, yellow color as per Java)
          Positioned(
            top: 116, // Below Name_TextView + 4dp margin
            left: 144,
            child: Text(
              userBalance,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.colorYellowBalance,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Profile List (matching Java ProfileRecyclerView)
  Widget _buildProfileList() {
    final profileItems = _getProfilePageData();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: profileItems.length,
      itemBuilder: (context, index) {
        return _buildProfileItem(profileItems[index]);
      },
    );
  }

  /// Profile Item Widget (matching Java profile item row)
  Widget _buildProfileItem(ProfileItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.washyBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            item.iconData,
            color: AppColors.washyBlue,
            size: 22,
          ),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.colorTitleBlack,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.grey2,
          size: 16,
        ),
        onTap: () => _handleProfileClick(item),
      ),
    );
  }

  /// Get Profile Page Data (100% matching Java DataPool.getProfilePageData)
  List<ProfileItem> _getProfilePageData() {
    final List<ProfileItem> profileItems = [];

    // Get Help (always shown)
    profileItems.add(const ProfileItem(
      title: 'المساعدة',
      profileItemType: ProfileItemType.getHelp,
      iconData: Icons.help_outline,
      iconAssetPath: 'assets/images/ic_profile_our_process.png',
    ));

    // Notifications (only if logged in)
    if (isUserLoggedIn) {
      profileItems.add(const ProfileItem(
        title: 'الإشعارات',
        profileItemType: ProfileItemType.notification,
        iconData: Icons.notifications_outlined,
        iconAssetPath: 'assets/images/ic_green_notification.png',
      ));
    }

    // Share with Friends (always shown)
    profileItems.add(const ProfileItem(
      title: 'شارك مع الأصدقاء',
      profileItemType: ProfileItemType.shareWithFriends,
      iconData: Icons.share_outlined,
      iconAssetPath: 'assets/images/ic_profile_share.png',
    ));

    // Contact Us (always shown, matching Java DataPool logic)
    profileItems.add(const ProfileItem(
      title: 'اتصل بنا',
      profileItemType: ProfileItemType.contactUs,
      iconData: Icons.contact_support_outlined,
      iconAssetPath: 'assets/images/ic_contact_support.png',
    ));

    // Profile Settings (only if logged in)
    if (isUserLoggedIn) {
      profileItems.add(const ProfileItem(
        title: 'إعدادات الحساب',
        profileItemType: ProfileItemType.profileSettings,
        iconData: Icons.settings_outlined,
        iconAssetPath: 'assets/images/ic_profile_settings.png',
      ));
    }

    // Logout/Login
    if (isUserLoggedIn) {
      profileItems.add(const ProfileItem(
        title: 'تسجيل خروج',
        profileItemType: ProfileItemType.logout,
        iconData: Icons.logout,
        iconAssetPath: 'assets/images/ic_profile_logout.png',
      ));
    } else {
      profileItems.add(const ProfileItem(
        title: 'تسجيل دخول',
        profileItemType: ProfileItemType.login,
        iconData: Icons.login,
        iconAssetPath: 'assets/images/ic_profile_logout.png',
      ));
    }

    return profileItems;
  }

  /// Handle Profile Item Click (100% matching Java handleProfileClick)
  void _handleProfileClick(ProfileItem profileItem) {
    switch (profileItem.profileItemType) {
      case ProfileItemType.getHelp:
        _navigateToGetHelp();
        break;
      case ProfileItemType.shareWithFriends:
        _handleShareWithFriends();
        break;
      case ProfileItemType.feedBack:
        _navigateToFeedback();
        break;
      case ProfileItemType.profileSettings:
        _navigateToProfileSettings();
        break;
      case ProfileItemType.logout:
        _handleLogout();
        break;
      case ProfileItemType.login:
        _handleLogin();
        break;
      case ProfileItemType.notification:
        _navigateToNotifications();
        break;
      case ProfileItemType.contactUs:
        _navigateToContactUs();
        break;
    }
  }

  // Navigation methods (matching Java ProfileActivity)
  void _navigateToGetHelp() {
    Navigator.pushNamed(context, '/get-help');
  }

  void _navigateToFeedback() {
    Navigator.pushNamed(context, '/feedback');
  }

  void _navigateToProfileSettings() {
    Navigator.pushNamed(context, '/profile-settings');
  }

  void _navigateToNotifications() {
    Navigator.pushNamed(context, '/notifications');
  }

  void _navigateToContactUs() {
    Navigator.pushNamed(context, '/contact-us');
  }

  void _onNotificationTapped() {
    _navigateToNotifications();
  }

  // Action methods
  void _handleShareWithFriends() {
    // Show share dialog (matching Java ShareWithFriendsDialog)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('شارك مع الأصدقاء'),
        content: const Text('شارك تطبيق واشي واش مع أصدقائك'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement share functionality
            },
            child: const Text('شارك'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    // Show logout dialog (matching Java LogoutDialog)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل خروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorCoral,
            ),
            onPressed: () {
              Navigator.pop(context);
              // Implement logout functionality
              setState(() {
                isUserLoggedIn = false;
              });
            },
            child: const Text('تسجيل خروج'),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    // Navigate to login (matching Java NavigationManager.navigateToLoginFromHomePage)
    Navigator.pushNamed(context, '/login');
  }
}
