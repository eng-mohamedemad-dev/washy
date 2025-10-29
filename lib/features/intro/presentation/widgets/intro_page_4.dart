import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';

class IntroPage4 extends StatelessWidget {
  const IntroPage4({super.key});

  void _launchVideo() async {
    try {
      // Use the exact URL from Java: https://youtu.be/coHI9wb7KgM
      final videoUrl = AppConstants.washyVideoUrl;

      print('[Intro] Launching video: $videoUrl');

      final Uri uri = Uri.parse(videoUrl);

      // Launch URL directly - same as Java Intent.ACTION_VIEW
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        print('[Intro] Launch failed, trying alternative URL');
        // Try alternative YouTube URL format
        final altUrl = 'https://www.youtube.com/watch?v=coHI9wb7KgM';
        await launchUrl(
          Uri.parse(altUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print('[Intro] Error launching video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image like Java version (matches fragment_intro_page4.xml)
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 36,
              left: 16,
              right: 16,
            ),
            child: Image.asset(
              'assets/images/background_intro_page4.png',
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
              // Icon like Java version (168dp × 160dp, marginTop 50dp, matches fragment_intro_page4.xml)
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/images/ic_intro_page4.png',
                  width: 168,
                  height: 160,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 168,
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              // Space like Java version (50dp)
              const SizedBox(height: 50),

              // Title like Java version (matches fragment_intro_page4.xml - marginTop 30dp)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'استلم طلبك',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.introTitle.copyWith(
                    color: AppColors.colorTitleBlack, // #333333
                    fontSize: 23,
                    height: 1.5,
                  ),
                ),
              ),

              // Space like Java version (16dp = activity_vertical_margin)
              const SizedBox(height: 16),

              // Description like Java version (from image with 30dp margins)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'نتيجة وجودة رائعة من دون استخدام مواد ضارة للبيئة!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.introDescription.copyWith(
                    color: AppColors.colorTextNotSelected, // #8c96a8
                    fontSize: 17,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Watch Video button like Java version (simple text with arrow)
              GestureDetector(
                onTap: _launchVideo,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'شاهد الفيديو',
                      style: TextStyle(
                        color: AppColors.washyBlue, // washy_blue_color
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.washyBlue,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
