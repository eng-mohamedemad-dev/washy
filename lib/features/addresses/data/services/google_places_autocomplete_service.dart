import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/app_config.dart';
import '../../domain/services/location_autocomplete_service.dart';

class GooglePlacesAutocompleteService implements LocationAutocompleteService {
  GooglePlacesAutocompleteService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<List<String>> suggest(String query) async {
    if (query.trim().length < 3) return <String>[];
    final apiKey = AppConfig.googlePlacesApiKey;
    if (apiKey.isEmpty) return <String>[];

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': query,
        'types': 'geocode',
        'language': 'ar',
        'components': 'country:sa|country:ae|country:jo',
        'key': apiKey,
      },
    );

    final resp = await _client.get(uri);
    if (resp.statusCode != 200) return <String>[];
    final data = json.decode(resp.body) as Map<String, dynamic>;
    final preds = (data['predictions'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    return preds.map((p) => p['description'] as String? ?? '').where((s) => s.isNotEmpty).toList(growable: false);
  }
}


