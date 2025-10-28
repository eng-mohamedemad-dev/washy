import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// ShareWithFriendsPage - Share app with friends
class ShareWithFriendsPage extends StatelessWidget {
  const ShareWithFriendsPage({super.key});

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
                  'شارك مع الأصدقاء',
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
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // App Icon & Title
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.washyBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share,
              size: 60,
              color: AppColors.washyBlue,
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'شارك واشي واش مع أصدقائك',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
          
          const SizedBox(height: 12),
          
          const Text(
            'اعطِ أصدقاءك تجربة رائعة في الغسيل والتنظيف',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 16,
              color: AppColors.grey2,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Benefits
          _buildBenefitCard(
            icon: Icons.card_giftcard,
            title: 'احصل على خصم',
            description: 'خصم 10% عند تسجيل صديق جديد',
            color: AppColors.washyGreen,
          ),
          
          const SizedBox(height: 16),
          
          _buildBenefitCard(
            icon: Icons.people,
            title: 'ساعد أصدقاءك',
            description: 'شارك تجربتك الرائعة معهم',
            color: AppColors.washyBlue,
          ),
          
          const SizedBox(height: 16),
          
          _buildBenefitCard(
            icon: Icons.trending_up,
            title: 'اكسب نقاط',
            description: 'اكسب نقاط مع كل صديق ينضم',
            color: AppColors.premiumColor,
          ),
          
          const SizedBox(height: 32),
          
          // Share Message
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.message,
                        color: AppColors.washyBlue,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'رسالة المشاركة',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorTitleBlack,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.grey5,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'مرحباً! أنصحك بتجربة تطبيق واشي واش لخدمات الغسيل والتنظيف. خدمة ممتازة وسريعة! حمّل التطبيق من:\n\nواشي واش - خدمات الغسيل والتنظيف\nتطبيق رقم 1 في الأردن',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 14,
                        color: AppColors.greyDark,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Copy Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _copyMessage(context),
                      icon: const Icon(Icons.copy, size: 20),
                      label: const Text('نسخ الرسالة'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.washyBlue,
                        side: const BorderSide(color: AppColors.washyBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Share Options
          const Text(
            'طرق المشاركة',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.colorTitleBlack,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Share Buttons Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildShareButton(
                icon: Icons.message,
                title: 'رسالة SMS',
                onTap: () => _shareViaSMS(),
              ),
              _buildShareButton(
                icon: Icons.share,
                title: 'مشاركة عامة',
                onTap: () => _shareGeneral(),
              ),
              _buildShareButton(
                icon: Icons.email,
                title: 'بريد إلكتروني',
                onTap: () => _shareViaEmail(),
              ),
              _buildShareButton(
                icon: Icons.more_horiz,
                title: 'المزيد',
                onTap: () => _shareMore(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Benefit Card Widget
  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
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
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorTitleBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      color: AppColors.greyDark,
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

  /// Share Button Widget
  Widget _buildShareButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.washyBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.colorTitleBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Actions
  void _copyMessage(BuildContext context) {
    const message = 'مرحباً! أنصحك بتجربة تطبيق واشي واش لخدمات الغسيل والتنظيف. خدمة ممتازة وسريعة!\n\nواشي واش - خدمات الغسيل والتنظيف\nتطبيق رقم 1 في الأردن';
    
    Clipboard.setData(const ClipboardData(text: message));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الرسالة'),
        backgroundColor: AppColors.washyGreen,
      ),
    );
  }

  void _shareViaSMS() {
    // TODO: Implement SMS sharing
  }

  void _shareGeneral() {
    // TODO: Implement general sharing
  }

  void _shareViaEmail() {
    // TODO: Implement email sharing
  }

  void _shareMore() {
    // TODO: Implement more sharing options
  }
}
