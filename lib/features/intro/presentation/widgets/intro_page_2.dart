import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image like Java version (matches fragment_intro_page2.xml)
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 100,
              left: 16,
              right: 16,
            ),
            child: Image.asset(
              'assets/images/background_intro_page2.png',
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ),
        ),

        // Content like Java version
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              // Top spacing like Java version (77dp)
              const SizedBox(height: 77),

              // Icon like Java version (160dp × 160dp, matches fragment_intro_page2.xml)
              Image.asset(
                'assets/images/ic_intro_page2.png',
                width: 160,
                height: 160,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    size: 80,
                    color: AppColors.white,
                  ),
                ),
              ),

              // Space like Java version (50dp)
              const SizedBox(height: 50),

              // Title like Java version (matches fragment_intro_page2.xml)
              Text(
                'بكل بساطة قم بوضع طلب',
                textAlign: TextAlign.center,
                style: AppTextStyles.introTitle.copyWith(
                  color: AppColors.colorTitleBlack, // #333333
                  fontSize: 20,
                  height: 1.5,
                ),
              ),

              // Space like Java version (16dp = activity_vertical_margin)
              const SizedBox(height: 16),

              // Description like Java version (from image with 30dp margins)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'ليس عليك سوى تحديد الموقع والوقت و سوف نأتي إليك',
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
      ],
    );
  }
}
