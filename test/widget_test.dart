// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_flutter/main.dart';
import 'package:wash_flutter/core/config/locale_notifier.dart';

void main() {
  testWidgets('WashyWash app smoke test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final localeNotifier = await LocaleNotifier.create(prefs);
    // Build our app and trigger a frame.
    await tester.pumpWidget(WashyWashApp(localeNotifier: localeNotifier));

    // Verify that our app starts with loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
