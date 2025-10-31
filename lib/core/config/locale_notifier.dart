import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends ValueNotifier<Locale> {
  LocaleNotifier._(this._prefs, Locale initial)
      : super(initial);

  static const String _kLocaleKey = 'app_locale_code';
  final SharedPreferences _prefs;

  static Future<LocaleNotifier> create(SharedPreferences prefs) async {
    final code = prefs.getString(_kLocaleKey);
    final initial = (code == 'en')
        ? const Locale('en')
        : const Locale('ar');
    return LocaleNotifier._(prefs, initial);
  }

  void setLocale(Locale locale) {
    if (value == locale) return;
    value = locale;
    _prefs.setString(_kLocaleKey, locale.languageCode);
    notifyListeners();
  }

  void toggle() {
    setLocale(value.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));
  }
}


