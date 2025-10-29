import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/injection_container.dart' as di;
import 'package:wash_flutter/features/addresses/domain/services/location_autocomplete_service.dart';
import 'package:wash_flutter/features/addresses/presentation/widgets/location_autocomplete_field.dart';

class EditAddressPage extends StatelessWidget {
  final int addressId;

  const EditAddressPage({super.key, required this.addressId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.washyBlue,
        title: const Text(
          'تعديل العنوان',
          style: TextStyle(color: AppColors.white),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.washyBlue),
                const SizedBox(width: 8),
                Text(
                  'المعرف: #$addressId',
                  style: const TextStyle(color: AppColors.grey2),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _AddressTextField(
              label: 'الاسم المستعار للعنوان',
              hint: 'مثال: المنزل، العمل',
            ),
            const SizedBox(height: 12),
            LocationAutocompleteField(
              service: di.getIt<LocationAutocompleteService>(),
              label: 'المنطقة/المدينة',
              hint: 'اكتب على الأقل 3 أحرف للبحث',
            ),
            const SizedBox(height: 12),
            const _AddressTextField(
              label: 'الحي/الشارع',
              hint: 'اكتب اسم الحي أو الشارع',
            ),
            const SizedBox(height: 12),
            const _AddressTextField(
              label: 'تفاصيل إضافية',
              hint: 'رقم الشقة، معلم قريب، إلخ',
              maxLines: 3,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.colorFilterSeparatorGrey),
                    ),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.washyGreen,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'حفظ التعديلات',
                      style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;

  const _AddressTextField({
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.colorTitleBlack,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
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
        ),
      ],
    );
  }
}


