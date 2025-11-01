import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// WelcomePage - Welcome and onboarding screen
/// Java: WelcomeActivity receives USER_NAME_KEY and displays it
class WelcomePage extends StatefulWidget {
  final String? userName;
  final bool isFromNameRegistration;
  
  const WelcomePage({
    super.key,
    this.userName,
    this.isFromNameRegistration = false,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.washyBlue,
              AppColors.washyGreen,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildHeader(),
                Expanded(child: _buildContent()),
                _buildActionButtons(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header with logo
  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // App Logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
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
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              letterSpacing: 2,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Tagline
          const Text(
            'خدمات الغسيل والتنظيف',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 18,
              color: AppColors.white,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  /// Content section
  Widget _buildContent() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome Text
            const Text(
              'أهلاً وسهلاً بك!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Description
            const Text(
              'احصل على خدمات الغسيل والتنظيف الأفضل في الأردن\nمع التوصيل المجاني من وإلى منزلك',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 18,
                color: AppColors.white,
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Features
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeature(
                  icon: Icons.schedule,
                  title: '24 ساعة',
                  subtitle: 'خدمة سريعة',
                ),
                _buildFeature(
                  icon: Icons.local_shipping,
                  title: 'توصيل مجاني',
                  subtitle: 'من وإلى منزلك',
                ),
                _buildFeature(
                  icon: Icons.star,
                  title: 'جودة عالية',
                  subtitle: 'خدمة متميزة',
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Statistics
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(number: '10K+', label: 'عميل سعيد'),
                  _StatItem(number: '50K+', label: 'طلب مكتمل'),
                  _StatItem(number: '4.9', label: 'تقييم'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Feature Widget
  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 28,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        
        const SizedBox(height: 4),
        
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 12,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  /// Action Buttons
  Widget _buildActionButtons() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Get Started Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27.5),
                ),
              ),
              child: const Text(
                'ابدأ الآن',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.washyBlue,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Sign In Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton(
              onPressed: _onSignIn,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.white, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27.5),
                ),
              ),
              child: const Text(
                'لديك حساب؟ سجل دخول',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Actions
  void _onGetStarted() {
    Navigator.pushReplacementNamed(context, '/intro');
  }

  void _onSignIn() {
    Navigator.pushReplacementNamed(context, '/login');
  }
}

/// Statistics Item Widget
class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 12,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}



