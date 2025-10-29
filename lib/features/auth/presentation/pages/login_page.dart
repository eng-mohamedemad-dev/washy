import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_state.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_continue_button.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/phone_input_section.dart';
import 'package:wash_flutter/features/auth/presentation/pages/email_page.dart';
import 'package:wash_flutter/features/auth/presentation/pages/verification_page.dart';
import 'package:wash_flutter/features/auth/presentation/pages/password_page.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_bloc.dart';
import 'package:wash_flutter/injection_container.dart' as di;

/// LoginPage - Replicates Java LoginActivity 100%
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);

    // Initialize with phone input state (like Java)
    context
        .read<LoginBloc>()
        .add(const LoginPhoneNumberChanged(phoneNumber: ''));
  }

  void _onPhoneChanged() {
    context.read<LoginBloc>().add(
          LoginPhoneNumberChanged(phoneNumber: _phoneController.text),
        );
  }

  void _onContinuePressed() {
    context.read<LoginBloc>().add(
          LoginCheckMobilePressed(phoneNumber: _phoneController.text),
        );
  }

  void _onSignUpPressed() {
    context.read<LoginBloc>().add(NavigateToSignUpPressed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            // Show loading dialog like Java
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
            // Dismiss loading dialog
            if (Navigator.of(context).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.colorRedError,
                ),
              );
            } else if (state is LoginNavigateToEmail) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => di.getIt<EmailBloc>(),
                    child: const EmailPage(),
                  ),
                ),
              );
            } else if (state is LoginNavigateToVerification) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VerificationPage(
                    identifier: state.identifier,
                    isPhone: state.type == 'sms',
                  ),
                ),
              );
            } else if (state is LoginNavigateToPassword) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PasswordPage(user: state.user),
                ),
              );
            } else if (state is LoginNavigateToSignUp) {
              Navigator.of(context).pushReplacementNamed('/signup');
            } else if (state is LoginSuccess) {
              // Navigate to main app screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Welcome back ${state.user.name ?? 'User'}!')),
              );
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                // Header Section (like Java layout)
                _buildHeader(),

                // Content Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.pageMargin),
                    child: _buildContent(state),
                  ),
                ),

                // Bottom Section (Continue Button)
                _buildBottomSection(state),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build header section (like Java's login header)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.signUpHeaderTopMargin,
        left: AppDimensions.pageMargin,
        right: AppDimensions.pageMargin,
      ),
      child: Row(
        children: [
          CustomBackButton(onPressed: () => Navigator.of(context).pop()),
          const Expanded(
            child: Text(
              'تسجيل الدخول',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.greyDark,
                fontFamily: 'SourceSansPro',
              ),
            ),
          ),
          // Sign Up navigation (like Java's navigation to SignUp)
          GestureDetector(
            onTap: _onSignUpPressed,
            child: const Text(
              'إنشاء حساب',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.washyBlue,
                fontWeight: FontWeight.w600,
                fontFamily: 'SourceSansPro',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build content section
  Widget _buildContent(LoginState state) {
    final phoneInputState =
        state is LoginPhoneInputState ? state : const LoginPhoneInputState();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 60),

        // Logo (like Java's LoginActivity logo)
        Center(
          child: Image.asset(
            'assets/images/ic_logo_with_text.png',
            width: 202,
            height: 133,
            errorBuilder: (context, error, stackTrace) {
              return Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.washyBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_laundry_service,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'WashyWash®',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.greyDark,
                    ),
                  ),
                  const Text(
                    'a cleaner, greener wash',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey2,
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 40),

        // Clean with WashyWash hint (like Java)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'ملابس أنظف مع واشيواش',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.colorTextNotSelected,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Mobile label (like Java's login description) - Arabic
        const Text(
          'رقم الجوال',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.grey1,
            fontFamily: 'SourceSansPro',
          ),
        ),

        const SizedBox(height: 13),

        // Phone Number Input Section (like Java's phone input for login)
        PhoneInputSection(
          controller: _phoneController,
          focusNode: _phoneFocusNode,
          isMobileMode: true,
          phoneNumber: phoneInputState.phoneNumber,
          isPhoneValid: phoneInputState.isPhoneValid,
          onPhoneNumberChanged: (value) {
            // Already handled by listener
          },
          onPhoneNumberTapped: () {
            // Clear validation when tapped
          },
        ),

        // Validation message (like Java's validation for login)
        if (phoneInputState.validationMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            phoneInputState.validationMessage!,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.colorRedError,
            ),
          ),
        ],

        const SizedBox(height: 30),

        // OR Divider (like Java's divider) - Arabic
        const Row(
          children: [
            Expanded(child: Divider(color: Colors.grey, height: 0.4)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'أو',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontFamily: 'SourceSansPro',
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey, height: 0.4)),
          ],
        ),

        const SizedBox(height: 30),

        // Email Login Button only (no Facebook/Google) - Arabic
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            onPressed: () {
              context.read<LoginBloc>().add(LoginEmailPressed());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.greyDark,
              side: const BorderSide(color: AppColors.grey3, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email Icon
                Image.asset(
                  'assets/images/email.png',
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: AppColors.grey1,
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'تسجيل الدخول بالبريد الإلكتروني',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build bottom section (Continue button like Java)
  Widget _buildBottomSection(LoginState state) {
    final phoneInputState =
        state is LoginPhoneInputState ? state : const LoginPhoneInputState();

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.pageMargin),
      child: CustomContinueButton(
        text: 'تسجيل الدخول',
        onPressed: _onContinuePressed,
        isEnabled: phoneInputState.isPhoneValid,
        isLoading: state is LoginLoading,
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }
}
