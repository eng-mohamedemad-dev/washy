import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/utils/email_validator.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_state.dart';
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
      } else if (EmailValidator.isValidEmail(email)) {
        _isEmailValid = true;
        _validationMessage = null;
      } else {
        _isEmailValid = false;
        _validationMessage = null;
      }
    });
  }

  void _onSendCodePressed() {
    if (_isEmailValid) {
      context.read<EmailBloc>().add(
            SendEmailCodeEvent(email: _emailController.text),
          );
    } else {
      setState(() {
        _validationMessage = 'البريد الإلكتروني غير صحيح';
      });
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
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Top Close Button
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

                    // Welcome Text
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Text(
                        'أهلاً و سهلاً! أدخل الايميل',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorTitleBlack,
                          fontFamily: 'SourceSansPro',
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email Icon
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

                    const SizedBox(height: 60),

                    // Email Input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label
                          const Text(
                            'الايميل',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.colorLoginText,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // TextField
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _emailController,
                            builder: (context, value, child) {
                              return TextField(
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: AppColors.colorTitleBlack,
                                ),
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.colorViewSeparators,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.washyBlue,
                                    ),
                                  ),
                                  suffixIcon: value.text.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _emailController.clear();
                                            });
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.black54,
                                            size: 20,
                                          ),
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),

                          // Validation message
                          if (_validationMessage != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _validationMessage!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.colorRedError,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Bottom Buttons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Back button
                          GestureDetector(
                            onTap: _goBack,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: AppColors.washyGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Next button
                          GestureDetector(
                            onTap: _isEmailValid ? _onSendCodePressed : null,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _isEmailValid
                                    ? AppColors.washyBlue
                                    : Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
