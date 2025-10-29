import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class TimeFurniturePage extends StatefulWidget {
  const TimeFurniturePage({super.key});

  @override
  State<TimeFurniturePage> createState() => _TimeFurniturePageState();
}

class _TimeFurniturePageState extends State<TimeFurniturePage> {
  DateTime? _selectedDate;
  String? _selectedTime;

  final List<String> _timeSlots = <String>[
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.washyBlue,
        title: const Text('اختيار التاريخ والوقت', style: TextStyle(color: AppColors.white)),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'التاريخ',
              style: TextStyle(color: AppColors.colorTitleBlack, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? now,
                  firstDate: now,
                  lastDate: now.add(const Duration(days: 30)),
                  helpText: 'اختر التاريخ',
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.colorViewSeparators),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'اضغط لاختيار التاريخ'
                          : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: AppColors.colorActionBlack),
                    ),
                    const Icon(Icons.calendar_today, color: AppColors.grey2),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'الفترة الزمنية',
              style: TextStyle(color: AppColors.colorTitleBlack, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((slot) {
                final selected = _selectedTime == slot;
                return ChoiceChip(
                  selected: selected,
                  label: Text(slot),
                  labelStyle: TextStyle(color: selected ? AppColors.white : AppColors.colorActionBlack),
                  selectedColor: AppColors.washyBlue,
                  backgroundColor: AppColors.white,
                  onSelected: (_) => setState(() => _selectedTime = slot),
                  shape: StadiumBorder(side: BorderSide(color: selected ? AppColors.washyBlue : AppColors.colorViewSeparators)),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.washyGreen),
                onPressed: (_selectedDate != null && _selectedTime != null)
                    ? () {
                        Navigator.pop(context, {
                          'date': _selectedDate,
                          'time': _selectedTime,
                        });
                      }
                    : null,
                child: const Text('تأكيد', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


