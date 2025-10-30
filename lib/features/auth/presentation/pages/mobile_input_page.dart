import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_state.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/phone_input_section.dart';
import 'package:wash_flutter/features/auth/presentation/pages/verification_page.dart';
import 'package:wash_flutter/features/auth/presentation/pages/password_page.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_back_button.dart';

/// MobileInputPage - Welcome page for mobile number input
class MobileInputPage extends StatefulWidget {
  const MobileInputPage({super.key});

  @override
  State<MobileInputPage> createState() => _MobileInputPageState();
}

class _MobileInputPageState extends State<MobileInputPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);

    // Initialize with phone input state
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
            // Show loading dialog
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
            }
          }
        },
        builder: (context, state) {
          final phoneInputState = state is LoginPhoneInputState
              ? state
              : const LoginPhoneInputState();

          return SafeArea(
            child: Column(
              children: [
                // Back button at top right
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.pageMargin),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // Title: "أهلاً و سهلاً أدخل"
                        const Text(
                          'أهلاً و سهلاً أدخل',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greyDark,
                            fontFamily: 'SourceSansPro',
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Subtitle: "رقم الموبايل"
                        const Text(
                          'رقم الموبايل',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyDark,
                            fontFamily: 'SourceSansPro',
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Phone illustration (simple placeholder)
                        GestureDetector(
                          onTap: () => _phoneFocusNode.requestFocus(),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 200,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Phone outline
                                Container(
                                  width: 150,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: AppColors.grey3,
                                      width: 3,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Smiley face on screen
                                      Icon(
                                        Icons.sentiment_satisfied,
                                        size: 60,
                                        color: AppColors.washyGreen,
                                      ),
                                      const SizedBox(height: 20),
                                      // Phone arms
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.waving_hand,
                                            size: 30,
                                            color: AppColors.washyBlue,
                                          ),
                                          Icon(
                                            Icons.waving_hand,
                                            size: 30,
                                            color: AppColors.washyBlue,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Decorative circles
                                ...List.generate(
                                  5,
                                  (index) => Positioned(
                                    left: (index * 40.0) % 150,
                                    top: (index * 50.0) % 200,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.washyGreen
                                            .withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Phone Number Input Section
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
                            _phoneFocusNode.requestFocus();
                          },
                          onHintTextTapped: () {
                            _phoneFocusNode.requestFocus();
                          },
                        ),

                        // Validation message
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

                        const SizedBox(height: 40),

                        // Navigation buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back button (green circle with arrow)
                            CustomBackButton(
                              onPressed: () => Navigator.of(context).pop(),
                            ),

                            // Continue button (green circle with dots) - only show if phone is valid
                            if (phoneInputState.isPhoneValid)
                              GestureDetector(
                                onTap: () {
                                  context.read<LoginBloc>().add(
                                        LoginCheckMobilePressed(
                                            phoneNumber: _phoneController.text),
                                      );
                                },
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: const BoxDecoration(
                                    color: AppColors.washyGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
