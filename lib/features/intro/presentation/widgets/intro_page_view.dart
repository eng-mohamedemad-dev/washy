import 'package:flutter/material.dart';
import 'intro_page_1.dart';
import 'intro_page_2.dart';
import 'intro_page_3.dart';
import 'intro_page_4.dart';

class IntroPageView extends StatelessWidget {
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final bool isOnLastPage;
  final VoidCallback? onSwipePastEnd;

  const IntroPageView({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.isOnLastPage,
    this.onSwipePastEnd,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // 1) أجهزة لا تُطلق Overscroll دائمًا: التقط أيضًا ScrollUpdate عند الحافة اليسرى
        if (isOnLastPage) {
          if (notification is OverscrollNotification) {
            onSwipePastEnd?.call();
            return true;
          }
          if (notification is ScrollUpdateNotification) {
            final metrics = notification.metrics;
            // مع reverse:true تكون الصفحة الأخيرة بصريًا عند بداية النطاق (pixels <= 0)
            if (metrics.pixels <= 0 &&
                (notification.dragDetails?.delta.dx ?? 0) < 0) {
              onSwipePastEnd?.call();
              return true;
            }
          }
        }
        return false;
      },
      child: PageView.builder(
        controller: pageController,
        // Enable right-to-left swiping order
        reverse: true,
        onPageChanged: onPageChanged,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
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
      ),
    );
  }
}
