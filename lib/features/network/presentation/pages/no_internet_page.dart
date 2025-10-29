import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class NoInternetPage extends StatelessWidget {
  final VoidCallback? onRetry;
  const NoInternetPage({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 96, color: AppColors.grey2),
              const SizedBox(height: 16),
              const Text(
                'لا يوجد اتصال بالإنترنت',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greyDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'تحقق من الاتصال وحاول مرة أخرى.',
                style: TextStyle(color: AppColors.grey2),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry ?? () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.washyBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: const Text('إعادة المحاولة', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




