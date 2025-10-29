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
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return const IntroPage1();
          case 1:
            return const IntroPage2();
          case 2:
            return const IntroPage3();
          case 3:
            return const IntroPage4();
          default:
            return const SizedBox();
        }
      },
      itemCount: 4,
    );
  }
}
