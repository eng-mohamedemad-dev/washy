import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/utils/email_validator.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_state.dart';
import 'package:wash_flutter/features/auth/presentation/pages/verification_page.dart';

/// EmailPage - Exactly matches Java activity_email.xml
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
  bool _showContinueButton = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _emailFocusNode.requestFocus();
      }
    });
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      if (email.isEmpty) {
        _isEmailValid = false;
        _validationMessage = null;
        _showContinueButton = false;
      } else if (EmailValidator.isValidEmail(email)) {
        _isEmailValid = true;
        _validationMessage = null;
        _showContinueButton = true;
      } else {
        _isEmailValid = false;
        _validationMessage = 'البريد الإلكتروني غير صحيح';
        _showContinueButton = false;
      }
    });
  }

  void _onSendCodePressed() {
    if (_isEmailValid) {
      context.read<EmailBloc>().add(
            SendEmailCodeEvent(email: _emailController.text),
          );
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
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.washyBlue),
                ),
              ),
            );
          } else {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state is EmailCodeSent) {
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
              // Back button at top (from layout_back_icon_black)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: _goBack,
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),
              ),

              // Main Content (from LinearLayout starting at line 9)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        // Welcome Text (line 15-29)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'أهلاً! ما هو بريدك الإلكتروني؟',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.colorTitleBlack,
                              height: 1.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Email Icon (line 31-36)
                        Image.asset(
                          'assets/images/email_icon.png',
                          width: 161,
                          height: 85,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 161,
                              height: 85,
                              decoration: const BoxDecoration(
                                color: AppColors.washyBlue,
                                shape: BoxShape.rectangle,
                              ),
                              child: const Icon(
                                Icons.email_outlined,
                                size: 60,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // Email Input Section (RelativeLayout 38-83)
                        Stack(
                          children: [
                            // Email TextField (line 46-63)
                            Center(
                              child: Container(
                                width: double.infinity,
                                constraints:
                                    const BoxConstraints(maxWidth: 300),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: TextField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.colorBlack,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'البريد الإلكتروني',
                                    hintStyle: TextStyle(
                                      color: AppColors.colorLoginText,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            // Clear button (line 65-80)
                            if (_emailController.text.isNotEmpty)
                              Positioned(
                                right: 30,
                                top: 15,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _emailController.clear();
                                    });
                                  },
                                  child: Image.asset(
                                    'assets/images/ic_cancel.png',
                                    width: 13,
                                    height: 13,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.close,
                                        size: 13,
                                        color: Colors.black54,
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Separator, Validation, and Continue Button (RelativeLayout 85-122)
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _emailController,
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                // Separator line (line 90-96)
                                Container(
                                  width: 100,
                                  height: 1,
                                  color: AppColors.colorViewSeparators,
                                ),

                                const SizedBox(height: 8),

                                // Validation message (line 98-108)
                                if (_validationMessage != null)
                                  Text(
                                    _validationMessage!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.colorRedError,
                                    ),
                                  )
                                else
                                  const SizedBox(height: 0),

                                const SizedBox(height: 6),

                                // Continue button (line 110-120) - green circular arrow
                                if (_showContinueButton &&
                                    value.text.isNotEmpty)
                                  GestureDetector(
                                    onTap: _onSendCodePressed,
                                    child: Image.asset(
                                      'assets/images/go_to_next_page_icon.png',
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 50,
                                          height: 50,
                                          decoration: const BoxDecoration(
                                            color: AppColors.washyGreen,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
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
