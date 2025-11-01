import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('ar'), Locale('en')];

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'home': 'الصفحة الرئيسية',
      'orders': 'طلباتي',
      'notifications': 'الإشعارات',
      'profile': 'حسابي',
      'quick_order': 'طلب سريع',
      'what_is_ecoclean': 'ما هو نظام الإيكو كلين',
      'version': 'الإصدار',
      'terms': 'الشروط والاحكام',
      'search_hint': 'ابحث عن خدمة الغسيل',
      'categories': 'الفئات',
      'order_now': 'اطلب الآن',
      // Category translations
      'clothes': 'الملابس',
      'furniture': 'الأثاث',
      'carpet': 'السجاد',
      'car_detailing': 'تنظيف السيارات',
      'house_cleaning': 'تنظيف المنازل',
      'shoes': 'الأحذية',
      'tailoring': 'الخياطة',
      'offers': 'العروض',
      'dresses': 'الفساتين',
      'bags': 'الحقائب',
      'wash_and_fold': 'غسيل وطي بالكيلو',
      'bedding': 'المفروشات',
      'curtains_cleaning': 'تنظيف الستائر',
      'ecoclean': 'الإيكو كلين',
    },
    'en': {
      'home': 'Home',
      'orders': 'My Orders',
      'notifications': 'Notifications',
      'profile': 'My Account',
      'quick_order': 'Quick Order',
      'what_is_ecoclean': 'What is EcoClean',
      'version': 'Version',
      'terms': 'Terms & Conditions',
      'search_hint': 'Search laundry service',
      'categories': 'Categories',
      'order_now': 'Order Now',
      // Category translations
      'clothes': 'Clothes',
      'furniture': 'Furniture',
      'carpet': 'Carpet',
      'car_detailing': 'Car detailing',
      'house_cleaning': 'House cleaning',
      'shoes': 'Shoes',
      'tailoring': 'Tailoring',
      'offers': 'Offers!',
      'dresses': 'Dresses',
      'bags': 'Bags',
      'wash_and_fold': 'Wash and Fold per kilo',
      'bedding': 'Bedding',
      'curtains_cleaning': 'Curtains cleaning',
      'ecoclean': 'Ecoclean',
    },
  };

  String t(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
