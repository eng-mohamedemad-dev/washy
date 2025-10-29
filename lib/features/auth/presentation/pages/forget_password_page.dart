import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_strings.dart';
import 'package:wash_flutter/core/utils/email_validator.dart';
import 'package:wash_flutter/core/routes/app_routes.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_state.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_continue_button.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/email_input_section.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
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
            if (Navigator.of(context).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state is EmailCodeSent) {
              Navigator.of(context).pushNamed(
                AppRoutes.verification,
                arguments: {
                  'identifier': state.email,
                  'isPhone': false,
                  'isFromForgetPassword': true,
                },
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
                        'Forget Password',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.greyDark,
                          fontFamily: 'SourceSansPro',
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
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
                      const SizedBox(height: 60),
                      EmailInputSection(
                        emailController: _emailController,
                        focusNode: _emailFocusNode,
                        isEmailValid: _isEmailValid,
                        validationMessage: _validationMessage,
                        onEmailChanged: (_) {},
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'We\'ll send a verification code to your email address',
                        style: const TextStyle(
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


