import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// GetHelpPage - 100% matching Java GetHelpActivity
class GetHelpPage extends StatelessWidget {
  const GetHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          _buildMenuItems(context),
        ],
      ),
    );
  }

  /// Header (100% matching Java Header_RelativeLayout)
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 86,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gradientStart,
            AppColors.gradientCenter,
            AppColors.gradientEnd,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Back Button (80x60 as per Java)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 80,
                  height: 60,
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            
            // Title (66dp margin as per Java)
            const Positioned(
              left: 66,
              top: 10,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'المساعدة',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 28, // 28sp as per Java
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Menu Items (100% matching Java RelativeLayouts)
  Widget _buildMenuItems(BuildContext context) {
    return Expanded(
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            // Our Process Item (40dp top margin + 50dp height as per Java)
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: _buildMenuItem(
                icon: Icons.info_outline,
                iconAssetPath: 'assets/images/ic_our_process.png',
                title: 'كيف نعمل',
                onTap: () => _onOurProcessClicked(context),
              ),
            ),
            
            // FAQ Item (50dp height as per Java)
            _buildMenuItem(
              icon: Icons.help_outline,
              iconAssetPath: 'assets/images/ic_faq.png',
              title: 'الأسئلة الشائعة',
              onTap: () => _onFAQClicked(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Menu Item Widget (100% matching Java RelativeLayout pattern)
  Widget _buildMenuItem({
    required IconData icon,
    required String iconAssetPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50, // 50dp as per Java
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            // Icon (20x18 as per Java)
            Container(
              width: 20,
              height: 18,
              child: Icon(
                icon,
                color: AppColors.colorHomeTabSelected,
                size: 18,
              ),
            ),
            
            // Title (30dp margin as per Java)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 30),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 17, // 17sp as per Java
                    color: AppColors.colorHomeTabSelected,
                  ),
                ),
              ),
            ),
            
            // Arrow (7x13 as per Java)
            Container(
              width: 7,
              height: 13,
              child: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.colorHomeTabSelected,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Methods (100% matching Java GetHelpActivity)
  void _onOurProcessClicked(BuildContext context) {
    // 100% matching Java: goToNextActivity(IntroActivity.class)
    Navigator.pushNamed(context, '/intro');
  }

  void _onFAQClicked(BuildContext context) {
    // 100% matching Java: goToNextActivity(FAQActivity.class)
    Navigator.pushNamed(context, '/faq');
  }
}



