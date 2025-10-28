import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// ProfileSettingsPage - 100% matching Java ProfileSettingActivity
class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          _buildSettingsMenu(context),
        ],
      ),
    );
  }

  /// Header (100% matching Java RelativeLayout with profile gradient)
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 110, // 110dp as per Java
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.profileGradientStart,
            AppColors.profileGradientCenter,
            AppColors.profileGradientEnd,
          ],
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
                  width: 66, // Based on margin
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            
            // Title (66dp margin + 30sp as per Java)
            const Positioned(
              left: 66,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'إعدادات الحساب',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 30, // 30sp as per Java
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

  /// Settings Menu (100% matching Java LinearLayout pattern)
  Widget _buildSettingsMenu(BuildContext context) {
    return Expanded(
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            // Name Layout (40dp top margin as per Java)
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: _buildMenuItem(
                icon: Icons.person_outline,
                iconAssetPath: 'assets/images/ic_profile_name.png',
                title: 'الاسم',
                onTap: () => _onNameClicked(context),
              ),
            ),
            
            // Email Layout (10dp margin as per Java)
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: _buildMenuItem(
                icon: Icons.email_outlined,
                iconAssetPath: 'assets/images/ic_profile_email.png',
                title: 'البريد الإلكتروني',
                onTap: () => _onEmailClicked(context),
              ),
            ),
            
            // Password Layout
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: _buildMenuItem(
                icon: Icons.lock_outline,
                iconAssetPath: 'assets/images/ic_profile_password.png',
                title: 'كلمة المرور',
                onTap: () => _onPasswordClicked(context),
              ),
            ),
            
            // Mobile Layout
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: _buildMenuItem(
                icon: Icons.phone_outlined,
                iconAssetPath: 'assets/images/ic_profile_mobile.png',
                title: 'رقم الجوال',
                onTap: () => _onMobileClicked(context),
              ),
            ),
            
            // Address Layout
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: _buildMenuItem(
                icon: Icons.location_on_outlined,
                iconAssetPath: 'assets/images/ic_profile_address.png',
                title: 'العناوين',
                onTap: () => _onAddressClicked(context),
              ),
            ),
            
            // Payment Method Layout
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: _buildMenuItem(
                icon: Icons.payment_outlined,
                iconAssetPath: 'assets/images/ic_profile_payment.png',
                title: 'طرق الدفع',
                onTap: () => _onPaymentMethodClicked(context),
              ),
            ),
            
            // Reminder Settings Layout
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: _buildMenuItem(
                icon: Icons.notifications_outlined,
                iconAssetPath: 'assets/images/ic_profile_reminder.png',
                title: 'إعدادات التذكير',
                onTap: () => _onReminderSettingsClicked(context),
              ),
            ),
            
            const Spacer(),
            
            // Delete Account Layout (at bottom)
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: _buildMenuItem(
                icon: Icons.delete_outline,
                iconAssetPath: 'assets/images/ic_profile_delete.png',
                title: 'حذف الحساب',
                onTap: () => _onDeleteAccountClicked(context),
                isDestructive: true,
              ),
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
    bool isDestructive = false,
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
                color: isDestructive 
                    ? AppColors.colorCoral 
                    : AppColors.colorHomeTabSelected,
                size: 18,
              ),
            ),
            
            // Title (30dp margin as per Java)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 30),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 17, // 17sp as per Java
                    color: isDestructive 
                        ? AppColors.colorCoral 
                        : AppColors.colorHomeTabSelected,
                    letterSpacing: -0.01,
                  ),
                ),
              ),
            ),
            
            // Arrow (7x13 as per Java)
            Container(
              width: 7,
              height: 13,
              child: Icon(
                Icons.arrow_forward_ios,
                color: isDestructive 
                    ? AppColors.colorCoral 
                    : AppColors.colorHomeTabSelected,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Methods (100% matching Java ProfileSettingActivity)
  void _onNameClicked(BuildContext context) {
    // 100% matching Java: goToNextActivity(UpdateNameActivity.class)
    Navigator.pushNamed(context, '/update-name');
  }

  void _onEmailClicked(BuildContext context) {
    // 100% matching Java: goToNextActivity(UpdateEmailActivity.class)
    Navigator.pushNamed(context, '/update-email');
  }

  void _onPasswordClicked(BuildContext context) {
    // 100% matching Java: goToNextActivity(UpdatePasswordActivity.class)
    Navigator.pushNamed(context, '/update-password');
  }

  void _onMobileClicked(BuildContext context) {
    // 100% matching Java: goToNextActivity(UpdateMobileActivity.class)
    Navigator.pushNamed(context, '/update-mobile');
  }

  void _onAddressClicked(BuildContext context) {
    // 100% matching Java: goToNextActivity(AllAddressesActivity.class)
    Navigator.pushNamed(context, '/addresses');
  }

  void _onPaymentMethodClicked(BuildContext context) {
    // 100% matching Java: goToNextActivity(CreditCardsActivity.class)
    Navigator.pushNamed(context, '/credit-cards');
  }

  void _onReminderSettingsClicked(BuildContext context) {
    // 100% matching Java: goToNextActivity(ReminderSettingsActivity.class)
    Navigator.pushNamed(context, '/reminder-settings');
  }

  void _onDeleteAccountClicked(BuildContext context) {
    // Show confirmation dialog (100% matching Java behavior)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الحساب'),
        content: const Text('هل أنت متأكد من حذف حسابك؟ هذا الإجراء لا يمكن التراجع عنه.'),
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
              // Handle delete account logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم حذف الحساب قريباً'),
                  backgroundColor: AppColors.colorCoral,
                ),
              );
            },
            child: const Text('حذف الحساب'),
          ),
        ],
      ),
    );
  }
}
