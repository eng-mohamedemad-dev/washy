import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_state.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_continue_button.dart';
import 'package:wash_flutter/features/auth/presentation/pages/verification_page.dart';

/// PasswordPage - Replicates Java PasswordActivity 100%
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

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    context.read<PasswordBloc>().add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onContinuePressed() {
    final state = context.read<PasswordBloc>().state as PasswordInitial;
    
    if (state.isNewUser) {
      context.read<PasswordBloc>().add(
        SetPasswordPressed(
          password: _passwordController.text,
          user: widget.user,
        ),
      );
    } else {
      context.read<PasswordBloc>().add(
        LoginWithPasswordPressed(
          password: _passwordController.text,
          user: widget.user,
        ),
      );
    }
  }

  void _onForgetPasswordPressed() {
    context.read<PasswordBloc>().add(
      ForgetPasswordPressed(user: widget.user),
    );
  }

  void _onTogglePasswordVisibility() {
    context.read<PasswordBloc>().add(TogglePasswordVisibility());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordBloc(
        sendVerificationCode: context.read(), // Get from parent provider
        user: widget.user,
        isNewUser: widget.isNewUser,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocConsumer<PasswordBloc, PasswordState>(
          listener: (context, state) {
            if (state is PasswordLoading) {
              // Show loading dialog like Java
              showDialog(
                context: context,
                barrierDismissible: false,
                useRootNavigator: true,
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
              
              if (state is PasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.colorRedError,
                  ),
                );
              } else if (state is PasswordSetSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.washyGreen,
                  ),
                );
              } else if (state is PasswordLoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Welcome back ${state.user.name ?? 'User'}!'),
                    backgroundColor: AppColors.washyGreen,
                  ),
                );
              } else if (state is NavigateToForgotPasswordVerification) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VerificationPage(
                      identifier: state.identifier,
                      isPhone: state.type == 'sms',
                      isFromForgetPassword: true,
                    ),
                  ),
                );
              } else if (state is NavigateToHome) {
                // Navigate to main app screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Welcome ${state.user.name ?? 'User'}!')),
                );
              }
            }
          },
          builder: (context, state) {
            final passwordState = state as PasswordInitial;
            
            return SafeArea(
              child: Column(
                children: [
                  // Header Section (like Java layout)
                  _buildHeader(passwordState),
                  
                  // Content Section
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
                      child: _buildContent(passwordState),
                    ),
                  ),

                  // Bottom Section (Continue Button)
                  _buildBottomSection(passwordState),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build header section (like Java's password header)
  Widget _buildHeader(PasswordInitial state) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.signUpHeaderTopMargin,
        left: AppDimensions.pageMargin,
        right: AppDimensions.pageMargin,
      ),
      child: Row(
        children: [
          CustomBackButton(onPressed: () => Navigator.of(context).pop()),
          Expanded(
            child: Text(
              state.isNewUser ? 'إنشاء كلمة سر' : 'أدخل كلمة السر',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.greyDark,
              ),
            ),
          ),
          const SizedBox(width: 40), // Balance the back button
        ],
      ),
    );
  }

  /// Build content section - مكيف حسب Java PasswordActivity
  Widget _buildContent(PasswordInitial state) {
    // Render different UI based on isNewUser (matching Java fillData() method)
    
    if (state.isNewUser) {
      // For new users: Create password flow
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          
          // Title for new users (matching Java: choose_password)
          const Text(
            'اختر كلمة السر',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.greyDark,
            ),
          ),
          
          const SizedBox(height: 5),
          
          // Hint for new users (matching Java: set_your_new_password)
          const Text(
            'ضع كلمة السر الجديدة',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.greyDark,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Password Label
          const Text(
            'كلمة السر',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.greyDark,
            ),
          ),
          
          const SizedBox(height: 13),
          
          // Password Input (matching Java layout)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _passwordFocusNode.hasFocus ? AppColors.washyBlue : AppColors.grey3,
                width: 1,
              ),
              color: AppColors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: !state.isPasswordVisible,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.colorBlack,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'أدخل كلمة السر',
                      hintStyle: TextStyle(
                        color: Color(0xFFBFC0C8),
                        fontSize: 13,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _onTogglePasswordVisibility,
                  icon: Icon(
                    state.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFFA1AAB3).withOpacity(0.5),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          
          // Validation message
          if (state.validationMessage != null) ...[
            const SizedBox(height: 15),
            Text(
              state.validationMessage!,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.colorRedError,
              ),
            ),
          ],
        ],
      );
    } else {
      // For existing users: Login flow with lock icon
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          
          // Lock icon with smiley face (matching Java welcome design)
          Stack(
            alignment: Alignment.center,
            children: [
              // Decorative elements (matching Java)
              Positioned(
                left: 40,
                top: 20,
                child: Text(
                  '+',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.washyGreen.withOpacity(0.3),
                  ),
                ),
              ),
              Positioned(
                right: 50,
                top: 40,
                child: Text(
                  '×',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.washyGreen.withOpacity(0.3),
                  ),
                ),
              ),
              Positioned(
                left: 60,
                bottom: 30,
                child: Text(
                  '+',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.washyGreen.withOpacity(0.3),
                  ),
                ),
              ),
              Positioned(
                right: 30,
                bottom: 50,
                child: Text(
                  '×',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.washyGreen.withOpacity(0.3),
                  ),
                ),
              ),
              
              // Main lock icon
              Container(
                width: 120,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.grey3,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lock shackle (green arch)
                    Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.washyGreen,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // Lock body with smiley face
                    Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(top: -10),
                      decoration: BoxDecoration(
                        color: AppColors.grey3,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          // Green circle (keyhole)
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.washyGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.circle,
                                size: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Smiley face
                          Positioned(
                            top: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.colorBlack,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.colorBlack,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Nose
                          Positioned(
                            top: 22,
                            left: 27,
                            child: Container(
                              width: 6,
                              height: 2,
                              color: AppColors.colorBlack,
                            ),
                          ),
                          // Smile
                          Positioned(
                            top: 32,
                            left: 16,
                            right: 16,
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.colorBlack,
                                  width: 2,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Welcome message (matching Java welcome_back and log_in)
          const Text(
            'أهلاً و سهلاً من جديد!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.greyDark,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'سجل الدخول للمتابعة',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.greyDark,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          // Password Label (right aligned like Java)
          const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'كلمة السر',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greyDark,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 13),
          
          // Password Input (matching Java layout)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _passwordFocusNode.hasFocus ? AppColors.washyBlue : AppColors.grey3,
                  width: 1,
                ),
                color: AppColors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: !state.isPasswordVisible,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.colorBlack,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'أدخل كلمة السر',
                        hintStyle: TextStyle(
                          color: Color(0xFFBFC0C8),
                          fontSize: 13,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _onTogglePasswordVisibility,
                    icon: Icon(
                      state.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFFA1AAB3).withOpacity(0.5),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Validation message
          if (state.validationMessage != null) ...[
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                state.validationMessage!,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.colorRedError,
                ),
              ),
            ),
          ],

          // Forget password link - only show for existing users (matching Java: forgetPasswordTextView.setVisibility(View.VISIBLE) for VERIFIED_CUSTOMER)
          if (!state.isNewUser) ...[
            const SizedBox(height: 20),
            TextButton(
              onPressed: _onForgetPasswordPressed,
              child: const Text(
                'نسيت كلمة السر',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF92CC74), // Matching Java green
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      );
    }
  }

  /// Build bottom section (Continue button like Java)
  Widget _buildBottomSection(PasswordInitial state) {
    // Matching Java: create_account for new users, log_in for existing users
    final buttonText = state.isNewUser ? 'إنشاء حساب' : 'سجل الدخول';
    
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.pageMargin),
      child: CustomContinueButton(
        text: buttonText,
        onPressed: _onContinuePressed,
        isEnabled: state.isNewUser 
            ? state.isPasswordValid 
            : state.password.length >= 6, // At least 6 characters for login
        isLoading: false,
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
