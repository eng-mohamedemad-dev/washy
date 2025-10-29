/// Exact dimensions from Java project XML files
class AppDimensions {
  AppDimensions._();

  // From dimens.xml
  static const double activityHorizontalMargin = 16.0; // 16dp
  static const double activityVerticalMargin = 16.0; // 16dp

  // Splash dimensions (from activity_splash.xml)
  static const double splashLogoWidth = 84.0; // 84dp
  static const double splashLogoHeight = 83.0; // 83dp

  // Intro dimensions (from activity_intro.xml & fragments)
  static const double introIconSize = 160.0; // 160dp x 160dp
  static const double introTitleTopMargin = 77.0; // 77dp from top
  static const double introDescriptionMargin = 32.0; // 32dp horizontal
  static const double introPagerBottomMargin = 55.0; // 55dp from bottom
  static const double introSkipBottomMargin = 28.0; // 28dp from bottom

  // SignUp dimensions (from sign_up.xml)
  static const double signUpHeaderTopMargin = 40.0; // 40dp
  static const double signUpSocialButtonSpacing = 10.0; // 10dp between buttons
  static const double signUpSocialButtonPadding = 10.0; // 10dp padding
  static const double signUpPhoneInputTopMargin = 13.0; // 13dp
  static const double signUpPhoneInputPadding = 12.0; // 12dp
  static const double signUpPhoneInputBottomMargin = 15.0; // 15dp
  static const double signUpContinueButtonHeight = 50.0; // 50dp
  static const double signUpContinueButtonMargin =
      17.0; // 17dp horizontal margin
  static const double signUpContinueButtonBottomPadding =
      15.0; // 15dp vertical margin

  // Additional SignUp dimensions
  static const double signUpOrDividerTopMargin = 24.0; // 24dp
  static const double orDividerHorizontalPadding = 20.0; // 20dp
  static const double signUpSocialLoginTopMargin = 20.0; // 20dp
  static const double signUpTermsAndPrivacyTopMargin = 32.0; // 32dp

  // Dimensions from Java dimens.xml (100% matching)
  static const double defaultTextSize = 9.0; // 9sp
  static const double badgeCornerRadius = 5.0; // 5dp
  static const double tooltipRadius = 5.0; // 5dp
  static const double topLeftRadius = 4.0; // 4dp
  static const double bottomLeftRadius = 4.0; // 4dp
  static const double topRightRadius = 0.0; // 0dp
  static const double bottomRightRadius = 0.0; // 0dp
  static const double skipSelectionWidth = 312.0; // 312dp
  static const double skipSelectionTitleWidth = 260.0; // 260dp
  static const double quarterUpRotation = -90.0; // -90 degrees

  // Scrolling and animation dimensions
  static const double foregroundScrollingImageViewSpeed = 1.9; // 1.9dp
  static const double backgroundScrollingImageViewSpeed = 1.0; // 1dp
  static const double hurryModeCellHeight = 50.0; // 50dp
  static const double hurryModeTextSize = 20.1; // 20.1sp

  // Badge and notification dimensions
  static const double notificationBadgeEndMargin = 2.0; // 2dp
  static const double threeCirclesWidth = 100.0; // 100dp
  static const double viewPagerNextItemVisible = 26.0; // 26dp
  static const double viewPagerCurrentItemHorizontalMargin = 42.0; // 42dp
  static const double fabMargin = 16.0; // 16dp

  // Switch component dimensions
  static const double switchPadding = -1.0; // -1dp
  static const double switchRadius = 8.0; // 8dp
  static const double switchSize = 24.0; // 24dp

  // Standard text and rotation
  static const double textSize = 14.0; // 14sp
  static const double quarterArrowRotation = 90.0; // 90 degrees

  // Phone input specific
  static const double jordanFlagSize = 19.0; // 19dp x 19dp
  static const double countryCodeSpacing = 8.0; // 8dp spacing

  // Common spacing
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  // Missing commonly used dimensions
  static const double pageMargin = activityHorizontalMargin; // 16.0
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double buttonHeight = 50.0;
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 18.0;
  static const double iconSizeLarge = 32.0;

  // Card and container dimensions
  static const double cardElevation = 2.0;
  static const double cardRadius = 8.0;
  static const double containerPadding = 16.0;
  static const double dividerHeight = 1.0;

  // Input field dimensions
  static const double inputHeight = 48.0;
  static const double inputBorderRadius = 8.0;
  static const double inputPadding = 16.0;

  // Separator dimensions
  static const double separatorWidth = 200.0;
}
