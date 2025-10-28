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
              state.isNewUser ? 'Set Password' : 'Enter Password',
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

  /// Build content section
  Widget _buildContent(PasswordInitial state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        
        // Title and description (like Java)
        Text(
          state.isNewUser 
              ? 'Create a secure password'
              : 'Welcome back!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.greyDark,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          state.isNewUser 
              ? 'Your password should be at least 8 characters with uppercase, lowercase, number and special character'
              : 'Enter your password to continue',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.grey2,
            height: 1.4,
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Password Label (like Java's password label)
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.grey1,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Password Input (like Java's password input)
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _passwordFocusNode.hasFocus ? AppColors.washyBlue : AppColors.grey3,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: !state.isPasswordVisible,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.greyDark,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: state.isNewUser ? 'Create password' : 'Enter your password',
              hintStyle: const TextStyle(
                color: AppColors.grey2,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon: IconButton(
                onPressed: _onTogglePasswordVisibility,
                icon: Icon(
                  state.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.grey2,
                ),
              ),
            ),
          ),
        ),
        
        // Validation message (like Java's validation)
        if (state.validationMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            state.validationMessage!,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.colorRedError,
            ),
          ),
        ],

        // Forget password link (only for existing users, like Java)
        if (!state.isNewUser) ...[
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _onForgetPasswordPressed,
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.washyBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Build bottom section (Continue button like Java)
  Widget _buildBottomSection(PasswordInitial state) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.pageMargin),
      child: CustomContinueButton(
        text: state.isNewUser ? 'Set Password' : 'Continue',
        onPressed: _onContinuePressed,
        isEnabled: state.isNewUser ? state.isPasswordValid : state.password.isNotEmpty,
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
