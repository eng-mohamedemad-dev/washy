import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// LanguageSelectionPage - Simple language selection feature
class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String selectedLanguage = 'ar'; // Default Arabic

  final List<LanguageOption> languages = [
    LanguageOption(
      code: 'ar',
      name: 'العربية',
      englishName: 'Arabic',
      flag: '🇯🇴',
    ),
    LanguageOption(
      code: 'en',
      name: 'English',
      englishName: 'English',
      flag: '🇺🇸',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildLanguageList()),
          _buildContinueButton(),
        ],
      ),
    );
  }

  /// Header with back button and title
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      color: AppColors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.colorTitleBlack,
                      size: 24,
                    ),
                  ),
                ),
                
                // Title
                const Expanded(
                  child: Text(
                    'اختيار اللغة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorTitleBlack,
                    ),
                  ),
                ),
                
                const SizedBox(width: 48), // Balance for back button
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Language Options List
  Widget _buildLanguageList() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'اختر لغة التطبيق المفضلة لديك',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 16,
              color: AppColors.grey2,
            ),
          ),
          const SizedBox(height: 24),
          ...languages.map((language) => _buildLanguageOption(language)),
        ],
      ),
    );
  }

  /// Language Option Item
  Widget _buildLanguageOption(LanguageOption language) {
    final isSelected = selectedLanguage == language.code;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppColors.washyBlue : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () => _selectLanguage(language.code),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Flag
                Text(
                  language.flag,
                  style: const TextStyle(fontSize: 32),
                ),
                
                const SizedBox(width: 16),
                
                // Language Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.name,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.washyBlue : AppColors.colorTitleBlack,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        language.englishName,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: isSelected ? AppColors.washyBlue.withOpacity(0.7) : AppColors.grey2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Selection Indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.washyBlue : AppColors.grey3,
                      width: 2,
                    ),
                    color: isSelected ? AppColors.washyBlue : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 16,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Continue Button
  Widget _buildContinueButton() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _applyLanguageChange,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.washyBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.5),
            ),
          ),
          child: const Text(
            'تطبيق التغيير',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Methods
  void _loadCurrentLanguage() {
    // Mock loading current language - replace with actual SharedPreferences
    setState(() {
      selectedLanguage = 'ar'; // Default Arabic
    });
  }

  void _selectLanguage(String languageCode) {
    setState(() {
      selectedLanguage = languageCode;
    });
  }

  void _applyLanguageChange() async {
    // Mock API call to save language preference
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppColors.washyBlue,
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              selectedLanguage == 'ar' 
                  ? 'تم تغيير اللغة إلى العربية'
                  : 'Language changed to English',
            ),
            backgroundColor: AppColors.washyGreen,
          ),
        );
        
        // Return selected language
        Navigator.pop(context, selectedLanguage);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تغيير اللغة: $e'),
            backgroundColor: AppColors.colorCoral,
          ),
        );
      }
    }
  }
}

/// Language Option Model
class LanguageOption {
  final String code;
  final String name;
  final String englishName;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.englishName,
    required this.flag,
  });
}

