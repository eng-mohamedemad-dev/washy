import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image like Java version (matches fragment_intro_page1.xml)
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 36,
              left: 16,
              right: 16,
            ),
            child: Image.asset(
              'assets/images/background_intro_page1.png',
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ),
        ),

        // Content like Java version (scrollable to avoid overflow on small screens)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top spacing like Java version (77dp)
                const SizedBox(height: 77),

                // Icon like Java version (160dp × 160dp, matches fragment_intro_page1.xml)
              Image.asset(
                  'assets/images/ic_intro_page1.png',
                width: 120,
                height: 120,
                  errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                    Icons.local_laundry_service_outlined,
                    size: 60,
                      color: AppColors.white,
                    ),
                  ),
                ),

                // Space like Java version (50dp)
                const SizedBox(height: 50),

                // Title like Java version (matches fragment_intro_page1.xml)
                Text(
                  'نحن نجعل حياتك أسهل',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.introTitle.copyWith(
                    color: AppColors.colorTitleBlack, // #333333
                    fontSize: 23,
                    height: 1.5,
                  ),
                ),

                // Space like Java version (16dp = activity_vertical_margin)
                const SizedBox(height: 16),

                // Description with extra horizontal padding
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'جميع احتياجاتك للتنظيف والكوي متوفرة بين يديك',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.introDescription.copyWith(
                      color: AppColors.colorTextNotSelected, // #8c96a8
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
