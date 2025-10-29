import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class HomeCategoryDetailsPage extends StatelessWidget {
  final String title;
  final String? description;

  const HomeCategoryDetailsPage({super.key, required this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.washyBlue,
        title: Text(title, style: const TextStyle(color: AppColors.white)),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (description != null && description!.isNotEmpty)
            Text(
              description!,
              style: const TextStyle(color: AppColors.colorTitleBlack),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.colorViewSeparators),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('الخدمات المتاحة', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.colorActionBlack)),
                SizedBox(height: 8),
                Text('- غسيل وتنظيف'),
                Text('- كيّ ملابس'),
                Text('- عناية مميّزة'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


