import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';

class AddressDetailsPage extends StatelessWidget {
  final int addressId;
  const AddressDetailsPage({super.key, required this.addressId});

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
          'تفاصيل العنوان',
          style: TextStyle(
            color: AppColors.greyDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.activityHorizontalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                  SizedBox(height: 8),
                  Text(
                    'العنوان المختصر',
                    style: TextStyle(fontSize: 14, color: AppColors.grey2),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'شارع الملك عبدالله الثاني، عمّان',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.greyDark),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'تفاصيل إضافية',
                    style: TextStyle(fontSize: 14, color: AppColors.grey2),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'الطابق الثالث، شقة 12، بالقرب من مول XYZ',
                    style: TextStyle(fontSize: 16, color: AppColors.greyDark),
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
                  Navigator.of(context).pop({'selectedAddressId': addressId});
                },
                child: const Text('استخدام هذا العنوان', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


