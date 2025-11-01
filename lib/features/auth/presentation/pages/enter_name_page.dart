import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_text_styles.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';

/// EnterNamePage - 100% matching Java FillNameActivity
/// Flow: TermsAndConditions -> EnterName -> Welcome
class EnterNamePage extends StatefulWidget {
  final User? user;
  
  const EnterNamePage({
    super.key,
    this.user,
  });

  @override
  State<EnterNamePage> createState() => _EnterNamePageState();
}

class _EnterNamePageState extends State<EnterNamePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  
  bool _canContinue = false;
  bool _isFirstNameFocused = false;
  bool _isLastNameFocused = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateFields);
    _lastNameController.addListener(_validateFields);
    _firstNameFocusNode.addListener(() {
      setState(() => _isFirstNameFocused = _firstNameFocusNode.hasFocus);
    });
    _lastNameFocusNode.addListener(() {
      setState(() => _isLastNameFocused = _lastNameFocusNode.hasFocus);
    });
    
    // Open keyboard after delay (matching Java: openKeyBoardAfterMilliSecond)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _firstNameFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_validateFields);
    _lastNameController.removeListener(_validateFields);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  void _validateFields() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    
    // Java: enableDisableContinueButton() checks if firstName.length >= 3 && lastName.length >= 3
    setState(() {
      _canContinue = firstName.length >= 3 && lastName.length >= 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Title "ادخل اسمك" - centered (matching image)
                    const Center(
                      child: Text(
                        'ادخل اسمك',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.greyDark,
                          fontFamily: AppTextStyles.fontFamily,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Phone Icon Illustration (matching image - smartphone with happy face)
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background decorative elements (light blue dashed lines, green circles)
                          Positioned(
                            child: Opacity(
                              opacity: 0.3,
                              child: CustomPaint(
                                size: const Size(200, 200),
                                painter: _PhoneBackgroundPainter(),
                              ),
                            ),
                          ),
                          // Phone icon (simplified - can be replaced with actual asset)
                          Container(
                            width: 140,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF41d99e),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.smartphone,
                              size: 60,
                              color: Color(0xFF41d99e),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Input Fields Section
                    _buildInputFields(),
                    
                    const SizedBox(height: 20),
                    
                    // "Already have an account? Log in" link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'هل لديك حساب؟ ',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey1,
                              fontFamily: AppTextStyles.fontFamily,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to login page
                              Navigator.of(context).pushReplacementNamed('/login');
                            },
                            child: const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue1,
                                fontFamily: AppTextStyles.fontFamily,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  /// Header with back arrow (matching image - left arrow button, right forward arrow)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Green circular button with white arrow (back)
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF92E068), // Light green
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          // Right: Black forward arrow
          GestureDetector(
            onTap: () {
              if (_canContinue) {
                _onContinuePressed();
              }
            },
            child: const Icon(
              Icons.arrow_forward,
              size: 30,
              color: AppColors.greyDark,
            ),
          ),
        ],
      ),
    );
  }

  /// Input Fields (matching Java layout - two fields side by side)
  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First Name Label
        const Padding(
          padding: EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            'الاسم الأول',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.grey1,
              fontFamily: AppTextStyles.fontFamily,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ),
        // First Name Input Field
        Container(
          decoration: BoxDecoration(
            color: _isFirstNameFocused 
                ? AppColors.white 
                : AppColors.grey4,
            border: Border.all(
              color: _isFirstNameFocused 
                  ? AppColors.green1 
                  : Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: TextField(
            controller: _firstNameController,
            focusNode: _firstNameFocusNode,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: AppTextStyles.fontFamily,
            ),
            decoration: const InputDecoration(
              hintText: 'الاسم الأول',
              hintStyle: TextStyle(
                color: Color(0xFFBFC0C8),
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              _lastNameFocusNode.requestFocus();
            },
          ),
        ),
        
        const SizedBox(height: 15),
        
        // Last Name Label
        const Padding(
          padding: EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            'اسم العائلة',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.grey1,
              fontFamily: AppTextStyles.fontFamily,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ),
        // Last Name Input Field
        Container(
          decoration: BoxDecoration(
            color: _isLastNameFocused 
                ? AppColors.white 
                : AppColors.grey4,
            border: Border.all(
              color: _isLastNameFocused 
                  ? AppColors.green1 
                  : Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: TextField(
            controller: _lastNameController,
            focusNode: _lastNameFocusNode,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: AppTextStyles.fontFamily,
            ),
            decoration: const InputDecoration(
              hintText: 'اسم العائلة',
              hintStyle: TextStyle(
                color: Color(0xFFBFC0C8),
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (_canContinue) {
                _onContinuePressed();
              }
            },
          ),
        ),
      ],
    );
  }

  /// Continue Button (matching Java Continue_CardView)
  Widget _buildContinueButton() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _canContinue ? _onContinuePressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _canContinue 
                ? AppColors.blue1 
                : AppColors.grey3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.5),
            ),
          ),
          child: const Text(
            'التالي',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// Handle Continue Button Press
  /// Java: updateName() -> calls WebServiceManager.callUpdateName() -> goToWelcomePage()
  void _onContinuePressed() {
    if (!_canContinue) return;
    
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    
    if (firstName.length >= 3 && lastName.length >= 3) {
      // TODO: Call API to update name (like Java: WebServiceManager.callUpdateName())
      // For now, navigate to Welcome page with full name
      final fullName = '$firstName $lastName';
      
      Navigator.of(context).pushReplacementNamed('/welcome', arguments: {
        'userName': fullName,
        'isFromNameRegistration': true,
      });
    }
  }
}

/// Custom Painter for phone background decorative elements
class _PhoneBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF41d99e)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Draw decorative circles and dashed lines
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw circles
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(
          center.dx + (i - 2) * 30,
          center.dy + (i % 2) * 20,
        ),
        8,
        paint,
      );
    }
    
    // Draw dashed lines (simplified)
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height * 0.7);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

