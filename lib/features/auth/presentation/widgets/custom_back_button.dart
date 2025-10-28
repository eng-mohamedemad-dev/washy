import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.arrow_back,
          color: AppColors.greyDark,
          size: 24,
        ),
      ),
    );
  }
}

