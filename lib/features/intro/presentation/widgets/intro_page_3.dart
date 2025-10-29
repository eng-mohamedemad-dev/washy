import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image like Java version (matches fragment_intro_page3.xml)
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 100,
              left: 16,
              right: 16,
            ),
            child: Image.asset(
              'assets/images/background_intro_page3.png',
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ),
        ),

        // Content like Java version
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top spacing like Java version (77dp)
              const SizedBox(height: 77),

              // Icon like Java version (173dp × 160dp, matches fragment_intro_page3.xml)
              Image.asset(
                'assets/images/ic_intro_page3.png',
                width: 180,
                height: 180,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 173,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.eco_outlined,
                    size: 80,
                    color: AppColors.white,
                  ),
                ),
              ),

              // Space like Java version (50dp)
              const SizedBox(height: 50),

              // Title like Java version (matches fragment_intro_page3.xml)
              Text(
                'نظافة لنا و للبيئة كذلك',
                textAlign: TextAlign.center,
                style: AppTextStyles.introTitle.copyWith(
                  color: AppColors.colorTitleBlack, // #333333
                  fontSize: 23,
                  height: 1.5,
                ),
              ),

              // Space like Java version (16dp = activity_vertical_margin)
              const SizedBox(height: 16),

              // Description with highlighted EcoClean like Java version (from image with 30dp margins)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.introDescription.copyWith(
                      color: AppColors.colorTextNotSelected, // #8c96a8
                      fontSize: 16,
                    ),
                    children: [
                      const TextSpan(
                          text:
                              'حدثنا نظام الدراي كلين وأصبح اكو كلين. أحدث نظام تنظيف متوفر عالميا بنتائج تنظيف أفضل و باستخدام مواد صديقه للبيئة'),
                      // TextSpan(
                      //   text: 'إكو كلين',
                      //   style: TextStyle(
                      //     color: AppColors.colorGreenButton, // #92e068 (green)
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // const TextSpan(
                      //     text:
                      //         '. أحدث نظام تنظيف متوفر عالمياً بنتائج تنظيف أفضل و باستخدام مواد صديقة للبيئة'),
                    ],
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
