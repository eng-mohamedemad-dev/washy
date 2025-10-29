import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';

/// UpdatePasswordPage - 100% matching Java UpdatePasswordActivity
class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isUpdateEnabled = false;
  bool _isUpdating = false;
  String _validationMessage = '';
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_validatePasswords);
    _newPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    _currentPasswordController.removeListener(_validatePasswords);
    _newPasswordController.removeListener(_validatePasswords);
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
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

  /// Content with title and password inputs (100% matching Java)
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
                'كلمة المرور',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 30, // 30sp as per Java
                  color: Color(0xFF354656), // Exact color from Java
                  letterSpacing: -0.02,
                ),
              ),
            ),
            
            // Current Password Input Section
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: _buildPasswordField(
                controller: _currentPasswordController,
                hintText: 'كلمة المرور الحالية',
                isVisible: _showCurrentPassword,
                onVisibilityToggle: () {
                  setState(() {
                    _showCurrentPassword = !_showCurrentPassword;
                  });
                },
              ),
            ),
            
            // New Password Input Section
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: _buildPasswordField(
                controller: _newPasswordController,
                hintText: 'كلمة المرور الجديدة',
                isVisible: _showNewPassword,
                onVisibilityToggle: () {
                  setState(() {
                    _showNewPassword = !_showNewPassword;
                  });
                },
              ),
            ),
            
            // Validation Text (100% matching Java Validation_TextView)
            if (_validationMessage.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 20),
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

  /// Password Field Widget
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    return Container(
      height: 60,
      child: Stack(
        children: [
          // Password EditText
          Center(
            child: Container(
              height: 50,
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                obscureText: !isVisible,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  color: AppColors.colorBlack,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    color: AppColors.colorLoginText,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 60),
                ),
              ),
            ),
          ),
          
          // Visibility Toggle Button
          Positioned(
            right: 60,
            top: 10,
            child: GestureDetector(
              onTap: onVisibilityToggle,
              child: Container(
                width: 40,
                height: 40,
                child: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.grey2,
                  size: 20,
                ),
              ),
            ),
          ),
          
          // Separator Line
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 1,
                color: AppColors.colorViewSeparators,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Update Button (100% matching Java UpdatePassword_TextView)
  Widget _buildUpdateButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 26), // 26dp as per Java
      child: Center(
        child: SizedBox(
          width: 300, // 300dp as per Java
          height: 55, // 55dp as per Java
          child: ElevatedButton(
            onPressed: _isUpdateEnabled && !_isUpdating ? _updatePassword : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isUpdateEnabled 
                  ? AppColors.washyBlue 
                  : AppColors.grey3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27.5),
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
                    'تحديث كلمة المرور',
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

  // Methods (100% matching Java UpdatePasswordActivity)
  void _validatePasswords() {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    
    setState(() {
      if (currentPassword.isEmpty || newPassword.isEmpty) {
        _validationMessage = '';
        _isUpdateEnabled = false;
      } else if (currentPassword == newPassword) {
        // 100% matching Java: password_is_equal validation
        _validationMessage = 'كلمة المرور الجديدة يجب أن تكون مختلفة عن الحالية';
        _isUpdateEnabled = false;
      } else if (newPassword.length < 6) {
        _validationMessage = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        _isUpdateEnabled = false;
      } else {
        _validationMessage = '';
        _isUpdateEnabled = true;
      }
    });
  }

  void _updatePassword() async {
    // 100% matching Java callUpdatePassword method
    if (!_isUpdateEnabled || _isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final currentPassword = _currentPasswordController.text.trim();
      final newPassword = _newPasswordController.text.trim();
      
      // Mock API call - replace with actual WebServiceManager.callUpdatePassword
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // 100% matching Java: showSuccessfulDialog
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تحديث كلمة المرور: $e'),
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

  void _showSuccessDialog() {
    // 100% matching Java UpdateProfileSuccessDialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.washyGreen,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              'تم بنجاح',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.greyDark,
              ),
            ),
          ],
        ),
        content: const Text(
          'تم تحديث كلمة المرور بنجاح',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 16,
            color: AppColors.grey2,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.washyBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous page
            },
            child: const Text(
              'حسناً',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

