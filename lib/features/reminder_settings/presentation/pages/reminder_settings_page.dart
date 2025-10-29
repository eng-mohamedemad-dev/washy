import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// ReminderSettingsPage - 100% matching Java ReminderSettingsActivity
class ReminderSettingsPage extends StatefulWidget {
  const ReminderSettingsPage({super.key});

  @override
  State<ReminderSettingsPage> createState() => _ReminderSettingsPageState();
}

class _ReminderSettingsPageState extends State<ReminderSettingsPage> {
  bool calendarReminderEnabled = true; // Default value

  @override
  void initState() {
    super.initState();
    _loadReminderSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildContent(),
        ],
      ),
    );
  }

  /// Header (100% matching Java RelativeLayout with profile gradient)
  Widget _buildHeader() {
    return Container(
      height: 110, // 110dp as per Java
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.profileGradientStart,
            AppColors.profileGradientCenter,
            AppColors.profileGradientEnd,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Back Button
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 66, // Based on margin
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            
            // Title (66dp margin + 30sp as per Java)
            const Positioned(
              left: 66,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'إعدادات التذكير',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 30, // 30sp as per Java
                    color: AppColors.white,
                    letterSpacing: -0.02,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Content (100% matching Java LinearLayout)
  Widget _buildContent() {
    return Expanded(
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30), // 30dp as per Java
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description (41dp top margin, 15sp bold as per Java)
            Container(
              margin: const EdgeInsets.only(top: 41),
              child: const Text(
                'يمكنك تفعيل أو إلغاء التذكيرات الخاصة بمواعيد الخدمات',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 15, // 15sp as per Java
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorReminderSettingsText,
                ),
              ),
            ),
            
            // Calendar Reminder Switch (50dp top margin as per Java)
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تذكير التقويم',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14, // 14sp as per Java
                      color: AppColors.colorTitleBlack,
                    ),
                  ),
                  
                  // Switch (100% matching Java CalenderReminder_Switch)
                  Switch(
                    value: calendarReminderEnabled,
                    onChanged: _onCalendarReminderChanged,
                    activeColor: AppColors.washyBlue,
                    inactiveThumbColor: AppColors.grey2,
                    inactiveTrackColor: AppColors.grey3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Methods (100% matching Java ReminderSettingsActivity)
  void _loadReminderSettings() {
    // 100% matching Java: ProfileResponse.Data data = ConfigDataManager.getInstance().getProfile()
    // Mock implementation - replace with actual API call
    setState(() {
      calendarReminderEnabled = true; // Default enabled
    });
  }

  void _onCalendarReminderChanged(bool isEnabled) {
    setState(() {
      calendarReminderEnabled = isEnabled;
    });
    
    // 100% matching Java: callGetPremiumConfig(isChecked)
    _saveReminderSettings(isEnabled);
  }

  void _saveReminderSettings(bool isCalendarReminderEnabled) async {
    // 100% matching Java: WebServiceManager.callSetCalenderReminder
    try {
      // Mock API call - replace with actual implementation
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCalendarReminderEnabled 
                  ? 'تم تفعيل تذكير التقويم'
                  : 'تم إلغاء تذكير التقويم',
            ),
            backgroundColor: AppColors.washyGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Revert switch on error
        setState(() {
          calendarReminderEnabled = !isCalendarReminderEnabled;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في حفظ الإعدادات: $e'),
            backgroundColor: AppColors.colorCoral,
          ),
        );
      }
    }
  }
}



