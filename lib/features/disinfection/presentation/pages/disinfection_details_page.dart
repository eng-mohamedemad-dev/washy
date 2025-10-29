import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';

class DisinfectionDetailsPage extends StatelessWidget {
  const DisinfectionDetailsPage({super.key});

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
          'خدمة التعقيم',
          style: TextStyle(
            color: AppColors.greyDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.activityHorizontalMargin,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'تعقيم شامل للمنازل والمكاتب',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'نستخدم مواد آمنة ومعتمدة لتعقيم جميع الأسطح والمناطق الحساسة لضمان أعلى معايير النظافة.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey2,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.washyBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/new-order', arguments: {
                    'orderType': 'disinfection',
                  });
                },
                child: const Text('ابدأ الطلب', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




