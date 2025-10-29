import 'dart:async';
import '../../domain/services/location_autocomplete_service.dart';

class MockLocationAutocompleteService implements LocationAutocompleteService {
  static const List<String> _samples = <String>[
    'الرياض - العليا',
    'الرياض - النرجس',
    'الرياض - الصحافة',
    'جدة - الحمراء',
    'جدة - الشاطئ',
    'الدمام - المزروعية',
    'الخبر - الواجهة البحرية',
  ];

  @override
  Future<List<String>> suggest(String query) async {
    if (query.trim().isEmpty) return <String>[];
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final lower = query.trim().toLowerCase();
    return _samples.where((s) => s.toLowerCase().contains(lower)).toList(growable: false);
  }
}


