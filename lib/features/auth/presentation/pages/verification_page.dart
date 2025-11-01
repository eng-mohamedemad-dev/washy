import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/verification/verification_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/verification/verification_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/verification/verification_state.dart';
import 'package:wash_flutter/features/auth/presentation/pages/password_page.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_progress_dialog.dart';
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
  bool _isAutoVerifying = false; // Flag to prevent duplicate verification
  
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
    // Close keyboard first
    FocusScope.of(context).unfocus();
    
    // Check if there's a loading dialog open and close it first
    if (_isLoadingDialogShown) {
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
        _isLoadingDialogShown = false;
        // Wait a bit before navigating back to ensure dialog is closed
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });
        return;
      }
    }
    
    // Allow back navigation (go back to email page)
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  String get _displayIdentifier {
    // Always show full identifier (matching Java - no masking in verification page)
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
                // Show loading dialog with animation (matching password page)
                if (!_isLoadingDialogShown) {
                  _isLoadingDialogShown = true;
                  print('[VerificationPage] Showing loading dialog');
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Stack(
                      children: [
                        ModalBarrier(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        const Center(
                          child: CustomProgressDialog(
                            iconAssetPath: 'assets/images/password_icon.png',
                            frameCount: 29,
                          ),
                        ),
                      ],
                    ),
                  ).then((_) {
                    _isLoadingDialogShown = false;
                    print('[VerificationPage] Dialog closed via then()');
                  });
                }
              } else {
                // Dismiss progress ONLY if we actually showed a dialog
                if (_isLoadingDialogShown) {
                  print('[VerificationPage] Attempting to close dialog...');
                  Future.microtask(() {
                    if (!mounted) {
                      _isLoadingDialogShown = false;
                      return;
                    }
                    final navigator = Navigator.of(context, rootNavigator: true);
                    if (navigator.canPop()) {
                      navigator.pop();
                      _isLoadingDialogShown = false;
                      print('[VerificationPage] ✅ Dialog closed successfully');
                    } else {
                      _isLoadingDialogShown = false;
                      print('[VerificationPage] ⚠️ Forced dialog state to false');
                    }
                  });
                }

                if (state is CodeSentSuccess) {
                  // Show success message after dialog closes
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم ارسال كود التحقق بنجاح'),
                          backgroundColor: Color(0xFF52D0A0), // Green success color
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  });
                } else if (state is VerificationError) {
                  // Reset auto-verify flag to allow retry
                  _isAutoVerifying = false;
                  // Show error message after dialog closes
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.colorRedError,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  });
                } else if (state is VerificationInitial && state.validationMessage != null && state.validationMessage!.isNotEmpty) {
                  // Reset auto-verify flag to allow retry
                  _isAutoVerifying = false;
                  // Show validation message (error) after dialog closes
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.validationMessage!),
                          backgroundColor: AppColors.colorRedError,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  });
                } else if (state is NavigateToPasswordReset) {
                  _isAutoVerifying = false; // Reset flag
                  Navigator.pushReplacementNamed(context, '/create-password', arguments: {
                    'isFromEmail': !widget.isPhone,
                  });
                } else if (state is NavigateToPassword) {
                  _isAutoVerifying = false; // Reset flag
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
                  _isAutoVerifying = false; // Reset flag
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                } else if (state is VerificationInitial) {
                  // Reset flag when returning to initial state (allows retry after error)
                  _isAutoVerifying = false;
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
                            onTap: () {
                              // Use BuildContext from builder, not from widget
                              FocusScope.of(context).unfocus();
                              
                              // Check if there's a loading dialog open and close it first
                              if (_isLoadingDialogShown) {
                                final navigator = Navigator.of(context, rootNavigator: true);
                                if (navigator.canPop()) {
                                  navigator.pop();
                                  _isLoadingDialogShown = false;
                                  // Wait a bit before navigating back to ensure dialog is closed
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    if (mounted && Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                  });
                                  return;
                                }
                              }
                              
                              // Allow back navigation (go back to email page)
                              if (mounted && Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
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
                                // Update code first to ensure it's current
                                String currentCode = '';
                                for (var controller in _controllers) {
                                  currentCode += controller.text;
                                }
                                
                                print('[VerificationPage] Green button tapped, isComplete: $isComplete, currentCode: $currentCode, _verificationCode: $_verificationCode');
                                
                                if (currentCode.length == 4 && !_isAutoVerifying) {
                                  _isAutoVerifying = true; // Prevent auto-verify from running
                                  print('[VerificationPage] Dispatching VerifyCodePressed event with code: $currentCode');
                                  // Verify code when complete
                                  context.read<VerificationBloc>().add(
                                    VerifyCodePressed(
                                      code: currentCode,
                                      identifier: widget.identifier,
                                      isPhone: widget.isPhone,
                                      isFromForgetPassword: widget.isFromForgetPassword,
                                    ),
                                  );
                                } else {
                                  print('[VerificationPage] Button tapped but code not complete or already verifying: codeLength=${currentCode.length}, _isAutoVerifying=$_isAutoVerifying');
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
              
              // Normal verification layout (matching Java verification_code.xml and image)
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Header: Only black forward arrow on right (matching image)
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Use BuildContext from builder, not from widget
                              FocusScope.of(context).unfocus();
                              
                              // Check if there's a loading dialog open and close it first
                              if (_isLoadingDialogShown) {
                                final navigator = Navigator.of(context, rootNavigator: true);
                                if (navigator.canPop()) {
                                  navigator.pop();
                                  _isLoadingDialogShown = false;
                                  // Wait a bit before navigating back to ensure dialog is closed
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    if (mounted && Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                  });
                                  return;
                                }
                              }
                              
                              // Allow back navigation (go back to email page)
                              if (mounted && Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
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
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Title: "رقم التثبيت" - centered, large (matching image)
                    const Text(
                      'رقم التثبيت',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.greyDark,
                        fontFamily: 'SourceSansPro',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Hint: "ايميل التثبيت تم ارساله الى:" (matching image)
                    Text(
                      widget.isPhone ? 'SMS verification code has been\nsent to:' : 'ايميل التثبيت تم ارساله الى:',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.grey1, // #a5a5a5 from Java
                        fontFamily: 'SourceSansPro',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Email/Phone: Full identifier in green color (matching image)
                    Text(
                      _displayIdentifier,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF91CC74), // green_1 from Java colors.xml
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 35),
                    
                    // PIN Input Fields: 4 fields with "0" placeholder and thin grey underlines (matching image)
                    _buildPinInputFields(),
                    
                    const SizedBox(height: 16),
                    
                    // Timer or Resend (matching image - timer is centered below fields)
                    if (!canResend) ...[
                      Text(
                        '00:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.grey1,
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
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
                            fontSize: 16,
                            color: AppColors.grey1,
                            fontFamily: 'SourceSansPro',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 20),
                    
                    // Green circular back button on left (matching image - bottom left)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _isCodeCompleteNotifier,
                          builder: (context, isComplete, child) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // Update code first to ensure it's current
                                String currentCode = '';
                                for (var controller in _controllers) {
                                  currentCode += controller.text;
                                }
                                
                                print('[VerificationPage] Green button (bottom) tapped, currentCode: $currentCode, _verificationCode: $_verificationCode');
                                
                                if (currentCode.length == 4 && !_isAutoVerifying) {
                                  _isAutoVerifying = true; // Prevent auto-verify from running
                                  print('[VerificationPage] Dispatching VerifyCodePressed event (bottom) with code: $currentCode');
                                  context.read<VerificationBloc>().add(
                                    VerifyCodePressed(
                                      code: currentCode,
                                      identifier: widget.identifier,
                                      isPhone: widget.isPhone,
                                      isFromForgetPassword: widget.isFromForgetPassword,
                                    ),
                                  );
                                } else {
                                  print('[VerificationPage] Button tapped but code not complete or already verifying: codeLength=${currentCode.length}, _isAutoVerifying=$_isAutoVerifying');
                                }
                              },
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isComplete 
                                      ? const Color(0xFF92E068) // Light green when complete
                                      : const Color(0xFF92E068).withOpacity(0.3), // Transparent when incomplete
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
                            );
                          },
                        ),
                      ),
                    ),
                    
                    // Empty space at bottom
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  ],
                ),
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
                  // Check code from controllers directly for accuracy
                  String currentCode = '';
                  for (var controller in _controllers) {
                    currentCode += controller.text;
                  }
                  
                  if (currentCode.length == 4 && !_isAutoVerifying) {
                    _isAutoVerifying = true; // Prevent duplicate verification
                    print('[VerificationPage] Auto-verifying code: $currentCode');
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted && currentCode.length == 4 && _isAutoVerifying) {
                        context.read<VerificationBloc>().add(
                          VerifyCodePressed(
                            code: currentCode,
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
