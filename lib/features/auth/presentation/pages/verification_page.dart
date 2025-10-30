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
    });
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

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
