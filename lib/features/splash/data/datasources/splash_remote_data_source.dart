import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class SplashRemoteDataSource {
  Future<String> fetchServerUrl();
  Future<void> fetchConfigData();
  Future<void> fetchAllStrings();
}

class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  final http.Client client;

  SplashRemoteDataSourceImpl({required this.client});

  @override
  Future<String> fetchServerUrl() async {
    try {
      // Match Java: IndexActivity.fetchServerUrl() uses BuildConfig.DOMAIN_URL_CONFIG
      // Java uses: https://washywash-public-config.s3.eu-west-2.amazonaws.com/prod/android/domain/domain_name.json
      // or staging: https://washywash-public-config.s3.eu-west-2.amazonaws.com/staging/android/domain/domain_name.json
      final response = await client.get(
        Uri.parse(AppConstants.domainConfigUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // Match Java: jsonObject.getString("domain_name")
        final domainName = jsonResponse['domain_name'] as String?;
        print('[SplashRemoteDataSource] Config file response: domain_name = $domainName');
        
        if (domainName != null && domainName.isNotEmpty) {
          // Ensure URL ends with /api/ like Java expects
          String url = domainName;
          if (!url.endsWith('/')) {
            url += '/';
          }
          if (!url.endsWith('api/')) {
            url += 'api/';
          }
          print('[SplashRemoteDataSource] ✅ Resolved server URL: $url');
          return url;
        }
        
        // Fallback to hardcoded staging URL (matching Java BuildConfig.SERVER_URL)
        print('[SplashRemoteDataSource] ⚠️ No domain_name in config, using fallback: ${AppConstants.baseUrl}');
        return AppConstants.baseUrl;
      } else {
        throw ServerException('Failed to fetch server URL: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error while fetching server URL: $e');
    }
  }

  @override
  Future<void> fetchConfigData() async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}config/order'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw ServerException('Failed to fetch config data: ${response.statusCode}');
      }
      // Process response if needed
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error while fetching config data: $e');
    }
  }

  @override
  Future<void> fetchAllStrings() async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}config/strings'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw ServerException('Failed to fetch all strings: ${response.statusCode}');
      }
      // Process response if needed
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error while fetching all strings: $e');
    }
  }
}

