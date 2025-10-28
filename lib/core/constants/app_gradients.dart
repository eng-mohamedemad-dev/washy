import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Gradients used in the original WashyWash Android app
class AppGradients {
  AppGradients._();

  /// Splash screen gradient (angle 90)
  /// From #92e068 (green) to #13c0d7 (turquoise)
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.gradientStart, // #92E068
      AppColors.gradientEnd,   // #13C0D7
    ],
  );

  /// Intro screen gradient (angle 315)
  /// From #13C0D7 to #52D0A0 to #92E068
  static const LinearGradient introGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.gradientEnd,    // #13C0D7
      AppColors.gradientCenter, // #52D0A0
      AppColors.gradientStart,  // #92E068
    ],
  );

  /// Button gradient
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.washyBlue,
      AppColors.washyGreen,
    ],
  );

  /// Card gradient for premium features
  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.premiumColor,
      AppColors.colorPremiumGold2,
    ],
  );
}

