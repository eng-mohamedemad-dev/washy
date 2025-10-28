import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Skip selection section widget for skip selection order type
/// Matches the skip selection functionality in Java NewOrderActivity
class SkipSelectionSection extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>) onChanged;

  const SkipSelectionSection({
    Key? key,
    required this.data,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skipSelectionId = data['skipSelectionId'] as int?;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skip selection info
          _buildSkipSelectionInfo(skipSelectionId),
          
          const SizedBox(height: 16),
          
          // Instructions
          _buildInstructions(),
        ],
      ),
    );
  }

  /// Build skip selection information
  Widget _buildSkipSelectionInfo(int? skipSelectionId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.washyGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.washyGreen.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.washyGreen,
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 12),
              
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلب سريع',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      'طلب بدون تحديد منتجات مسبقاً',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (skipSelectionId != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Text(
                    'رقم الطلب السريع:',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '#$skipSelectionId',
                    style: const TextStyle(
                      color: AppColors.washyGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build instructions section
  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'كيف يعمل الطلب السريع؟',
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Instructions list
        Column(
          children: [
            _buildInstructionItem(
              icon: Icons.location_on,
              title: 'تحديد العنوان',
              description: 'حدد عنوان الاستلام والتسليم',
            ),
            _buildInstructionItem(
              icon: Icons.schedule,
              title: 'اختيار الوقت',
              description: 'اختر الوقت المناسب لاستلام طلبك',
            ),
            _buildInstructionItem(
              icon: Icons.inventory,
              title: 'فحص الملابس',
              description: 'سيقوم فريقنا بفحص وتقدير أسعار الملابس',
            ),
            _buildInstructionItem(
              icon: Icons.payment,
              title: 'الدفع',
              description: 'ادفع بعد معرفة السعر النهائي',
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Note
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info,
                color: Colors.blue,
                size: 20,
              ),
              
              const SizedBox(width: 8),
              
              const Expanded(
                child: Text(
                  'ملاحظة: سيتم تحديد السعر النهائي بعد فحص الملابس من قبل فريقنا المختص.',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 12,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build individual instruction item
  Widget _buildInstructionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.washyGreen.withOpacity(0.2),
            ),
            child: Icon(
              icon,
              color: AppColors.washyGreen,
              size: 16,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Step details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 11,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
