import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// SettingsPage - General app settings
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  bool locationEnabled = true;
  String selectedLanguage = 'العربية';
  String selectedTheme = 'فاتح';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  /// Header with gradient
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
                  'الإعدادات',
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
          // Notifications Section
          _buildSectionCard(
            title: 'الإشعارات',
            icon: Icons.notifications,
            children: [
              _buildSwitchTile(
                title: 'تفعيل الإشعارات',
                subtitle: 'استقبال إشعارات حالة الطلب',
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'الصوت',
                subtitle: 'تشغيل صوت الإشعارات',
                value: soundEnabled,
                onChanged: (value) {
                  setState(() {
                    soundEnabled = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'الاهتزاز',
                subtitle: 'اهتزاز الجهاز عند الإشعار',
                value: vibrationEnabled,
                onChanged: (value) {
                  setState(() {
                    vibrationEnabled = value;
                  });
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Privacy & Location Section
          _buildSectionCard(
            title: 'الخصوصية والموقع',
            icon: Icons.privacy_tip,
            children: [
              _buildSwitchTile(
                title: 'خدمات الموقع',
                subtitle: 'السماح بالوصول للموقع لتحديد العنوان',
                value: locationEnabled,
                onChanged: (value) {
                  setState(() {
                    locationEnabled = value;
                  });
                },
              ),
              _buildNavigationTile(
                title: 'سياسة الخصوصية',
                subtitle: 'اقرأ سياسة الخصوصية الخاصة بنا',
                icon: Icons.policy,
                onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
              ),
              _buildNavigationTile(
                title: 'الشروط والأحكام',
                subtitle: 'شروط استخدام التطبيق',
                icon: Icons.description,
                onTap: () => Navigator.pushNamed(context, '/terms-and-conditions'),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // App Preferences Section
          _buildSectionCard(
            title: 'تفضيلات التطبيق',
            icon: Icons.tune,
            children: [
              _buildSelectionTile(
                title: 'اللغة',
                subtitle: selectedLanguage,
                icon: Icons.language,
                onTap: () => _showLanguageDialog(),
              ),
              _buildSelectionTile(
                title: 'السمة',
                subtitle: selectedTheme,
                icon: Icons.palette,
                onTap: () => _showThemeDialog(),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Account Section
          _buildSectionCard(
            title: 'الحساب',
            icon: Icons.account_circle,
            children: [
              _buildNavigationTile(
                title: 'إعدادات الحساب',
                subtitle: 'تعديل معلومات الحساب الشخصية',
                icon: Icons.person,
                onTap: () => Navigator.pushNamed(context, '/profile-settings'),
              ),
              _buildNavigationTile(
                title: 'إعدادات التذكير',
                subtitle: 'إدارة تذكيرات التقويم',
                icon: Icons.event,
                onTap: () => Navigator.pushNamed(context, '/reminder-settings'),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Support Section
          _buildSectionCard(
            title: 'الدعم والمساعدة',
            icon: Icons.help,
            children: [
              _buildNavigationTile(
                title: 'مركز المساعدة',
                subtitle: 'الأسئلة الشائعة والدعم الفني',
                icon: Icons.help_center,
                onTap: () => Navigator.pushNamed(context, '/get-help'),
              ),
              _buildNavigationTile(
                title: 'اتصل بنا',
                subtitle: 'تواصل مع فريق الدعم',
                icon: Icons.contact_support,
                onTap: () => Navigator.pushNamed(context, '/contact-us'),
              ),
              _buildNavigationTile(
                title: 'شارك مع الأصدقاء',
                subtitle: 'أخبر أصدقاءك عن التطبيق',
                icon: Icons.share,
                onTap: () => Navigator.pushNamed(context, '/share-with-friends'),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // About Section
          _buildSectionCard(
            title: 'حول التطبيق',
            icon: Icons.info,
            children: [
              _buildNavigationTile(
                title: 'حول واشي واش',
                subtitle: 'معلومات عن التطبيق والشركة',
                icon: Icons.info_outline,
                onTap: () => Navigator.pushNamed(context, '/about-us'),
              ),
              _buildInfoTile(
                title: 'إصدار التطبيق',
                subtitle: '1.0.0',
                icon: Icons.smartphone,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section Card Widget
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.washyBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorTitleBlack,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Section Content
          ...children,
        ],
      ),
    );
  }

  /// Switch Tile Widget
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 16,
          color: AppColors.colorTitleBlack,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          color: AppColors.grey2,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.washyGreen,
      ),
    );
  }

  /// Navigation Tile Widget
  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.washyBlue),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 16,
          color: AppColors.colorTitleBlack,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          color: AppColors.grey2,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.grey2,
      ),
      onTap: onTap,
    );
  }

  /// Selection Tile Widget
  Widget _buildSelectionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.washyBlue),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 16,
          color: AppColors.colorTitleBlack,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          color: AppColors.washyBlue,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.grey2,
      ),
      onTap: onTap,
    );
  }

  /// Info Tile Widget
  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey2),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 16,
          color: AppColors.colorTitleBlack,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          color: AppColors.grey2,
        ),
      ),
    );
  }

  // Dialog Methods
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختيار اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              leading: Radio<String>(
                value: 'العربية',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'English',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختيار السمة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('فاتح'),
              leading: Radio<String>(
                value: 'فاتح',
                groupValue: selectedTheme,
                onChanged: (value) {
                  setState(() {
                    selectedTheme = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('داكن'),
              leading: Radio<String>(
                value: 'داكن',
                groupValue: selectedTheme,
                onChanged: (value) {
                  setState(() {
                    selectedTheme = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('تلقائي'),
              leading: Radio<String>(
                value: 'تلقائي',
                groupValue: selectedTheme,
                onChanged: (value) {
                  setState(() {
                    selectedTheme = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

