import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.washyBlue,
        title: const Text(
          'حذف الحساب',
          style: TextStyle(color: AppColors.white),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.colorErrorBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.colorRedError.withOpacity(0.2)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تنبيه مهم',
                    style: TextStyle(
                      color: AppColors.colorCoral,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'سيتم حذف حسابك نهائيًا، بما في ذلك الطلبات المحفوظة وطرق الدفع والعناوين. لا يمكن التراجع عن هذه العملية.',
                    style: TextStyle(color: AppColors.colorTitleBlack),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'من فضلك اكتب "حذف" للتأكيد',
              style: TextStyle(color: AppColors.grey2),
            ),
            const SizedBox(height: 8),
            const _ConfirmField(),
            const Spacer(),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorRedError,
                ),
                onPressed: () {
                  // TODO: ربط منطق حذف الحساب عند توفّر API
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'تأكيد حذف الحساب',
                  style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmField extends StatefulWidget {
  const _ConfirmField();

  @override
  State<_ConfirmField> createState() => _ConfirmFieldState();
}

class _ConfirmFieldState extends State<_ConfirmField> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'اكتب: حذف',
        filled: true,
        fillColor: AppColors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.colorViewSeparators),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.washyBlue, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}


