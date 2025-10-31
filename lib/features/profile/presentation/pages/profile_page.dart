import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/features/profile/domain/entities/profile_item.dart';
import 'package:wash_flutter/features/profile/domain/entities/profile_item_type.dart';
import 'package:wash_flutter/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'dart:io' show Platform;

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
    _showShareDialog();
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
                      child: const Icon(Icons.close, color: AppColors.colorActionBlack),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'شارك مع الأصدقاء\nأخبرهم عنا.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                  errorBuilder: (c, e, s) => const Icon(Icons.share, size: 72, color: AppColors.washyBlue),
                ),
                const SizedBox(height: 18),
                _shareButton(
                  title: 'شارك بواسطة فيسبوك',
                  color: AppColors.progressBarBlueColor,
                  onTap: () async {
                    Navigator.pop(context);
                    _openFacebookChooser();
                  },
                ),
                const SizedBox(height: 12),
                _shareButton(
                  title: 'شارك بواسطة جي ميل',
                  color: AppColors.colorRedBadge,
                  onTap: () async {
                    Navigator.pop(context);
                    await _openGmailCompose(
                      subject: 'WashyWash App',
                      body: 'واشيواش تقدم إكو كلين، تقنية حديثة لتنظيف\nالملابس بديلة الدراي كلين.\n\n${AppConstants.googlePlayUrl}',
                    );
                  },
                ),
                const SizedBox(height: 12),
                _shareButton(
                  title: 'شارك بواسطة الايميل',
                  color: AppColors.washyGreen,
                  onTap: () async {
                    Navigator.pop(context);
                    _openInlineEmailComposer();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shareButton({required String title, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
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

  void _openInlineEmailComposer() {
    final TextEditingController toController = TextEditingController();
    final TextEditingController subjectController = TextEditingController(text: 'WashyWash App');
    final TextEditingController bodyController = TextEditingController(
      text: 'واشيواش تقدم إكو كلين، تقنية حديثة لتنظيف\nالملابس بديلة الدراي كلين.\n\n${AppConstants.googlePlayUrl}',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.colorBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.colorNewTextNotSelected,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const Text(
                'إنشاء رسالة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: AppColors.colorTitleBlack,
                ),
              ),
              const SizedBox(height: 18),
              _emailField(label: 'إلى', controller: toController, hint: 'example@mail.com'),
              const SizedBox(height: 14),
              _emailField(label: 'العنوان', controller: subjectController, hint: ''),
              const SizedBox(height: 14),
              _emailMultiline(label: 'المحتوى', controller: bodyController),
              const SizedBox(height: 18),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.washyBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  onPressed: () async {
                    final to = toController.text.trim();
                    final subject = subjectController.text.trim();
                    final body = bodyController.text.trim();
                    Navigator.pop(context);
                    if (to.isNotEmpty) {
                      await _openGmailCompose(to: to, subject: subject, body: body);
                    } else {
                      await _openGmailCompose(subject: subject, body: body);
                    }
                  },
                  child: const Text('إرسال', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _emailField({required String label, required TextEditingController controller, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: AppColors.colorTextNotSelected,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.progressBarColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.progressBarColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.washyBlue)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _emailMultiline({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: AppColors.colorTextNotSelected,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          maxLines: 8,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.progressBarColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.progressBarColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.washyBlue)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }

  Future<void> _openGmailCompose({String? to, required String subject, required String body}) async {
    if (Platform.isAndroid) {
      try {
        final intent = AndroidIntent(
          action: 'android.intent.action.SEND',
          type: 'message/rfc822',
          package: 'com.google.android.gm',
          arguments: {
            'android.intent.extra.SUBJECT': subject,
            'android.intent.extra.TEXT': body,
            if (to != null && to.isNotEmpty) 'android.intent.extra.EMAIL': [to],
          },
        );
        await intent.launch();
        return;
      } catch (_) {}
    }
    // Fallback
    final encodedSubject = Uri.encodeComponent(subject);
    final encodedBody = Uri.encodeComponent(body);
    final uri = to != null && to.isNotEmpty
        ? Uri.parse('mailto:$to?subject=$encodedSubject&body=$encodedBody')
        : Uri.parse('mailto:?subject=$encodedSubject&body=$encodedBody');
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  void _openFacebookChooser() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _shareButton(
                  title: 'Facebook',
                  color: AppColors.progressBarBlueColor,
                  onTap: () async {
                    Navigator.pop(context);
                    final ok = await _shareToFacebookPackage('com.facebook.katana');
                    if (!ok) {
                      await _fallbackFacebookSharer();
                    }
                  },
                ),
                const SizedBox(height: 10),
                _shareButton(
                  title: 'Facebook Lite',
                  color: AppColors.progressBarBlueColor,
                  onTap: () async {
                    Navigator.pop(context);
                    final ok = await _shareToFacebookPackage('com.facebook.lite');
                    if (!ok) {
                      await _fallbackFacebookSharer();
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _fallbackFacebookSharer();
                  },
                  child: const Text('فتح في المتصفح'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _shareToFacebookPackage(String package) async {
    if (!Platform.isAndroid) return false;
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.SEND',
        type: 'text/plain',
        package: package,
        arguments: {
          'android.intent.extra.TEXT': 'WashyWash - أفضل خدمة غسيل\n${AppConstants.googlePlayUrl}',
        },
      );
      await intent.launch();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _fallbackFacebookSharer() async {
    final url = Uri.parse('https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(AppConstants.googlePlayUrl)}&quote=${Uri.encodeComponent('WashyWash - أفضل خدمة غسيل')}');
    await launchUrl(url, mode: LaunchMode.externalApplication);
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
