import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

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
                Icons.eco_outlined,
                size: 80,
                color: AppColors.white,
              ),
            ),
          ),
          
          // Space like Java version (50dp)
          const SizedBox(height: 50),
          
          // Title like Java version
          Text(
            'A cleaner greener wash',
            textAlign: TextAlign.center,
            style: AppTextStyles.introTitle.copyWith(
              color: AppColors.white,
              height: 1.5,
            ),
          ),
          
          // Space like Java version (16dp = activity_vertical_margin)
          const SizedBox(height: 16),
          
          // Description with highlighted EcoClean like Java version
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.introDescription.copyWith(
                color: AppColors.white.withOpacity(0.9),
              ),
              children: const [
                TextSpan(text: 'We replaced traditional dry-clean with the new and improved '),
                TextSpan(
                  text: 'EcoClean',
                  style: TextStyle(
                    color: AppColors.colorGreenButton, // Green highlight like Java version
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: ' technology, providing YOU with the best laundry experience worldwide.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

