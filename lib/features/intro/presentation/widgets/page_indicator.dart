import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) {
          final bool isActive = index == currentPage;
          final double size =
              isActive ? 10 : 5; // active is larger, all smaller overall
          return AnimatedContainer(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            duration: const Duration(milliseconds: 180),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? (Colors.green[500] ?? AppColors.washyGreen)
                  : (Colors.grey[400] ?? AppColors.grey2),
            ),
          );
        },
      ),
    );
  }
}
