import 'package:flutter/material.dart';

/// Colors from the original WashyWash Android app (100% matching colors.xml)
class AppColors {
  AppColors._();

  // Primary Colors from Android Material Design
  static const Color colorPrimary = Color(0xFF3F51B5);
  static const Color colorPrimaryDark = Color(0xFF303F9F);
  static const Color colorAccent = Color(0xFFFF4081);

  // Background Colors (Exact match from Java project)
  static const Color colorBackground = Color(0xFFF8FDFE);
  static const Color colorBackgroundNew = Color(0x48C8EDF7);
  static const Color colorErrorBackground = Color(0xFFFEF8F8);
  static const Color colorBackgroundDark = Color(0xFFC8EDF7);

  // Main WashyWash Colors (From Java values/colors.xml)
  static const Color washyBlue = Color(0xFF13C0D7); // washy_blue_color
  static const Color washyGreen = Color(0xFF41D99E); // washy_green_color
  static const Color colorGreenButton = Color(0xFF92E068);
  static const Color colorBlueButton = Color(0xFF50AAC2);

  // Basic Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color colorWhite = white; // Alias
  static const Color black = Color(0xFF000000);
  static const Color colorBlack = black; // Alias
  static const Color transparent = Color(0x00FFFFFF);
  static const Color transparentWhite = Color(0x0DFFFFFF);

  // Text Colors (Exact match from Java)
  static const Color colorTitleBlack = Color(0xFF333333);
  static const Color newColorTitleBlack = Color(0xFF455869);
  static const Color colorTextSelected = Color(0xFF4C4C4C);
  static const Color colorNewTextSelected = Color(0xFF50AAC2);
  static const Color colorTextNotSelected = Color(0xFF8C96A8);
  static const Color colorNewTextNotSelected = Color(0xFFBFC0C8);

  // Status and UI Colors
  static const Color statusBarColor = Color(0xFF46BD97); // staus_bar_color
  static const Color colorErrorStatusBar = Color(0xFFFCBABA);
  static const Color colorRedError = Color(0xFFE0544B);
  static const Color colorCoral = Color(0xFFEE5B5B);

  // Login and Social Media Colors
  static const Color colorLoginText = Color(0xFF999999);
  static const Color colorSocialMedia = Color(0xFF354656);
  static const Color colorCharcoal = Color(0xFF666666);

  // Progress and Badge Colors
  static const Color badgeColor = Color(0xFFFF7003);
  static const Color colorRedBadge = Color(0xFFFA3E3E);
  static const Color progressBarColor = Color(0xFFE5E5E7);
  static const Color progressBarBlueColor = Color(0xFF51AAC2);

  // Home Screen Colors
  static const Color colorHomeSectionHeader = Color(0xFF31404F);
  static const Color colorHomeSectionCategory = Color(0xFF8C96A8);
  static const Color colorHomeTabSelected = Color(0xFF31404F);
  static const Color colorHomeTabNotSelected = Color(0xFF8C96A8);

  // Order and Cart Colors
  static const Color colorDiscount = Color(0xFF18C1D2);
  static const Color colorSkipSelection = Color(0xFF18C1D2);
  static const Color colorOrderItemsQuantity = Color(0xFF06BCD4);
  static const Color colorCartSeparator = Color(0xFFEDEDED);
  static const Color colorNewOrderSeparator = Color(0xFFEDEDED);

  // Premium Colors
  static const Color premiumColor = Color(0xFFD5A65C);
  static const Color colorPremiumBlack = Color(0xFF0E0E12);
  static const Color colorPremiumGold2 = Color(0xFFDAA814);

  // Verification and Input Colors
  static const Color colorVerifyNumberFloor = Color(0xFFEDEDED);
  static const Color colorVerifyNumberFloorSelected = Color(0xFFB7B5B5);
  static const Color colorViewSeparators = Color(0xFFD5D5DB);

  // Additional UI Colors
  static const Color colorActionBlack = Color(0xFF354656);
  static const Color colorDescriptionHeader = Color(0xFF4A4A4A);
  static const Color colorPlaceTitle = Color(0xFF424242);
  static const Color colorTotalHint = Color(0xFF6C6C6C);
  static const Color colorOrderDetailsItems = Color(0xFF828282);
  static const Color colorOrderDetailsPrice = Color(0xFF424242);
  static const Color colorAddressFields = Color(0xFF1D1D26);

  // Additional Colors from Java
  static const Color circleDotGray = Color(0xFF64707E);
  static const Color colorEcoCleanInfoGrey = Color(0xFF8B95A7);
  static const Color cartCircleBorder = Color(0x73C0C0C0);
  static const Color cartCircleSolid = Color(0xA6FFFFFF);
  static const Color tooltipBorderBackground = Color(0x73EAEAEA);
  static const Color termsColor = Color(0xFF88939E);
  static const Color colorSearchBackground = Color(0xFFF4F4F4);

  // Special Colors
  static const Color colorDarkGreyTransparent = Color(0x998C96A8);
  static const Color colorSelectedService = Color(0xFF50AAC2);
  static const Color colorSkipSelectionBackground = Color(0xFF31404F);
  static const Color colorMasterCardBackground = Color(0xFFF89F15);
  static const Color colorVisaBackground = Color(0xFF1276F5);
  static const Color colorYellowBalance = Color(0xFFE8F0BE);
  static const Color colorReminderSettingsText = Color(0xFF31404F);

  // Alpha Colors
  static const Color colorAlphaBlack = Color(0xCC000000);
  static const Color colorAlphaTurquoise = Color(0xCC0DB5CC);
  static const Color colorSeeAll = Color(0xFFF2F2F2);
  static const Color colorLightCharcoal = Color(0x71979797);
  static const Color colorFilterSeparatorGrey = Color(0xFFCBCBCB);
  static const Color colorFilterSeparator = Color(0xFFC5BABA);
  static const Color colorCategoryHeaderAlphaBlack = Color(0x58000000);

  // Color Palette (From Java design system)
  // Blues
  static const Color blue1 = Color(0xFF50AAC2);
  static const Color blue2 = Color(0xFF74BBCD);
  static const Color blue3 = Color(0xFF96CBDA);
  static const Color blue4 = Color(0xFFB9DDE7);
  static const Color blue5 = Color(0xFFDCEEF3);

  // Greys
  static const Color grey1 = Color(0xFF495767);
  static const Color grey2 = Color(0xFF818393);
  static const Color grey3 = Color(0xFFECEEF0);
  static const Color grey4 = Color(0xFFF6F8F9);
  static const Color grey5 = Color(0xFFF2F9EE);
  static const Color greyDark = Color(0xFF455869); // grey_dark
  static const Color greyBlue = Color(0xFFE6F6F9); // grey_blue
  static const Color brownGrey = Color(0xFFAFAFAF);

  // Greens
  static const Color green1 = Color(0xFF91CC74);
  static const Color green2 = Color(0xFF9BD181);
  static const Color green3 = Color(0xFFB1DB9D);
  static const Color green4 = Color(0xFFC8E5B9);

  // Special Colors
  static const Color priceRedColor = Color(0xFFB12704);
  static const Color primaryRed = Color(0xFFE87E7E);

  // Gradient Colors (for app_gradients.dart)
  static const Color gradientStart = washyBlue;
  static const Color gradientCenter = Color(0xFF2DD4EF);
  static const Color gradientEnd = washyGreen;

  // Profile gradient colors
  static const Color profileGradientStart = washyBlue;
  static const Color profileGradientCenter = Color(0xFF2DD4EF);
  static const Color profileGradientEnd = washyGreen;

  // Aliases for compatibility with existing code
  static const Color background = colorBackground;
  static const Color lightGrey = grey3;
  static const Color grey = grey2;
  static const Color darkGrey = greyDark;
}
