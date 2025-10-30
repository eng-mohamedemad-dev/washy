import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
// Removed unused imports
import 'package:wash_flutter/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/signup/signup_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/signup/signup_state.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_continue_button.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/phone_input_section.dart';
// removed social login/terms section to match Java flow
import 'package:wash_flutter/features/auth/presentation/pages/email_page.dart';
import 'package:wash_flutter/features/auth/presentation/pages/verification_page.dart';
import 'package:wash_flutter/features/auth/presentation/pages/password_page.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/pages/mobile_input_page.dart';
import 'package:wash_flutter/injection_container.dart' as di;

/// SignUpPage - Replicates Java SignUpActivity 100%
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
    // اجعل صفحة التسجيل تطابق الجافا: ابدأ مباشرة بوضع إدخال الموبايل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _phoneFocusNode.requestFocus(); // إجبار حقل الهاتف على أخذ focus
        context.read<SignUpBloc>().add(NavigateToMobileRegistration());
      }
    });
  }

  void _onPhoneChanged() {
    context.read<SignUpBloc>().add(
      PhoneNumberChanged(phoneNumber: _phoneController.text),
    );
  }

  void _onContinuePressed() {
    context.read<SignUpBloc>().add(
      CheckMobilePressed(phoneNumber: _phoneController.text),
    );
  }

  void _onSkipPressed() {
    context.read<SignUpBloc>().add(SkipLoginPressed());
  }

  void _onBackPressed() {
    final state = context.read<SignUpBloc>().state;
    if (state is MobileRegistrationMode) {
      context.read<SignUpBloc>().add(BackToPreviousScreen());
    } else {
      Navigator.of(context).pop();
    }
  }

  void _showMobileRegistration() {
    context.read<SignUpBloc>().add(NavigateToMobileRegistration());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpLoading) {
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
            
            if (state is SignUpError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.colorRedError,
                ),
              );
            } else if (state is NavigateToEmail) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => di.getIt<EmailBloc>(),
                    child: const EmailPage(),
                  ),
                ),
              );
            } else if (state is NavigateToVerification) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VerificationPage(
                    identifier: state.identifier,
                    isPhone: state.type == 'sms',
                  ),
                ),
              );
            } else if (state is NavigateToPassword) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PasswordPage(user: state.user),
                ),
              );
            } else if (state is NavigateToHome) {
              // Navigate to main app screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Welcome ${state.user.name ?? 'User'}!')),
              );
            } else if (state is SkipLoginSuccess) {
              // Navigate to main app screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login skipped successfully')),
              );
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                // Header Section (like Java layout)
                _buildHeader(state),
                
                // Content Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
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

  /// Build header section (like Java's header layout)
  Widget _buildHeader(SignUpState state) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.signUpHeaderTopMargin,
        left: AppDimensions.pageMargin,
        right: AppDimensions.pageMargin,
      ),
      child: Row(
        children: [
          CustomBackButton(onPressed: _onBackPressed),
          Expanded(
            child: Text(
              state is MobileRegistrationMode ? 'Register' : 'Sign Up',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.greyDark,
              ),
            ),
          ),
          // Login navigation (like Java's navigateLogin_TexyView)
          if (state is! MobileRegistrationMode)
            GestureDetector(
              onTap: () {
                // Navigate to LoginPage
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Log In',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.washyBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build content section based on state
  Widget _buildContent(SignUpState state) {
    // دائماً اعرض وضع إدخال الموبايل مثل الجافا
    final effectiveState = state is MobileRegistrationMode
        ? state
        : const MobileRegistrationMode(
            phoneNumber: '', isPhoneValid: false, validationMessage: null);
    return _buildMobileRegistrationContent(effectiveState);
  }

  // لم نعد نستخدم المحتوى الابتدائي (أزرار الطرق المتعددة)

  /// Build mobile button (like Java's mobile login method)
  Widget _buildMobileButton() {
    return GestureDetector(
      onTap: _showMobileRegistration,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey3, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Jordan flag icon
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.washyBlue.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.phone,
                size: 16,
                color: AppColors.washyBlue,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Continue with Phone Number',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.greyDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.grey2,
            ),
          ],
        ),
      ),
    );
  }

  /// Build mobile registration content (like Java's mobile registration section)
  Widget _buildMobileRegistrationContent(MobileRegistrationMode state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        
        // Phone Number Input Section (like Java's phone input)
        PhoneInputSection(
          controller: _phoneController,
          focusNode: _phoneFocusNode,
          isMobileMode: true,
          readOnly: true, // الحقل لا يقبل الكتابة مباشرة
          phoneNumber: state.phoneNumber,
          isPhoneValid: state.isPhoneValid,
          onPhoneNumberChanged: (value) {
            // Already handled by listener
          },
          onPhoneNumberTapped: () async {
            // انتقل إلى MobileInputPage وانتظر الرقم المدخل
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => di.getIt<LoginBloc>(),
                  child: const MobileInputPage(),
                ),
              ),
            );
            // عند العودة، إذا عاد رقم، ضعه في الحقل
            if (result != null && result is String) {
              setState(() {
                _phoneController.text = result;
              });
            }
          },
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

        const SizedBox(height: 30),

        // Terms text (like Java's terms)
        const Text(
          'By continuing, you agree to receive SMS messages from WashyWash. Message and data rates may apply.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey2,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build bottom section (Continue button)
  Widget _buildBottomSection(SignUpState state) {
    if (state is MobileRegistrationMode) {
      return Padding(
        padding: const EdgeInsets.all(AppDimensions.pageMargin),
        child: CustomContinueButton(
          text: 'Continue',
          onPressed: _onContinuePressed,
          isEnabled: state.isPhoneValid,
          isLoading: false,
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }
}