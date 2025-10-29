import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Loading widget used throughout the app
class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;

  const LoadingWidget({
    super.key,
    this.message,
    this.color,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.washyBlue,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.colorTextNotSelected,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Simple circular loading indicator
class SimpleLoadingWidget extends StatelessWidget {
  final Color? color;
  final double size;

  const SimpleLoadingWidget({
    super.key,
    this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.washyBlue,
        ),
      ),
    );
  }
}

