import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_flutter/core/constants/app_constants.dart';
import '../models/landing_page_response.dart';
import '../models/home_page_response.dart';

class HomeApiService {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  HomeApiService({required this.client, required this.sharedPreferences});

  String _baseUrl() => AppConstants.serverUrl;

  Future<LandingPageResponse> fetchLanding() async {
    final url = Uri.parse('${_baseUrl()}listing/landing-page');
    final res = await client.get(url, headers: {'Accept': 'application/json'});
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> body = json.decode(res.body) as Map<String, dynamic>;
      return LandingPageResponse.fromJson(body);
    }
    throw Exception('Landing request failed: ${res.statusCode}');
  }

  Future<HomePageResponse> fetchHomePage() async {
    final url = Uri.parse('${_baseUrl()}listing/homepage');
    final res = await client.get(url, headers: {'Accept': 'application/json'});
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> body = json.decode(res.body) as Map<String, dynamic>;
      return HomePageResponse.fromJson(body);
    }
    throw Exception('HomePage request failed: ${res.statusCode}');
  }
}


