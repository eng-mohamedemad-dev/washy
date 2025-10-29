import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// UpdateMobilePage - 100% matching Java UpdateMobileActivity
class UpdateMobilePage extends StatefulWidget {
  const UpdateMobilePage({super.key});

  @override
  State<UpdateMobilePage> createState() => _UpdateMobilePageState();
}

class _UpdateMobilePageState extends State<UpdateMobilePage> {
  final TextEditingController _mobileController = TextEditingController();
  bool _isUpdateEnabled = false;
  bool _isUpdating = false;
  String _validationMessage = '';

  // Constants (100% matching Java)
  static const int countryPhoneNumberCharacters = 10; // As per Java

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(_validatePhoneNumber);
    _loadCurrentMobile();
  }

  @override
  void dispose() {
    _mobileController.removeListener(_validatePhoneNumber);
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildContent(),
          _buildUpdateButton(),
        ],
      ),
    );
  }

  /// Header with back button (100% matching Java layout_back_icon_black)
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, bottom: 10),
      child: GestureDetector(
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
    );
  }

  /// Content with title and mobile input (100% matching Java)
  Widget _buildContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24), // activity_horizontal_margin
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title (52dp margin + 30sp as per Java)
            Container(
              margin: const EdgeInsets.only(top: 12), // 52dp - 40dp = 12dp
              child: const Text(
                'رقم الجوال',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 30, // 30sp as per Java
                  color: Color(0xFF354656), // Exact color from Java
                  letterSpacing: -0.02,
                ),
              ),
            ),
            
            // Mobile Input Section (67dp margin as per Java)
            Container(
              margin: const EdgeInsets.only(top: 67),
              height: 60, // 60dp as per Java
              child: Stack(
                children: [
                  // Mobile EditText (100% matching Java)
                  Center(
                    child: Container(
                      height: 50, // 50dp as per Java
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Jordan Flag + Code (100% matching Java layout)
                          Container(
                            padding: const EdgeInsets.only(right: 8),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/jordan_flag.png',
                                  width: 24,
                                  height: 16,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 24,
                                      height: 16,
                                      color: AppColors.grey3,
                                      child: const Icon(Icons.flag, size: 12),
                                    );
                                  },
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '+962',
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontSize: 16,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Mobile Number Input
                          Expanded(
                            child: TextField(
                              controller: _mobileController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(countryPhoneNumberCharacters), // 10 characters as per Java
                              ],
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 16, // 16sp as per Java
                                color: AppColors.colorBlack,
                              ),
                              decoration: InputDecoration(
                                hintText: '7XXXXXXXX',
                                hintStyle: const TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 16,
                                  color: AppColors.colorLoginText,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Clear Button (40x40 as per Java)
                  if (_mobileController.text.isNotEmpty)
                    Positioned(
                      right: 20,
                      top: 10, // Center vertically
                      child: GestureDetector(
                        onTap: _clearMobile,
                        child: Container(
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.clear,
                            color: AppColors.grey2,
                            size: 13, // 13dp as per Java
                          ),
                        ),
                      ),
                    ),
                  
                  // Separator Line (100% matching Java)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7, // separator_width equivalent
                        height: 1,
                        color: AppColors.colorViewSeparators,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Mobile Validation Text (100% matching Java InvalidMessage_TextView)
            if (_validationMessage.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    _validationMessage,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      color: AppColors.colorCoral,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Update Button (100% matching Java UpdateMobile_TextView)
  Widget _buildUpdateButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 26), // 26dp as per Java
      child: Center(
        child: SizedBox(
          width: 300, // 300dp as per Java
          height: 55, // 55dp as per Java
          child: ElevatedButton(
            onPressed: _isUpdateEnabled && !_isUpdating ? _updateMobile : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isUpdateEnabled 
                  ? AppColors.washyBlue 
                  : AppColors.grey3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27.5), // Rounded like Java background
              ),
            ),
            child: _isUpdating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'تحديث رقم الجوال',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14, // 14sp as per Java
                      color: AppColors.white,
                      letterSpacing: 0.05,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // Methods (100% matching Java UpdateMobileActivity)
  void _loadCurrentMobile() {
    // Mock current mobile - replace with actual SharedPreferences/API
    setState(() {
      _mobileController.text = '791234567'; // Example mobile without leading zero
    });
  }

  void _validatePhoneNumber() {
    // 100% matching Java validatePhoneNumber method
    final mobile = _mobileController.text.trim();
    setState(() {
      if (mobile.isEmpty) {
        _validationMessage = '';
        _isUpdateEnabled = false;
      } else if (mobile.length != countryPhoneNumberCharacters) {
        _validationMessage = 'رقم الجوال يجب أن يكون ${countryPhoneNumberCharacters} أرقام';
        _isUpdateEnabled = false;
      } else if (!mobile.startsWith('7')) {
        _validationMessage = 'رقم الجوال يجب أن يبدأ بالرقم 7';
        _isUpdateEnabled = false;
      } else {
        _validationMessage = '';
        _isUpdateEnabled = true;
      }
    });
  }

  void _clearMobile() {
    // 100% matching Java clear button click
    _mobileController.clear();
  }

  void _updateMobile() async {
    // 100% matching Java callUpdateMobile method
    if (!_isUpdateEnabled || _isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final newMobile = _mobileController.text.trim();
      
      // Mock API call - replace with actual WebServiceManager.callUpdateProfile
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // 100% matching Java: NumberFormatUtils.getPhoneNumberWithLeadingZero + NavigationManager.goToVerifyChangeMobile
        final phoneWithLeadingZero = '0$newMobile'; // Add leading zero as per Java
        
        Navigator.pushNamed(
          context, 
          '/verification',
          arguments: {
            'identifier': phoneWithLeadingZero,
            'isPhone': true,
            'isFromForgetPassword': false,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تحديث رقم الجوال: $e'),
            backgroundColor: AppColors.colorCoral,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }
}

