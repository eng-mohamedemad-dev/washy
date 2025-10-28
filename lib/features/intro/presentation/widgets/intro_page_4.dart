import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';

class IntroPage4 extends StatelessWidget {
  const IntroPage4({super.key});

  Future<void> _launchVideo() async {
    final Uri uri = Uri.parse(AppConstants.washyVideoUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently or show toast
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Top spacing like Java version (77dp)
          const SizedBox(height: 77),
          
          // Background + Icon like Java version
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.check_circle_outline,
                size: 80,
                color: AppColors.white,
              ),
            ),
          ),
          
          // Space like Java version (50dp)
          const SizedBox(height: 50),
          
          // Title like Java version
          Text(
            'Receive your clothes',
            textAlign: TextAlign.center,
            style: AppTextStyles.introTitle.copyWith(
              color: AppColors.white,
              height: 1.5,
            ),
          ),
          
          // Space like Java version (16dp = activity_vertical_margin)
          const SizedBox(height: 16),
          
          // Description like Java version
          Text(
            'Perfect cleaning results, toxin-free, fresh smell, feels like new, and be happy because you didn\'t harm our planet in the process!',
            textAlign: TextAlign.center,
            style: AppTextStyles.introDescription.copyWith(
              color: AppColors.white.withOpacity(0.9),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Watch Video button like Java version
          GestureDetector(
            onTap: _launchVideo,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.white, width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    color: AppColors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Watch our Video',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

