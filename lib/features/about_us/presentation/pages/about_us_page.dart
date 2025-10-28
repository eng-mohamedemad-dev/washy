import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// AboutUsPage - Simple about us information page
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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

  /// Header with back button and title
  Widget _buildHeader() {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.washyBlue,
            AppColors.washyGreen,
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
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'حول واشي واش',
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

  /// Content with app information
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App Logo/Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.washyBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_laundry_service,
              size: 60,
              color: AppColors.washyBlue,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // App Name
          const Text(
            'واشي واش',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // App Subtitle
          const Text(
            'خدمات الغسيل والتنظيف',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 16,
              color: AppColors.grey2,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // About Description
          _buildInfoCard(
            title: 'من نحن',
            content: 'واشي واش هو تطبيق رائد في مجال خدمات الغسيل والتنظيف في الأردن. نقدم خدمات عالية الجودة للملابس والمنسوجات مع ضمان الجودة والسرعة في التسليم.',
            icon: Icons.info_outline,
          ),
          
          const SizedBox(height: 16),
          
          // Mission
          _buildInfoCard(
            title: 'رسالتنا',
            content: 'نسعى لتوفير أفضل خدمات الغسيل والتنظيف مع الحفاظ على البيئة واستخدام أحدث التقنيات والمواد الصديقة للبيئة.',
            icon: Icons.eco_outlined,
          ),
          
          const SizedBox(height: 16),
          
          // Services
          _buildInfoCard(
            title: 'خدماتنا',
            content: '• غسيل الملابس العادية\n• تنظيف جاف للملابس الحساسة\n• غسيل الأحذية\n• تنظيف السجاد والمفروشات\n• خدمة التوصيل والاستلام',
            icon: Icons.cleaning_services_outlined,
          ),
          
          const SizedBox(height: 32),
          
          // Contact Information
          const Text(
            'معلومات التواصل',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Contact Details
          _buildContactItem(Icons.phone, '+962 6 123 4567'),
          _buildContactItem(Icons.email, 'info@washywash.com'),
          _buildContactItem(Icons.language, 'www.washywash.com'),
          _buildContactItem(Icons.location_on, 'عمان - الأردن'),
          
          const SizedBox(height: 32),
          
          // App Version
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey5,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_android,
                  color: AppColors.grey2,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'إصدار التطبيق: 1.0.0',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    color: AppColors.grey2,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Copyright
          const Text(
            '© 2024 واشي واش. جميع الحقوق محفوظة.',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 12,
              color: AppColors.grey2,
            ),
          ),
        ],
      ),
    );
  }

  /// Information Card Widget
  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 15,
                color: AppColors.greyDark,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Contact Item Widget
  Widget _buildContactItem(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.washyBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.washyBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                color: AppColors.colorTitleBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
