import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class OrderDetailsPage extends StatelessWidget {
  final int orderId;
  const OrderDetailsPage({super.key, required this.orderId});

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
          'تفاصيل الطلب',
          style: TextStyle(color: AppColors.greyDark, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Placeholder sections matching Java structure (summary, items, address, payment)
          const ListTile(
            title: Text('ملخص الطلب'),
            subtitle: Text('رقم الطلب وتاريخه وحالته'),
          ),
          const Divider(),
          const ListTile(
            title: Text('العناصر'),
            subtitle: Text('تفاصيل العناصر والكميات'),
          ),
          const Divider(),
          const ListTile(
            title: Text('العنوان'),
            subtitle: Text('عنوان الاستلام والتسليم'),
          ),
          const Divider(),
          const ListTile(
            title: Text('الدفع'),
            subtitle: Text('طريقة الدفع والمبلغ الإجمالي'),
          ),
          const SizedBox(height: 24),
          // Action buttons: Track and Contact
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/order-status',
                      arguments: {'orderId': orderId},
                    );
                  },
                  icon: const Icon(Icons.local_shipping, size: 20, color: AppColors.washyGreen),
                  label: const Text('تتبع الطلب', style: TextStyle(color: AppColors.washyGreen)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/contact-us');
                  },
                  icon: const Icon(Icons.phone, size: 20, color: AppColors.washyBlue),
                  label: const Text('اتصل بنا', style: TextStyle(color: AppColors.washyBlue)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


