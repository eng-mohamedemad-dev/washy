import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_state.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
import 'package:wash_flutter/features/auth/domain/usecases/send_verification_code.dart';
import 'package:wash_flutter/injection_container.dart' as di;
import 'package:wash_flutter/features/auth/presentation/widgets/custom_progress_dialog.dart';
import 'package:wash_flutter/features/auth/presentation/pages/verification_page.dart';
import 'package:wash_flutter/features/auth/data/datasources/auth_local_data_source.dart';

/// PasswordPage - Replicates Java PasswordActivity 100%
/// Layout based on log_in_password.xml for VERIFIED_CUSTOMER
/// Layout based on activity_password.xml for NEW_CUSTOMER/NOT_VERIFIED_CUSTOMER/ENTER_PASSWORD
class PasswordPage extends StatefulWidget {
  final User user;
  final bool isNewUser;

  const PasswordPage({
    super.key,
    required this.user,
    this.isNewUser = false,
  });

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    // Open keyboard after 500ms (matching Java openKeyBoardAfterMilliSecond)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _passwordFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Match Java logic: VERIFIED_CUSTOMER uses different layout than NEW_CUSTOMER
  bool get _isVerifiedCustomer => 
      widget.user.accountStatus == AccountStatus.verifiedCustomer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordBloc(
        sendVerificationCode: di.getIt<SendVerificationCode>(),
        authLocalDataSource: di.getIt<AuthLocalDataSource>(),
        user: widget.user,
        isNewUser: widget.isNewUser,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<PasswordBloc, PasswordState>(
          listener: (context, state) {
            if (state is PasswordLoading) {
              if (!_isDialogShowing) {
                _isDialogShowing = true;
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
                  _isDialogShowing = false;
                });
              }
            } else {
              // Only pop dialog if it's showing, not navigation
              if (_isDialogShowing) {
                final navigator = Navigator.of(context, rootNavigator: true);
                if (navigator.canPop()) {
                  navigator.pop();
                  _isDialogShowing = false;
                }
              }
              if (state is PasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.colorRedError,
                  ),
                );
              } else if (state is NavigateToForgotPasswordVerification) {
                // Navigate to verification page for forgot password (or directly to password reset if exceeds_limit)
                print('[PasswordPage] Navigating to forgot password verification, isExceedsLimit: ${state.isExceedsLimit}');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  if (state.isExceedsLimit) {
                    // If exceeds_limit, navigate directly to password reset page (like Java)
                    // No code was sent, so user cannot verify - go directly to create password
                    print('[PasswordPage] exceeds_limit detected, navigating directly to password reset');
                    Navigator.pushReplacementNamed(context, '/create-password', arguments: {
                      'isFromEmail': state.type == 'email',
                      'identifier': state.identifier,
                    });
                  } else {
                    // Normal flow: navigate to verification page to enter code
                    print('[PasswordPage] Normal flow - navigating to verification page');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VerificationPage(
                          identifier: state.identifier,
                          isPhone: state.type == 'sms',
                          isFromForgetPassword: true,
                        ),
                      ),
                    );
                  }
                });
              }
            }
          },
          builder: (context, state) {
            // Password should be obscured (shown as dots)
            final bool obscure = true;
            final String? validationMessage = state is PasswordInitial ? state.validationMessage : null;

            return SafeArea(
              child: Column(
                children: [
                  // Header: Only forward arrow (black) on right for back navigation
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Forward arrow (black) on right - for back navigation (RTL)
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.arrow_forward,
                            size: 30,
                            color: AppColors.greyDark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Content (scrollable)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Minimal spacing at top
                          const SizedBox(height: 5),

                          // Welcome Text - centered
                          // Arabic: "اهلا و سهلا من جديد! \n سجل الدخول للمتابعة"
                          if (_isVerifiedCustomer)
                            Center(
                              child: const Text(
                                'اهلا و سهلا من جديد!\nسجل الدخول للمتابعة',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey1, // #495767
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Let's Create a New Password",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey1,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Set your new password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.grey1,
                                  ),
                                ),
                              ],
                            ),

                          // Minimal spacing
                          SizedBox(height: _isVerifiedCustomer ? 10 : 15),

                          // Lock Icon in Center (only for verified customers)
                          if (_isVerifiedCustomer)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Image.asset(
                                  'assets/images/password_icon.png',
                                  width: 161,
                                  height: 100,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.lock_outline,
                                      size: 100,
                                      color: Color(0xFF41d99e),
                                    );
                                  },
                                ),
                              ),
                            ),

                          // Minimal spacing before input field
                          const SizedBox(height: 10),

                          // Green circular submit button - positioned above field on left
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _passwordController,
                            builder: (context, value, child) {
                              final password = value.text;
                              final canSubmit = password.length >= 6;
                              
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Green arrow button on left above field
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: GestureDetector(
                                      onTap: canSubmit
                                          ? () {
                                              if (_isVerifiedCustomer) {
                                                context.read<PasswordBloc>().add(
                                                      LoginWithPasswordPressed(
                                                        password: password,
                                                        user: widget.user,
                                                      ),
                                                    );
                                              } else {
                                                context.read<PasswordBloc>().add(
                                                      SetPasswordPressed(
                                                        password: password,
                                                        user: widget.user,
                                                      ),
                                                    );
                                              }
                                            }
                                          : null,
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: canSubmit
                                              ? const Color(0xFF92E068) // Light green when valid
                                              : const Color(0xFF92E068).withOpacity(0.3), // Transparent green when invalid
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: canSubmit
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.5),
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Password TextField
                                  TextField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocusNode,
                                    obscureText: obscure,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.center, // Always center the text in field
                                    decoration: InputDecoration(
                                      hintText: 'كلمة السر',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFFBFC0C8),
                                        fontSize: 13,
                                      ),
                                      // Thin underline border (line below only)
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.grey3, // Light grey line
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.grey3,
                                          width: 1,
                                        ),
                                      ),
                                      border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.grey3,
                                          width: 1,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 0,
                                        vertical: 12,
                                      ),
                                    ),
                                    onChanged: (val) {
                                      context.read<PasswordBloc>().add(
                                            PasswordChanged(password: val),
                                          );
                                    },
                                  ),
                                  // Error Message - shown only when user types and password is invalid
                                  if (validationMessage != null && password.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Center(
                                        child: Text(
                                          validationMessage,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.colorRedError,
                                          ),
                                          textAlign: TextAlign.center, // Center alignment
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),

                          // Forgot Password Link - closer to input field
                          if (_isVerifiedCustomer)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<PasswordBloc>().add(
                                          ForgetPasswordPressed(user: widget.user),
                                        );
                                  },
                                  child: const Text(
                                    'نسيت كلمة السر',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.grey1, // Black/dark grey matching Java
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
