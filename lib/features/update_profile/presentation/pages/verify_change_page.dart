import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class VerifyChangePage extends StatelessWidget {
  final String identifier;
  final bool isPhone;

  const VerifyChangePage({
    super.key,
    required this.identifier,
    this.isPhone = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.washyBlue,
        title: const Text(
          'تأكيد التغيير',
          style: TextStyle(color: AppColors.white),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isPhone ? 'أدخل كود التحقق المرسل إلى رقمك' : 'أدخل كود التحقق المرسل إلى بريدك',
              style: const TextStyle(color: AppColors.colorTitleBlack, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              identifier,
              style: const TextStyle(color: AppColors.grey2),
            ),
            const SizedBox(height: 16),
            const _OtpFields(),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // TODO: ربط إعادة إرسال الكود
              },
              child: const Text('إعادة إرسال الرمز'),
            ),
            const Spacer(),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.washyGreen),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('تأكيد', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpFields extends StatelessWidget {
  const _OtpFields();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 60,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.colorVerifyNumberFloor),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.colorVerifyNumberFloorSelected, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      }),
    );
  }
}


