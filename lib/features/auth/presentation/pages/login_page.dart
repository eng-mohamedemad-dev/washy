import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_strings.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_state.dart';
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

                // Email Login Button at bottom (like image) - Green rounded button
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(LoginEmailPressed());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.washyGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0, // No shadow like image
                      ),
                      child: Text(
                        AppStrings.continueWithEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'SourceSansPro',
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build header section (just X button on top right)
  Widget _buildHeader() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.close,
            color: Colors.black,
            size: 28,
          ),
        ),
      ),
    );
  }

  /// Build content section
  Widget _buildContent(LoginState state) {
    final phoneInputState =
        state is LoginPhoneInputState ? state : const LoginPhoneInputState();

    return Column(
      children: [
        // Logo at top
        Padding(
          padding: const EdgeInsets.only(top: 40),
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

        // Clean with WashyWash hint (right-aligned like image)
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'ملابس أنظف مع واشيواش',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.colorTextNotSelected,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Phone Number Input Section (like Java's phone input for login) - No label above
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
      ],
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }
}
