import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_gradients.dart';
import '../../../../core/constants/app_text_styles.dart';
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
    // Set full screen like Java version
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      
      // If reached last page and user tries to scroll next
      if (page == _totalPages - 1) {
        _finishAndNavigate();
      }
    });
  }

  void _onSkipPressed() {
    _finishAndNavigate();
  }

  void _finishAndNavigate() {
    // Set walk through consumed and navigate to Splash like Java
    di.getIt<SetWalkThroughConsumed>()
        .call(const SetWalkThroughConsumedParams(true))
        .then((_) {
      Navigator.pushReplacementNamed(context, AppRoutes.splash);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.introGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ViewPager equivalent
              Expanded(
                child: IntroPageView(
                  pageController: _pageController,
                  onPageChanged: _onPageChanged,
                ),
              ),
              
              // Page indicators like Java version (55dp from bottom)
              Padding(
                padding: const EdgeInsets.only(bottom: 55.0),
                child: PageIndicator(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                ),
              ),
              
              // Skip/Continue button like Java version (28dp from bottom)
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: TextButton(
                  onPressed: _onSkipPressed,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                  ),
                  child: Text(
                    _currentPage == _totalPages - 1 ? 'Continue' : 'Skip',
                    style: AppTextStyles.skipButtonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
