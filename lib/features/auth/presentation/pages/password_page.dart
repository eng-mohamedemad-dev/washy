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
        authRepository: di.getIt(),
        user: widget.user,
        isNewUser: widget.isNewUser,
      ),
      child: PopScope(
        canPop: !_isDialogShowing, // Prevent back navigation if dialog is showing
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          if (didPop && _isDialogShowing) {
            // If pop happened while dialog is showing, close dialog first
            print('[PasswordPage] PopScope pop invoked while dialog showing, closing dialog...');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                final navigator = Navigator.of(context, rootNavigator: true);
                if (navigator.canPop()) {
                  navigator.pop();
                  _isDialogShowing = false;
                  print('[PasswordPage] ✅ Dialog closed via PopScope');
                } else {
                  _isDialogShowing = false;
                  print('[PasswordPage] ⚠️ Dialog state forced to false via PopScope');
                }
              }
            });
          }
        },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<PasswordBloc, PasswordState>(
          listener: (context, state) {
            print('[PasswordPage] State changed: ${state.runtimeType}, _isDialogShowing: $_isDialogShowing');
            
            if (state is PasswordLoading) {
              // Show loading dialog
              if (!_isDialogShowing) {
                _isDialogShowing = true;
                print('[PasswordPage] Showing loading dialog');
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
                  print('[PasswordPage] Dialog closed via then()');
                });
              }
            } else {
              // Close loading dialog first if it's showing (for ANY non-loading state)
              if (_isDialogShowing) {
                print('[PasswordPage] Attempting to close dialog...');
                // Use a future to ensure dialog closes asynchronously
                Future.microtask(() {
                  if (!mounted || !context.mounted) {
                    _isDialogShowing = false;
                    print('[PasswordPage] ⚠️ Widget unmounted, forcing dialog state to false');
                    return;
                  }
                  try {
                    final navigator = Navigator.of(context, rootNavigator: true);
                    if (navigator.canPop()) {
                      navigator.pop();
                      _isDialogShowing = false;
                      print('[PasswordPage] ✅ Dialog closed successfully');
                    } else {
                      // Force close dialog even if canPop() is false
                      _isDialogShowing = false;
                      print('[PasswordPage] ⚠️ Forced dialog state to false - navigator.canPop() was false');
                    }
                  } catch (e) {
                    print('[PasswordPage] ⚠️ Error closing dialog: $e');
                    _isDialogShowing = false;
                  }
                });
              }
              
              // Handle different states after loading
              if (state is PasswordError) {
                print('[PasswordPage] PasswordError detected: ${state.message}');
                // Wait a frame to ensure dialog is fully closed before showing SnackBar
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted || !context.mounted) {
                    print('[PasswordPage] ⚠️ Widget unmounted in PasswordError handler');
                    return;
                  }
                  try {
                    // Ensure dialog is definitely closed
                    if (_isDialogShowing) {
                      final navigator = Navigator.of(context, rootNavigator: true);
                      if (navigator.canPop()) {
                        navigator.pop();
                        _isDialogShowing = false;
                        print('[PasswordPage] ✅ Dialog force-closed in postFrameCallback');
                      }
                    }
                    // Clear any existing SnackBars first
                    ScaffoldMessenger.of(context).clearSnackBars();
                    // Show error message in SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.colorRedError,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  } catch (e) {
                    print('[PasswordPage] ⚠️ Error in PasswordError handler: $e');
                    _isDialogShowing = false;
                  }
                });
              } else if (state is NavigateToForgotPasswordVerification) {
                // Normal flow: code was sent, navigate to verification page to enter code
                print('[PasswordPage] ✅ Code was sent, navigating to verification page');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VerificationPage(
                        identifier: state.identifier,
                        isPhone: state.type == 'sms',
                        isFromForgetPassword: true,
                      ),
                    ),
                  );
                });
              } else if (state is NavigateToTermsAndConditions) {
                // Password set successfully - navigate to Terms and Conditions
                // Java: goToTermsAndConditionsPage() -> TermsAndConditionsActivity -> FillNameActivity
                print('[PasswordPage] ✅ Password set successfully, navigating to Terms and Conditions');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  // Navigate to Terms and Conditions page
                  Navigator.of(context).pushReplacementNamed('/terms-and-conditions', arguments: {
                    'nextPage': 'enter-name',
                    'user': state.user,
                  });
                });
              } else if (state is NavigateToHome) {
                // Login successful - navigate to home page
                print('[PasswordPage] ✅ Login successful, navigating to home');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  // Navigate to home page (replace current route)
                  Navigator.of(context).pushReplacementNamed('/home');
                });
              }
            }
          },
          builder: (context, state) {
            // Password should be obscured (shown as dots)
            final bool obscure = true;
            // Get validation message from state, but only show length validation if password is actually invalid
            final String? validationMessage = state is PasswordInitial 
                ? (state.password.length >= 6 ? null : state.validationMessage) // Only show if password is actually invalid
                : null;

            // Sync controller with state when returning to PasswordInitial after error
            if (state is PasswordInitial && state.password.isEmpty && _passwordController.text.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _passwordController.text.isNotEmpty) {
                  try {
                    _passwordController.clear();
                    print('[PasswordPage] ✅ Password controller cleared');
                  } catch (e) {
                    print('[PasswordPage] ⚠️ Error clearing controller: $e');
                  }
                }
              });
            }

            // Ensure dialog is closed if state is not loading
            if (state is! PasswordLoading && _isDialogShowing) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                if (_isDialogShowing && context.mounted) {
                  try {
                    final navigator = Navigator.of(context, rootNavigator: true);
                    if (navigator.canPop()) {
                      navigator.pop();
                      _isDialogShowing = false;
                      print('[PasswordPage] ✅ Dialog closed in builder');
                    } else {
                      _isDialogShowing = false;
                      print('[PasswordPage] ⚠️ Dialog state forced to false in builder');
                    }
                  } catch (e) {
                    print('[PasswordPage] ⚠️ Error closing dialog in builder: $e');
                    _isDialogShowing = false;
                  }
                }
              });
            }

            return SafeArea(
                      child: Column(
                        children: [
                  // Header: Only forward arrow (black) on right - for create password page
                          if (!_isVerifiedCustomer)
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Forward arrow (black) on right - for back navigation
                                  GestureDetector(
                                    onTap: () {
                                      print('[PasswordPage] Forward arrow tapped (back)');
                                      FocusScope.of(context).unfocus();
                                      
                                      if (_isDialogShowing) {
                                        final navigator = Navigator.of(context, rootNavigator: true);
                                        if (navigator.canPop()) {
                                          navigator.pop();
                                          _isDialogShowing = false;
                                          Future.delayed(const Duration(milliseconds: 100), () {
                                            if (mounted && Navigator.of(context).canPop()) {
                                              Navigator.of(context).pop();
                                            }
                                          });
                                          return;
                                        } else {
                                          _isDialogShowing = false;
                                        }
                                      }
                                      
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
                            )
                          else
                            // Header for verified customer (login page) - only forward arrow
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      print('[PasswordPage] Back arrow tapped');
                                      FocusScope.of(context).unfocus();
                                      
                                      if (_isDialogShowing) {
                                        final navigator = Navigator.of(context, rootNavigator: true);
                                        if (navigator.canPop()) {
                                          navigator.pop();
                                          _isDialogShowing = false;
                                          Future.delayed(const Duration(milliseconds: 100), () {
                                            if (mounted && Navigator.of(context).canPop()) {
                                              Navigator.of(context).pop();
                                            }
                                          });
                                          return;
                                        } else {
                                          _isDialogShowing = false;
                                        }
                                      }
                                      
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Title "اختر كلمة السر" - centered
                                const Text(
                                  'اختر كلمة السر',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey1,
                                  ),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                                const SizedBox(height: 20),
                                // Lock Icon in Center - password_icon.png
                                Center(
                                  child: Image.asset(
                                    'assets/images/password_icon.png',
                                    width: 161,
                                    height: 161,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.lock_outline,
                                        size: 100,
                                        color: Color(0xFF41d99e),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                          // Minimal spacing
                          SizedBox(height: _isVerifiedCustomer ? 10 : 30),

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

                          // Password Input Section
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _passwordController,
                            builder: (context, value, child) {
                              final password = value.text;
                              final canSubmit = password.length >= 6;
                              
                              if (_isVerifiedCustomer) {
                                // Login password layout (existing design)
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Green arrow button on left above field
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            print('[PasswordPage] Green button tapped, canSubmit: $canSubmit, password length: ${password.length}');
                                            FocusScope.of(context).unfocus();
                                            if (canSubmit && password.length >= 6) {
                                              print('[PasswordPage] Dispatching LoginWithPasswordPressed');
                                              context.read<PasswordBloc>().add(
                                                    LoginWithPasswordPressed(
                                                      password: password,
                                                      user: widget.user,
                                                    ),
                                                  );
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(28),
                                          child: Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: canSubmit
                                                  ? const Color(0xFF92E068)
                                                  : const Color(0xFF92E068).withOpacity(0.3),
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
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: 'كلمة السر',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFFBFC0C8),
                                          fontSize: 13,
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.grey3,
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
                                    if (validationMessage != null && password.isNotEmpty && password.length < 6)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Center(
                                          child: Text(
                                            validationMessage,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.colorRedError,
                                            ),
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              } else {
                                // Create password layout - matching image design
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Changed from center to start (left in RTL)
                                  children: [
                                    // Row containing green button and password field - directly under lock icon
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Green circular submit button - on the left (RTL), slightly above field
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, top: -8), // Raised slightly above field
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                print('[PasswordPage] Green button tapped, canSubmit: $canSubmit, password length: ${password.length}');
                                                FocusScope.of(context).unfocus();
                                                if (canSubmit && password.length >= 6) {
                                                  print('[PasswordPage] Dispatching SetPasswordPressed');
                                                  context.read<PasswordBloc>().add(
                                                        SetPasswordPressed(
                                                          password: password,
                                                          user: widget.user,
                                                        ),
                                                      );
                                                }
                                              },
                                              borderRadius: BorderRadius.circular(28),
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
                                        ),
                                        const SizedBox(width: 16),
                                        // Password TextField - underline only (no background)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 12),
                                            child: TextField(
                                            controller: _passwordController,
                                            focusNode: _passwordFocusNode,
                                            obscureText: obscure,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                            ),
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.center, // Center align for placeholder and text
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
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Error Message - shown only when user types and password is invalid
                                    if (validationMessage != null && password.isNotEmpty && password.length < 6)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          validationMessage,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.colorRedError,
                                          ),
                                          textAlign: TextAlign.right, // Right align for RTL
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                  ],
                                );
                              }
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
      ),
    );
  }
}
