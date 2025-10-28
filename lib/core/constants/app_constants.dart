class AppConstants {
  AppConstants._();

  // API Configuration
  static const String baseUrl = 'https://apistaging.washywash.com/api/';
  static const String serverUrl = baseUrl; // Alias for compatibility
  static const String stagingBaseUrl = 'https://moonlit-moss-ofs3ubaqcll5.vapor-farm-f1.com/';
  static const String domainConfigUrl = 'https://washywash-public-config.s3.eu-west-2.amazonaws.com/prod/android/domain/domain_name.json';

  // App Configuration
  static const int splashDelayTime = 3000; // 3 seconds
  static const int totalIntroPages = 4;
  static const String washyVideoUrl = 'https://youtu.be/coHI9wb7KgM';

  // Deep Link Configuration
  static const String googlePlayUrl = 'https://play.google.com/store/apps/details?id=com.washywash.customerapp';

  // Contact Information
  static const String contactNumber = '+962 79 9444 733';
  static const String agentNumber = '555555555';

  // Service IDs
  static const int firstServiceId = 12234;
  static const int defaultPriceThreshold = 8;
  static const int minimumDistanceToSendOutOfBound = 100; // meters

  // Service Types
  static const String disinfection = 'disinfection';
  static const String furniture = 'furniture';
  static const String cleaning = 'cleaning';
  static const String skip = 'skip';
  static const String express = 'express';
  static const String carCleaning = 'car_cleaning';
  static const String housekeeping = 'housekeeping';

  // Currency
  static const String jordanianCurrency = 'JOD';

  // Country Codes
  static const String jordanCountryCode = 'JO';
  static const String usaCountryCode = 'US';
  static const String countryNumberCode = '+962';

  // Languages
  static const String arabicLanguage = 'ar';
  static const String englishLanguage = 'en';

  // SharedPreferences Keys
  static const String keyServerUrl = 'server_url';
  static const String keyWalkThroughConsumed = 'walk_through_consumed';
  static const String keyUserLoggedIn = 'user_logged_in';
  static const String keyUserLoggedInSkipped = 'user_logged_in_skipped';
  static const String keyUserToken = 'user_token';
  static const String keyLanguage = 'language';
  static const String keyCountry = 'country';

  // Animation Durations
  static const int fadeAnimationDuration = 1000; // milliseconds
  static const int keyboardOpenDelay = 500; // milliseconds

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
}

