import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class PayfortPaymentPage extends StatelessWidget {
  final int orderId;
  final double amount;
  const PayfortPaymentPage({super.key, required this.orderId, required this.amount});

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
          'Payfort Payment',
          style: TextStyle(color: AppColors.greyDark, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80, color: AppColors.washyBlue),
            const SizedBox(height: 16),
            Text('Order #$orderId', style: const TextStyle(color: AppColors.greyDark)),
            const SizedBox(height: 8),
            Text('Amount: ${amount.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.grey2)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: integrate Payfort SDK or redirect to payment gateway
                Navigator.of(context).pop({'status': 'success'});
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.washyBlue),
              child: const Text('Pay Now', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}


