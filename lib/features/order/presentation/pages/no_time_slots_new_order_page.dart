import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class NoTimeSlotsNewOrderPage extends StatelessWidget {
  final String? navigationType;
  const NoTimeSlotsNewOrderPage({super.key, this.navigationType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.greyDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'لا توجد مواعيد متاحة',
          style: TextStyle(color: AppColors.greyDark, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.schedule, size: 96, color: AppColors.grey2),
              const SizedBox(height: 16),
              const Text(
                'عذرًا، لا توجد مواعيد متاحة حاليًا لهذه الخدمة.',
                style: TextStyle(color: AppColors.greyDark, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('رجوع', style: TextStyle(color: AppColors.washyBlue)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/express-delivery');
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.washyGreen),
                      child: const Text('جرّب الخدمة السريعة', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // إعادة المحاولة: الرجوع وتحديث الصفحة السابقة لإعادة تحميل المواعيد
                  Navigator.of(context).pop();
                },
                child: const Text('إعادة المحاولة لاحقًا'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


