import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';

/// CreatePasswordPage - Create new password (100% matching Java CreatePasswordActivity)
class CreatePasswordPage extends StatefulWidget {
  final bool isFromEmail;

  const CreatePasswordPage({
    super.key,
    this.isFromEmail = false,
  });

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;
  String validationMessage = '';
  
  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validatePasswords);
    _confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  /// Header with back button
  Widget _buildHeader() {
    return Container(
      height: 70,
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
                  width: 66,
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.colorTitleBlack,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Content (100% matching Java layout)
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            // Title (100% matching Java let_us_create_password)
            const Text(
              'دعنا ننشئ كلمة مرور جديدة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.colorTitleBlack,
                height: 1.3,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Password Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.washyBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 40,
                color: AppColors.washyBlue,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // New Password Field (100% matching Java NewPassword_EditText)
            _buildPasswordField(
              controller: _newPasswordController,
              focusNode: _newPasswordFocusNode,
              hint: 'كلمة المرور الجديدة',
              isPasswordVisible: isPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            
            // Separator
            Container(
              width: AppDimensions.separatorWidth,
              height: 1,
              margin: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                color: AppColors.colorViewSeparators,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Confirm Password Field (100% matching Java ConfirmNewPassword_EditText)
            _buildPasswordField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              hint: 'تأكيد كلمة المرور',
              isPasswordVisible: isConfirmPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                });
              },
            ),
            
            // Separator
            Container(
              width: AppDimensions.separatorWidth,
              height: 1,
              margin: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                color: AppColors.colorViewSeparators,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Validation Message (100% matching Java InvalidMessage_TextView)
            if (validationMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: validationMessage.contains('صحيح') 
                      ? AppColors.washyGreen.withOpacity(0.1)
                      : AppColors.colorRedError.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: validationMessage.contains('صحيح') 
                        ? AppColors.washyGreen
                        : AppColors.colorRedError,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      validationMessage.contains('صحيح') 
                          ? Icons.check_circle 
                          : Icons.error,
                      color: validationMessage.contains('صحيح') 
                          ? AppColors.washyGreen 
                          : AppColors.colorRedError,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        validationMessage,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: validationMessage.contains('صحيح') 
                              ? AppColors.washyGreen 
                              : AppColors.colorRedError,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Password Requirements
            _buildPasswordRequirements(),
            
            const SizedBox(height: 40),
            
            // Continue Button (100% matching Java Continue_CardView)
            Container(
              width: double.infinity,
              height: 55,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27.5),
                ),
                child: InkWell(
                  onTap: _isFormValid() ? _onContinuePressed : null,
                  borderRadius: BorderRadius.circular(27.5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27.5),
                      gradient: _isFormValid() 
                          ? const LinearGradient(
                              colors: [AppColors.washyBlue, AppColors.washyGreen],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      color: _isFormValid() ? null : AppColors.grey3,
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'متابعة',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Password Field Widget (100% matching Java EditText with visibility toggle)
  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required bool isPasswordVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: !isPasswordVisible,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                color: AppColors.colorTitleBlack,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  color: AppColors.colorLoginText,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (_) {
                if (controller == _newPasswordController) {
                  _confirmPasswordFocusNode.requestFocus();
                } else {
                  _onContinuePressed();
                }
              },
            ),
          ),
          
          // Visibility Toggle Button
          GestureDetector(
            onTap: onVisibilityToggle,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.colorTextNotSelected,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Password Requirements Widget
  Widget _buildPasswordRequirements() {
    final newPassword = _newPasswordController.text;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'متطلبات كلمة المرور:',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.colorTitleBlack,
              ),
            ),
            
            const SizedBox(height: 12),
            
            _buildRequirementItem(
              text: 'على الأقل 8 أحرف',
              isValid: newPassword.length >= 8,
            ),
            _buildRequirementItem(
              text: 'يحتوي على حرف كبير',
              isValid: newPassword.contains(RegExp(r'[A-Z]')),
            ),
            _buildRequirementItem(
              text: 'يحتوي على حرف صغير',
              isValid: newPassword.contains(RegExp(r'[a-z]')),
            ),
            _buildRequirementItem(
              text: 'يحتوي على رقم',
              isValid: newPassword.contains(RegExp(r'[0-9]')),
            ),
            _buildRequirementItem(
              text: 'كلمتا المرور متطابقتان',
              isValid: newPassword.isNotEmpty && 
                       _confirmPasswordController.text.isNotEmpty &&
                       newPassword == _confirmPasswordController.text,
            ),
          ],
        ),
      ),
    );
  }

  /// Requirement Item Widget
  Widget _buildRequirementItem({
    required String text,
    required bool isValid,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isValid ? AppColors.washyGreen : AppColors.grey2,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14,
              color: isValid ? AppColors.washyGreen : AppColors.grey2,
            ),
          ),
        ],
      ),
    );
  }

  // Validation Methods (100% matching Java validation logic)
  void _validatePasswords() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      if (newPassword.isEmpty && confirmPassword.isEmpty) {
        validationMessage = '';
      } else if (newPassword.length < 8) {
        validationMessage = 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
      } else if (!newPassword.contains(RegExp(r'[A-Z]'))) {
        validationMessage = 'كلمة المرور يجب أن تحتوي على حرف كبير';
      } else if (!newPassword.contains(RegExp(r'[a-z]'))) {
        validationMessage = 'كلمة المرور يجب أن تحتوي على حرف صغير';
      } else if (!newPassword.contains(RegExp(r'[0-9]'))) {
        validationMessage = 'كلمة المرور يجب أن تحتوي على رقم';
      } else if (confirmPassword.isNotEmpty && newPassword != confirmPassword) {
        validationMessage = 'كلمات المرور غير متطابقة';
      } else if (newPassword == confirmPassword && confirmPassword.isNotEmpty) {
        validationMessage = 'كلمة المرور صحيحة ومطابقة';
      } else {
        validationMessage = '';
      }
    });
  }

  bool _isFormValid() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    return newPassword.isNotEmpty &&
           confirmPassword.isNotEmpty &&
           newPassword.length >= 8 &&
           newPassword.contains(RegExp(r'[A-Z]')) &&
           newPassword.contains(RegExp(r'[a-z]')) &&
           newPassword.contains(RegExp(r'[0-9]')) &&
           newPassword == confirmPassword;
  }

  // Action Methods (100% matching Java onClick logic)
  void _onContinuePressed() async {
    if (!_isFormValid() || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء كلمة المرور بنجاح'),
            backgroundColor: AppColors.washyGreen,
          ),
        );
        
        // Navigate based on source
        if (widget.isFromEmail) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء إنشاء كلمة المرور'),
            backgroundColor: AppColors.colorRedError,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
