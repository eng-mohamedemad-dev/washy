import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SplashLogo extends StatelessWidget {
  final double size;
  
  const SplashLogo({
    super.key,
    this.size = 84,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * (83 / 84), // Keep original aspect ratio from Java (84dp x 83dp)
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.local_laundry_service,
          size: size * 0.5,
          color: AppColors.washyBlue,
        ),
      ),
    );
  }
}

