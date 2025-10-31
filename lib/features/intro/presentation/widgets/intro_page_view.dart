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
        // نريد الانتقال فقط عند السحب يمينًا على آخر صفحة (صفحة الفيديو)
        if (isOnLastPage) {
          if (notification is OverscrollNotification) {
            onSwipePastEnd?.call();
            return true;
          }
          if (notification is ScrollUpdateNotification) {
            final metrics = notification.metrics;
            // عند الصفحة الأخيرة: لو وصلنا لأي حافة (atEdge) وحدث سحب => اعتبرها محاولة تجاوز
            if (metrics.atEdge) {
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
        // استخدام Clamping لتقليل تأثير الارتداد وزمن الانتقال
        physics: const ClampingScrollPhysics(),
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
