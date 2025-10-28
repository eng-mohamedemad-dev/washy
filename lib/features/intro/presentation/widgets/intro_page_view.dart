import 'package:flutter/material.dart';
import 'intro_page_1.dart';
import 'intro_page_2.dart';
import 'intro_page_3.dart';
import 'intro_page_4.dart';

class IntroPageView extends StatelessWidget {
  final PageController pageController;
  final ValueChanged<int> onPageChanged;

  const IntroPageView({
    super.key,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: const [
        IntroPage1(),
        IntroPage2(),
        IntroPage3(),
        IntroPage4(),
      ],
    );
  }
}

