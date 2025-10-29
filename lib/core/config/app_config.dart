class AppConfig {
  AppConfig._();

  // فعّل Google Places بدل المزود التجريبي
  static const bool useGooglePlaces = true;

  // مفاتيح الربط الخارجية (املأها عند التوصيل الفعلي)
  static const String googlePlacesApiKey = String.fromEnvironment(
    'GOOGLE_PLACES_API_KEY',
    // مفتاح Google Maps/Places الموجود في مشروع الجافا (AndroidManifest)
    defaultValue: 'AIzaSyC5gGnBiVvshpq3OpLFuzLo5Lsbg96gq8A',
  );
}


