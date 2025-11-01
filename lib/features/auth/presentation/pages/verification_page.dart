import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/pin_input_field.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/verification/verification_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/verification/verification_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/verification/verification_state.dart';
import 'package:wash_flutter/features/auth/presentation/pages/password_page.dart';
import 'package:wash_flutter/injection_container.dart' as di;

class VerificationPage extends StatefulWidget {
  final String identifier; // Phone number or email
  final bool isPhone; // true for phone, false for email
  final bool isFromForgetPassword; // true if from forget password flow
  
  const VerificationPage({
    super.key,
    required this.identifier,
    this.isPhone = true,
    this.isFromForgetPassword = false,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  
  String _verificationCode = '';
  bool _isCodeComplete = false;
  final ValueNotifier<bool> _isCodeCompleteNotifier = ValueNotifier<bool>(false);
  
  // Timer functionality (matching Java)
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;
  bool _isLoadingDialogShown = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    
    // Add listeners to controllers
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() => _onCodeChanged());
    }
  }

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 60;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _onCodeChanged() {
    String code = '';
    for (var controller in _controllers) {
      code += controller.text;
    }
    
    setState(() {
      _verificationCode = code;
      _isCodeComplete = code.length == 4;
      _isCodeCompleteNotifier.value = code.length == 4;
    });
    
    print('[VerificationPage] Code changed: "$code", length: ${code.length}, isComplete: ${code.length == 4}');
  }

  void _onVerifyPressed() {
    if (_isCodeComplete) {
      // TODO: Implement verification logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verifying code: $_verificationCode')),
      );
    }
  }

  void _onResendPressed() {
    if (_canResend) {
      // TODO: Implement resend logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resending code to ${widget.identifier}')),
      );
      _startTimer();
    }
  }

  void _goBack() {
    // Allow back navigation (go back to email page)
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  String get _displayIdentifier {
    // For forget password, show full email/phone without masking
    if (widget.isFromForgetPassword) {
      return widget.identifier;
    }
    
    if (widget.isPhone) {
      // Format phone number for display (e.g., +962 ** *** **23)
      if (widget.identifier.length > 4) {
        return '${widget.identifier.substring(0, 4)} ** *** **${widget.identifier.substring(widget.identifier.length - 2)}';
      }
    } else {
      // Format email for display (e.g., ex***@***.com)
      final parts = widget.identifier.split('@');
      if (parts.length == 2) {
        final username = parts[0];
        final domain = parts[1];
        final maskedUsername = username.length > 2 
            ? '${username.substring(0, 2)}***' 
            : username;
        return '$maskedUsername@***.${domain.split('.').last}';
      }
    }
    return widget.identifier;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<VerificationBloc>(
        param1: {
          'identifier': widget.identifier,
          'isPhone': widget.isPhone,
          'isFromForgetPassword': widget.isFromForgetPassword,
        },
      ),
      child: WillPopScope(
        // Allow back navigation like Java (but prevent accidental back press)
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: BlocConsumer<VerificationBloc, VerificationState>(
            listener: (context, state) async {
              if (state is VerificationLoading) {
                _isLoadingDialogShown = true;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.washyBlue),
                    ),
                  ),
                );
              } else {
                // Dismiss progress ONLY if we actually showed a dialog
                if (_isLoadingDialogShown) {
                  if (Navigator.of(context, rootNavigator: true).canPop()) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                  _isLoadingDialogShown = false;
                }

                if (state is CodeSentSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification code sent successfully')),
                  );
                } else if (state is VerificationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: AppColors.colorRedError),
                  );
                } else if (state is NavigateToPasswordReset) {
                  Navigator.pushReplacementNamed(context, '/create-password', arguments: {
                    'isFromEmail': !widget.isPhone,
                  });
                } else if (state is NavigateToPassword) {
                  // Navigate to password page (matching Java PasswordActivity)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PasswordPage(
                        user: state.user,
                        isNewUser: true, // After verification, user is new and needs to create password
                      ),
                    ),
                  );
                } else if (state is NavigateToHome) {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                }
              }
            },
            builder: (context, state) {
              final seconds = state is VerificationInitial ? state.remainingSeconds : _secondsRemaining;
              final canResend = state is VerificationInitial ? state.canResend : _canResend;
              
              // Forget password layout (matching image)
              if (widget.isFromForgetPassword) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                    // Header: Only black forward arrow on right (for back navigation in RTL)
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: _goBack,
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 30,
                              color: AppColors.greyDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Title: "مش مشكلة.. الكل بنسى" centered
                    Text(
                      'مش مشكلة.. الكل بنسى',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey1,
                        fontFamily: 'SourceSansPro',
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Email info: "ايميل التثبيت تم ارساله الى:"
                    Text(
                      'ايميل التثبيت تم ارساله الى:',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grey2.withOpacity(0.9),
                        fontFamily: 'SourceSansPro',
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Email address in green/teal color
                    Text(
                      _displayIdentifier,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF41d99e), // Green/teal color matching image
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Sad face icon with background
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Faint background lines/shapes
                        Positioned(
                          child: Opacity(
                            opacity: 0.2,
                            child: CustomPaint(
                              size: const Size(200, 200),
                              painter: _ForgetPasswordBackgroundPainter(),
                            ),
                          ),
                        ),
                        // Sad face icon
                        Image.asset(
                          'assets/images/forget_password_icon.png',
                          width: 120,
                          height: 120,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback: Draw sad face using CustomPaint
                            return CustomPaint(
                              size: const Size(120, 120),
                              painter: _SadFacePainter(),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // PIN Input (4 fields with thin grey underlines)
                    _buildPinInputFields(),
                    
                    const SizedBox(height: 10),
                    
                    // Green circular back button on left - changes color when code is complete
                    // Positioned directly below PIN fields
                    // Use ValueListenableBuilder to ensure rebuild when code changes
                    ValueListenableBuilder<bool>(
                      valueListenable: _isCodeCompleteNotifier,
                      builder: (context, isComplete, child) {
                        // Remove print to prevent spam - only rebuild when value actually changes
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, top: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque, // Make entire area tappable
                              onTap: () {
                                print('[VerificationPage] Green button tapped, isComplete: $isComplete, code: $_verificationCode');
                                if (isComplete && _verificationCode.length == 4) {
                                  print('[VerificationPage] Dispatching VerifyCodePressed event');
                                  // Verify code when complete
                                  context.read<VerificationBloc>().add(
                                    VerifyCodePressed(
                                      code: _verificationCode,
                                      identifier: widget.identifier,
                                      isPhone: widget.isPhone,
                                      isFromForgetPassword: widget.isFromForgetPassword,
                                    ),
                                  );
                                } else {
                                  print('[VerificationPage] Button tapped but code not complete: isComplete=$isComplete, codeLength=${_verificationCode.length}');
                                }
                              },
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isComplete 
                                      ? const Color(0xFF92E068) // Solid green when code is complete
                                      : const Color(0xFF92E068).withOpacity(0.3), // Transparent green when incomplete
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: isComplete 
                                      ? Colors.white 
                                      : Colors.white.withOpacity(0.5),
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Timer or Resend button
                    if (!canResend) ...[
                      // Timer: "00:50" format
                      Text(
                        '00:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.grey1,
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else ...[
                      // Resend button when timer ends
                      TextButton(
                        onPressed: () {
                          context.read<VerificationBloc>().add(
                            ResendCodePressed(
                              identifier: widget.identifier,
                              isPhone: widget.isPhone,
                              isFromForgetPassword: widget.isFromForgetPassword,
                            ),
                          );
                        },
                        child: Text(
                          'إعادة الإرسال',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.grey1,
                            fontFamily: 'SourceSansPro',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    
                    // Empty space at bottom (using SizedBox instead of Spacer in scrollable)
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  ],
                ),
                );
              }
              
              // Normal verification layout (existing)
              return Column(
          children: [
            // Header Section (matching Java layout)
            Padding(
              padding: EdgeInsets.only(
                top: AppDimensions.signUpHeaderTopMargin,
                left: AppDimensions.activityHorizontalMargin,
                right: AppDimensions.activityHorizontalMargin,
              ),
              child: Row(
                children: [
                  CustomBackButton(onPressed: _goBack),
                  Expanded(
                    child: Text(
                      'رقم التثبيت',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.greyDark,
                        fontFamily: 'SourceSansPro',
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
            ),
            
            const SizedBox(height: 25),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.activityHorizontalMargin,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    
                    // Icon (matching Java)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.washyBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        widget.isPhone ? Icons.sms_outlined : Icons.email_outlined,
                        size: 40,
                        color: AppColors.washyBlue,
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Title (Arabic like Java)
                    const Text(
                      'رقم التثبيت',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.greyDark,
                        fontFamily: 'SourceSansPro',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description (Arabic like Java) + green email
                    Column(
                      children: [
                        const Text(
                          'إيميل التثبيت تم إرساله إلى:',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.grey2,
                            fontFamily: 'SourceSansPro',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _displayIdentifier,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.washyGreen,
                            fontFamily: 'SourceSansPro',
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // PIN Input (matching Java verification_code.xml)
                    PinInputField(
                      controllers: _controllers,
                      focusNodes: _focusNodes,
                      onCompleted: (code) {
                        setState(() {
                          _verificationCode = code;
                          _isCodeComplete = true;
                        });
                        
                        // Auto-verify when 4 digits are complete (like Java)
                        // But only after a small delay to ensure user finished typing
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted && _isCodeComplete) {
                            context.read<VerificationBloc>().add(
                              VerifyCodePressed(
                                code: code,
                                identifier: widget.identifier,
                                isPhone: widget.isPhone,
                                isFromForgetPassword: widget.isFromForgetPassword,
                              ),
                            );
                          }
                        });
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Timer and Resend (matching Java)
                    if (!canResend) ...[
                      Text(
                        '00:${seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.greyDark,
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else ...[
                      TextButton(
                        onPressed: () {
                          context.read<VerificationBloc>().add(
                            ResendCodePressed(
                              identifier: widget.identifier,
                              isPhone: widget.isPhone,
                              isFromForgetPassword: widget.isFromForgetPassword,
                            ),
                          );
                        },
                        child: Text(
                          'إعادة الإرسال',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.washyBlue,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SourceSansPro',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom row: left green circular back + centered timer already above
            const SizedBox(height: 12),
          ],
              );
            },
          ),
          ),
        ),
      ),
    );
  }

  // Build PIN input fields with thin grey underlines (matching image)
  Widget _buildPinInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          width: 50,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '0',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    color: AppColors.grey3,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.grey3,
                      width: 1,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.grey3,
                      width: index == 0 ? 1.5 : 1, // First field has slightly thicker line
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.grey3,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 3) {
                    _focusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _focusNodes[index - 1].requestFocus();
                  }
                  
                  // Update code state immediately
                  setState(() {
                    _onCodeChanged();
                  });
                  
                  // Auto-verify when 4 digits are complete (only if user doesn't manually press button)
                  if (_verificationCode.length == 4 && _isCodeComplete) {
                    print('[VerificationPage] Auto-verifying code: $_verificationCode');
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted && _isCodeComplete && _verificationCode.length == 4) {
                        context.read<VerificationBloc>().add(
                          VerifyCodePressed(
                            code: _verificationCode,
                            identifier: widget.identifier,
                            isPhone: widget.isPhone,
                            isFromForgetPassword: widget.isFromForgetPassword,
                          ),
                        );
                      }
                    });
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _isCodeCompleteNotifier.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}

// Custom painter for forget password background (faint lines/shapes)
class _ForgetPasswordBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBFC0C8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Draw faint cloud-like shapes or dashed lines
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width * 0.6, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.4, size.width * 0.7, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.8, size.width * 0.3, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.6, size.width * 0.2, size.height * 0.4);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for sad face (fallback if image not found)
class _SadFacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF41d99e)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    // Draw circle
    canvas.drawCircle(center, radius, paint);
    
    // Draw eyes (two small circles)
    final eyeRadius = 8.0;
    canvas.drawCircle(Offset(center.dx - 30, center.dy - 20), eyeRadius, paint);
    canvas.drawCircle(Offset(center.dx + 30, center.dy - 20), eyeRadius, paint);
    
    // Draw sad mouth (downward curve)
    final mouthPath = Path();
    mouthPath.moveTo(center.dx - 30, center.dy + 20);
    mouthPath.quadraticBezierTo(
      center.dx,
      center.dy + 35,
      center.dx + 30,
      center.dy + 20,
    );
    canvas.drawPath(mouthPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
