import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_strings.dart';
import 'package:wash_flutter/core/utils/email_validator.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_state.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_continue_button.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/email_input_section.dart';
import 'package:wash_flutter/features/auth/presentation/pages/verification_page.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailValid = false;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _emailFocusNode.addListener(_onFocusChanged);
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      if (email.isEmpty) {
        _isEmailValid = false;
        _validationMessage = null;
      } else if (EmailValidator.isValidEmail(email)) {
        _isEmailValid = true;
        _validationMessage = null;
      } else {
        _isEmailValid = false;
        _validationMessage = AppStrings.pleaseEnterValidEmail;
      }
    });
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _onSendCodePressed() {
    if (_isEmailValid) {
      context.read<EmailBloc>().add(SendEmailCodeEvent(email: _emailController.text));
    }
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<EmailBloc, EmailState>(
        listener: (context, state) {
          if (state is EmailLoading) {
            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.washyBlue),
                ),
              ),
            );
          } else {
            // Dismiss loading dialog
            if (Navigator.of(context).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            
            if (state is EmailChecked) {
              // Handle email check response - navigate based on account status
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Email checked: ${state.user.accountStatus}')),
              );
              // Navigate to appropriate screen based on account status
            } else if (state is EmailCodeSent) {
              // Navigate to verification page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VerificationPage(
                    identifier: state.email,
                    isPhone: false,
                  ),
                ),
              );
            } else if (state is EmailError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.colorRedError,
                ),
              );
            }
          }
        },
        child: SafeArea(
          child: Column(
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
                        'Continue with Email', // From Java strings.xml
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60), // Extra spacing like Java
                      
                      // Email Input Section (matching Java layout)
                      EmailInputSection(
                        emailController: _emailController,
                        focusNode: _emailFocusNode,
                        isEmailValid: _isEmailValid,
                        validationMessage: _validationMessage,
                        onEmailChanged: (value) {
                          // Handle email change if needed
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Description text (matching Java)
                      Text(
                        'We\'ll send a verification code to your email address',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey2,
                          fontFamily: 'SourceSansPro',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Send Verification Code Button (matching Java layout)
              Padding(
                padding: EdgeInsets.all(AppDimensions.signUpContinueButtonMargin),
                child: CustomContinueButton(
                  text: 'Send Verification Code',
                  onPressed: _onSendCodePressed,
                  isEnabled: _isEmailValid,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }
}
