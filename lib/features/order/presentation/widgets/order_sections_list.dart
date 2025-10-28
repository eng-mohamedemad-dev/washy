import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/new_order_section_type.dart';
import 'sections/address_section.dart';
import 'sections/time_section.dart';
import 'sections/payment_section.dart';
import 'sections/notes_section.dart';
import 'sections/skip_selection_section.dart';

/// List widget that displays all order sections
/// Matches the RecyclerView functionality in Java NewOrderActivity
class OrderSectionsList extends StatelessWidget {
  final List<Map<String, dynamic>> sections;
  final Function(NewOrderSectionType, Map<String, dynamic>) onSectionChanged;

  const OrderSectionsList({
    Key? key,
    required this.sections,
    required this.onSectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final sectionType = section['type'] as NewOrderSectionType;
        final title = section['title'] as String;
        final isCompleted = section['isCompleted'] as bool;
        final data = section['data'] as Map<String, dynamic>;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Section header
              _buildSectionHeader(title, isCompleted),
              
              // Section content
              _buildSectionContent(sectionType, data),
            ],
          ),
        );
      },
    );
  }

  /// Build section header with title and completion status
  Widget _buildSectionHeader(String title, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.washyGreen.withOpacity(0.1)
            : AppColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          // Completion indicator
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? AppColors.washyGreen : AppColors.lightGrey,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 16,
                    )
                  : Text(
                      '!',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Section title
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isCompleted ? AppColors.washyGreen : AppColors.darkGrey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          
          // Arrow indicator
          Icon(
            Icons.keyboard_arrow_down,
            color: isCompleted ? AppColors.washyGreen : AppColors.lightGrey,
          ),
        ],
      ),
    );
  }

  /// Build section content based on section type
  Widget _buildSectionContent(
    NewOrderSectionType sectionType,
    Map<String, dynamic> data,
  ) {
    switch (sectionType) {
      case NewOrderSectionType.ADDRESS:
        return AddressSection(
          data: data,
          onChanged: (updatedData) => onSectionChanged(sectionType, updatedData),
        );
        
      case NewOrderSectionType.TIME:
        return TimeSection(
          data: data,
          onChanged: (updatedData) => onSectionChanged(sectionType, updatedData),
        );
        
      case NewOrderSectionType.PAYMENT:
        return PaymentSection(
          data: data,
          onChanged: (updatedData) => onSectionChanged(sectionType, updatedData),
        );
        
      case NewOrderSectionType.NOTES:
        return NotesSection(
          data: data,
          onChanged: (updatedData) => onSectionChanged(sectionType, updatedData),
        );
        
      case NewOrderSectionType.SKIP_SELECTION_DETAILS:
        return SkipSelectionSection(
          data: data,
          onChanged: (updatedData) => onSectionChanged(sectionType, updatedData),
        );
        
      default:
        return Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'قسم غير مدعوم: $sectionType',
            style: const TextStyle(
              color: AppColors.darkGrey,
              fontSize: 14,
            ),
          ),
        );
    }
  }
}
