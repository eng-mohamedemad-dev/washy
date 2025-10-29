import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class WebViewPage extends StatelessWidget {
  final String title;
  final String url;
  const WebViewPage({super.key, required this.title, required this.url});

  Future<void> _openExternal() async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

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
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.greyDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.public, size: 72, color: AppColors.grey2),
            const SizedBox(height: 16),
            const Text(
              'لعرض هذا المحتوى، اضغط فتح في المتصفح',
              style: TextStyle(color: AppColors.grey2),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _openExternal,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.washyBlue),
              child: const Text('فتح في المتصفح', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}


