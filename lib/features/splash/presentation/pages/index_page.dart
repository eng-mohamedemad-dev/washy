import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart' as di;
import '../../../intro/presentation/pages/intro_page.dart';
import '../bloc/splash_bloc.dart';
import 'splash_page.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getIt<SplashBloc>()..add(StartApp()),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is SplashNavigateToIntro) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const IntroPage()),
              );
            } else if (state is SplashNavigateToSplash) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SplashPage()),
              );
            } else if (state is SplashError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.colorRedError,
                ),
              );
            }
          },
          child: BlocBuilder<SplashBloc, SplashState>(
            builder: (context, state) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.washyBlue),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

