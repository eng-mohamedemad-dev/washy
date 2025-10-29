import 'package:flutter/material.dart';

import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'dart:async';
import '../widgets/intro_page_view.dart';
import '../widgets/page_indicator.dart';
import '../../../../injection_container.dart' as di;
import '../../../splash/domain/usecases/set_walkthrough_consumed.dart';
import '../../../../core/routes/app_routes.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 4;

  @override
  void initState() {
    super.initState();
    // Don't set full screen to avoid performance issues
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      // Don't automatically navigate - user must press button
    });
  }

  void _onSkipPressed() {
    try {
      // Set walk through consumed in background (don't block)
      unawaited(
        di
            .getIt<SetWalkThroughConsumed>()
            .call(const SetWalkThroughConsumedParams(true)),
      );

      // Navigate to LoginPage immediately
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      print('[Intro] Navigation error: $e');
      // Fallback: just navigate
      if (mounted) {
        try {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } catch (e2) {
          print('[Intro] Navigation fallback error: $e2');
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.introGradient,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Pages
                Positioned.fill(
                  child: IntroPageView(
                    pageController: _pageController,
                    onPageChanged: _onPageChanged,
                  ),
                ),

                // Page indicators INSIDE the main card area
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 160.0),
                    child: PageIndicator(
                      currentPage: _currentPage,
                      totalPages: _totalPages,
                    ),
                  ),
                ),

                // Skip/Continue button at the very bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 28.0),
                    child: TextButton(
                      onPressed: _onSkipPressed,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                      ),
                      child: Text(
                        _currentPage == _totalPages - 1 ? 'تابع' : 'تخطي',
                        style: AppTextStyles.skipButtonText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
