import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

/// Text styles used throughout the app (100% Matching Java styles.xml)
class AppTextStyles {
  AppTextStyles._();

  // Base font family (from Android theme)
  static const String fontFamily = 'SourceSansPro'; // from @font/source_sans_pro

  // Text Styles from Java styles.xml (UiTestTextView)
  static const TextStyle uiTestTextView = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.colorTitleBlack,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        color: AppColors.white,
        offset: Offset(1, 2),
        blurRadius: 3,
      ),
    ],
  );

  // Default text style (matching Java default_text_size)
  static const TextStyle defaultText = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppDimensions.defaultTextSize,
    color: AppColors.colorTitleBlack,
  );

  // Standard text style (matching Java text_size)
  static const TextStyle standardText = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppDimensions.textSize,
    color: AppColors.colorTitleBlack,
  );

  // Hurry mode text style
  static const TextStyle hurryModeText = TextStyle(
    fontFamily: fontFamily,
    fontSize: AppDimensions.hurryModeTextSize,
    fontWeight: FontWeight.bold,
  );

  // Title Styles (Updated with fontFamily)
  static const TextStyle introTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 23,
    fontWeight: FontWeight.bold,
    color: AppColors.colorTitleBlack,
    height: 1.5,
  );

  static const TextStyle splashTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Description Styles
  static const TextStyle introDescription = TextStyle(
    fontSize: 17,
    color: AppColors.colorTextNotSelected,
    height: 1.4,
  );

  static const TextStyle splashDescription = TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );

  // Button Styles
  static const TextStyle buttonText = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle skipButtonText = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // App Bar Styles
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Body Text Styles
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.colorTitleBlack,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: AppColors.colorTextNotSelected,
  );

  // Special Styles
  static const TextStyle highlightedText = TextStyle(
    fontSize: 17,
    color: AppColors.colorGreenButton,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 14,
    color: AppColors.colorRedError,
  );

  // Material Design Text Styles (Missing ones)
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTitleBlack,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTitleBlack,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTitleBlack,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.colorTitleBlack,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.colorTitleBlack,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.colorTextNotSelected,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.colorTitleBlack,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.colorTitleBlack,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.colorTextNotSelected,
  );
}

