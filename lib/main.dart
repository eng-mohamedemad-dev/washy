import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_colors.dart';
import 'core/routes/app_routes.dart';
import 'features/splash/presentation/pages/index_page.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const WashyWashApp());
}

class WashyWashApp extends StatelessWidget {
  const WashyWashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.getIt<SplashBloc>()),
      ],
      child: MaterialApp(
        title: 'WashyWash',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: AppColors.washyBlue,
          // fontFamily: 'SourceSansPro',
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
      ),
    );
  }
}