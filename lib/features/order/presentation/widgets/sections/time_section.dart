import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Time section widget for selecting date and time slots
/// Matches the time selection functionality in Java NewOrderActivity
class TimeSection extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>) onChanged;

  const TimeSection({
    Key? key,
    required this.data,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<TimeSection> createState() => _TimeSectionState();
}

class _TimeSectionState extends State<TimeSection> {
  DateTime? selectedDate;
  String? selectedTimeSlot;
  List<String> availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    selectedDate = widget.data['selectedDate'];
    selectedTimeSlot = widget.data['selectedTimeSlot'];
    availableTimeSlots = widget.data['availableTimeSlots'] ?? [];
    
    // Default time slots if none provided
    if (availableTimeSlots.isEmpty) {
      availableTimeSlots = [
        '09:00 - 11:00',
        '11:00 - 13:00',
        '13:00 - 15:00',
        '15:00 - 17:00',
        '17:00 - 19:00',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date selection
          _buildDateSelection(),
          
          const SizedBox(height: 16),
          
          // Time slot selection
          _buildTimeSlotSelection(),
        ],
      ),
    );
  }

  /// Build date selection widget
  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'التاريخ',
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        
        const SizedBox(height: 8),
        
        InkWell(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.washyGreen,
                  size: 20,
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? _formatDate(selectedDate!)
                        : 'اختر التاريخ',
                    style: TextStyle(
                      color: selectedDate != null 
                          ? AppColors.darkGrey 
                          : AppColors.grey,
                      fontSize: 14,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.lightGrey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build time slot selection widget
  Widget _buildTimeSlotSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الوقت',
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Time slots grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 3,
          ),
          itemCount: availableTimeSlots.length,
          itemBuilder: (context, index) {
            final timeSlot = availableTimeSlots[index];
            final isSelected = selectedTimeSlot == timeSlot;
            
            return InkWell(
              onTap: () => _selectTimeSlot(timeSlot),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.washyGreen.withOpacity(0.1)
                      : AppColors.white,
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.washyGreen 
                        : AppColors.lightGrey,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    timeSlot,
                    style: TextStyle(
                      color: isSelected 
                          ? AppColors.washyGreen 
                          : AppColors.darkGrey,
                      fontSize: 12,
                      fontWeight: isSelected 
                          ? FontWeight.w600 
                          : FontWeight.w500,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Show date picker
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.washyGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        // Reset time slot when date changes
        selectedTimeSlot = null;
      });
      _notifyChange();
    }
  }

  /// Select time slot
  void _selectTimeSlot(String timeSlot) {
    setState(() {
      selectedTimeSlot = timeSlot;
    });
    _notifyChange();
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    const weekdays = [
      'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'
    ];
    
    final weekday = weekdays[date.weekday - 1];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    
    return '$weekday، $day $month $year';
  }

  /// Notify parent about changes
  void _notifyChange() {
    widget.onChanged({
      'selectedDate': selectedDate,
      'selectedTimeSlot': selectedTimeSlot,
      'availableTimeSlots': availableTimeSlots,
    });
  }
}
