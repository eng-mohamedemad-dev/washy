import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_colors.dart';
import 'core/routes/app_routes.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'l10n/app_localizations.dart';
import 'core/config/locale_notifier.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // LocaleNotifier is registered in DI
  runApp(WashyWashApp(localeNotifier: di.getIt<LocaleNotifier>()));
}

class WashyWashApp extends StatelessWidget {
  final LocaleNotifier localeNotifier;
  const WashyWashApp({super.key, required this.localeNotifier});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.getIt<SplashBloc>()),
      ],
      child: ValueListenableBuilder<Locale>(
        valueListenable: localeNotifier,
        builder: (context, locale, _) {
          return MaterialApp(
            title: 'WashyWash',
            debugShowCheckedModeBanner: false,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: AppColors.washyBlue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.washyBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.light,
              ),
            ),
            initialRoute: AppRoutes.initial,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
