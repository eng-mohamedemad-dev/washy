import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_flutter/core/constants/app_constants.dart';
import 'package:wash_flutter/core/config/locale_notifier.dart';
import 'package:get_it/get_it.dart';
import '../models/landing_page_response.dart';
import '../models/home_page_response.dart';

class HomeApiService {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  HomeApiService({required this.client, required this.sharedPreferences});

  /// Get base URL - matching Java SharedPreferenceManager.getServerUrl()
  /// Java fetches URL from config file (DOMAIN_URL_CONFIG) and saves to SharedPreferences
  /// Java uses: SharedPreferencesHelper.getStringByKey(context, "SERVER_URL", "APP_CONFIG")
  /// Flutter should use the same saved URL, fallback to hardcoded staging URL
  String _baseUrl() {
    // Match Java: SharedPreferenceManager.getServerUrl(context)
    // Java key: "SERVER_URL" (uppercase), file: "APP_CONFIG"
    // Flutter uses default SharedPreferences with same key name "SERVER_URL"
    final savedServerUrl = sharedPreferences.getString(AppConstants.keyServerUrl);
    print('[HomeApiService] Checking saved server URL. Key: ${AppConstants.keyServerUrl}, Value: $savedServerUrl');
    
    if (savedServerUrl != null && savedServerUrl.isNotEmpty) {
      // Ensure URL ends with /api/ like Java expects
      String url = savedServerUrl;
      if (!url.endsWith('/')) {
        url += '/';
      }
      if (!url.endsWith('api/')) {
        url += 'api/';
      }
      print('[HomeApiService] ✅ Using saved server URL: $url');
      return url;
    }
    
    // Fallback to hardcoded staging URL (matching Java BuildConfig.SERVER_URL default)
    print('[HomeApiService] ⚠️ No saved server URL found, using fallback staging URL: ${AppConstants.serverUrl}');
    print('[HomeApiService] ⚠️ Make sure Splash screen fetched and saved server URL from config file');
    return AppConstants.serverUrl;
  }

  /// Get language header value matching Java format (ar_JO or en_US)
  /// Java uses LocalizationManager.getInstance().getAppLocalizationName() which returns "ar_JO" or "en_US"
  /// This matches the backend expectation: header('lang') == 'ar_JO' ? 2 : 1
  /// 
  /// Java default behavior:
  /// - If no saved language: uses device language, if not 'en' → defaults to Arabic
  /// - Arabic + country (JO) = "ar_JO"
  /// - English + country (JO) = "en_US" (but country is typically JO for both)
  /// 
  /// For now, we'll default to 'ar_JO' to match Java's typical behavior
  String _getLangHeader() {
    try {
      final localeNotifier = GetIt.instance<LocaleNotifier>();
      final locale = localeNotifier.value;
      // Match Java format: "ar_JO" for Arabic, "en_US" for English
      // Java logic from BaseActivity.updateLocalizationData():
      // appLocalizationName = "ar" + "_" + country (if country exists) = "ar_JO"
      // NOTE: Java typically defaults to Arabic (ar_JO) unless user explicitly selected English
      final langValue = locale.languageCode == 'ar' ? 'ar_JO' : 'en_US';
      print('[HomeApiService] Language header: $langValue (from locale: ${locale.languageCode})');
      
      // TEMPORARY FIX: Force ar_JO to match Java behavior until we verify the actual language preference
      // If Java is showing 14 items with ar_JO, we should also use ar_JO to get the same data
      final forcedLangValue = 'ar_JO';
      if (langValue != forcedLangValue) {
        print('[HomeApiService] WARNING: Locale is $langValue but forcing to $forcedLangValue to match Java');
      }
      return forcedLangValue; // TODO: Remove this and use langValue once we confirm the language preference is correct
    } catch (e) {
      // Fallback: default to Arabic like Java
      print('[HomeApiService] Error getting locale, using fallback ar_JO: $e');
      return 'ar_JO';
    }
  }

  /// Get common headers matching Java WashyInterceptor
  /// Java sends: platform, version, device, lang
  Map<String, String> _getHeaders() {
    final headers = {
      'Accept': 'application/json',
      'lang': _getLangHeader(), // CRITICAL: Backend uses this to select language-specific data (icon_ar vs icon)
    };
    print('[HomeApiService] Request headers: $headers');
    return headers;
  }

  Future<LandingPageResponse> fetchLanding() async {
    final url = Uri.parse('${_baseUrl()}listing/landing-page');
    print('[HomeApiService] Fetching landing page from: $url');
    final headers = _getHeaders();
    final res = await client.get(url, headers: headers);
    print('[HomeApiService] Landing page response status: ${res.statusCode}');
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> body = json.decode(res.body) as Map<String, dynamic>;
      final landingItems = (body['data']?['landing_items'] as List<dynamic>? ?? []);
      print('[HomeApiService] Received ${landingItems.length} landing items');
      return LandingPageResponse.fromJson(body);
    }
    throw Exception('Landing request failed: ${res.statusCode}');
  }

  Future<HomePageResponse> fetchHomePage() async {
    final url = Uri.parse('${_baseUrl()}listing/homepage');
    final res = await client.get(url, headers: _getHeaders());
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> body = json.decode(res.body) as Map<String, dynamic>;
      return HomePageResponse.fromJson(body);
    }
    throw Exception('HomePage request failed: ${res.statusCode}');
  }
}


