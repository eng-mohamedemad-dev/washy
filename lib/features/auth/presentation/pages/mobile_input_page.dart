import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_state.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/phone_input_section.dart';
import 'package:wash_flutter/features/auth/presentation/pages/verification_page.dart';
import 'package:wash_flutter/features/auth/presentation/pages/password_page.dart';

/// MobileInputPage - 100% matching Java SignUpActivity mobile registration section
/// Layout: layout_mobile_login.xml + SignUpActivity.java logic
class MobileInputPage extends StatefulWidget {
  const MobileInputPage({super.key});

  @override
  State<MobileInputPage> createState() => _MobileInputPageState();
}

class _MobileInputPageState extends State<MobileInputPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _showValidationError = false;
  bool _isPhoneValid =
      false; // Local state for immediate UI updates (matching Java enableView/disableView)

  @override
  void initState() {
    super.initState();

    // Initialize phone valid state (matching Java: disableView on init)
    _isPhoneValid = false;
    print('[MobileInputPage] initState: _isPhoneValid initialized to false');

    // Initialize with phone input state
    context
        .read<LoginBloc>()
        .add(const LoginPhoneNumberChanged(phoneNumber: ''));

    // Auto focus keyboard after 100ms (matching Java openKeyBoardAfterMilliSecond)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _phoneFocusNode.requestFocus();
        }
      });
    });
  }

  // Helper method to calculate phone validity (matching Java logic)
  bool _calculateIsPhoneValid(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return false;
    }

    const int countryPhoneNumberCharacters = 10;
    final trimmed = phoneNumber.trim();

    bool isValid;
    if (trimmed.startsWith('7')) {
      isValid =
          trimmed.length == (countryPhoneNumberCharacters - 1); // 9 digits
    } else {
      isValid = trimmed.length == countryPhoneNumberCharacters; // 10 digits
    }

    print('[MobileInputPage] _calculateIsPhoneValid: "$trimmed" -> $isValid');
    return isValid;
  }

  void _handleCheckMobile() {
    final phoneNumber = _phoneController.text.trim();

    // Get current BLoC state to check validation
    final currentState = context.read<LoginBloc>().state;
    final isPhoneValid = currentState is LoginPhoneInputState
        ? currentState.isPhoneValid
        : false;

    print(
        '[MobileInputPage] _handleCheckMobile called with: $phoneNumber, isValid=$isPhoneValid');

    // Early return if phone is not valid (shouldn't happen due to AbsorbPointer, but double check)
    if (!isPhoneValid || phoneNumber.isEmpty) {
      print('[MobileInputPage] Phone validation failed - showing error');
      setState(() {
        _showValidationError = true;
      });
      return;
    }

    // Hide keyboard (matching Java)
    _phoneFocusNode.unfocus();

    setState(() {
      _showValidationError = false;
    });

    print(
        '[MobileInputPage] Dispatching CheckMobileRequested event with phone: $phoneNumber');
    // Call check mobile API (via BLoC) - matching Java callCheckMobile
    // Important: This should NOT navigate back - it should call API and navigate based on response
    context.read<LoginBloc>().add(
          CheckMobileRequested(phoneNumber: phoneNumber),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Matching Java: colorBackGround = #f8fdfe
      backgroundColor: AppColors.colorBackground,
      body: BlocConsumer<LoginBloc, LoginState>(
        buildWhen: (previous, current) {
          // Always rebuild to ensure ValueListenableBuilder works correctly
          // The ValueListenableBuilder inside will only rebuild its own widget
          return true;
        },
        listener: (context, state) {
          print('[MobileInputPage] BLoC state changed: ${state.runtimeType}');

          if (state is LoginLoading) {
            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.black54,
              builder: (dialogContext) => PopScope(
                canPop: false, // Prevent back button from closing dialog
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.washyBlue),
                  ),
                ),
              ),
            );
          } else {
            // Dismiss loading dialog (only if it exists)
            // Use a flag to track if dialog is shown to avoid unnecessary pops
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              // Check if it's actually a dialog by trying to pop once
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state is LoginError) {
              print('[MobileInputPage] Error state: ${state.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.colorRedError,
                ),
              );
              // Don't navigate back - stay on page to show error
            } else if (state is LoginNavigateToVerification) {
              print('[MobileInputPage] Navigating to Verification page');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => VerificationPage(
                    identifier: state.identifier,
                    isPhone: state.type == 'sms',
                  ),
                ),
              );
            } else if (state is LoginNavigateToPassword) {
              print('[MobileInputPage] Navigating to Password page');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => PasswordPage(user: state.user),
                ),
              );
            } else if (state is LoginPhoneInputState) {
              // Update local state when phone input state changes
              if (state.validationMessage != null &&
                  state.validationMessage!.isNotEmpty) {
                setState(() {
                  _showValidationError = true;
                });
              } else {
                setState(() {
                  _showValidationError = false;
                });
              }
            }
          }
        },
        builder: (context, state) {
          // Always get the phone input state, even if state is different type
          LoginPhoneInputState phoneInputState;
          if (state is LoginPhoneInputState) {
            phoneInputState = state;
          } else if (state is LoginLoading) {
            // During loading, keep the previous phone input state
            final currentPhone = _phoneController.text.trim();
            phoneInputState = LoginPhoneInputState(
              phoneNumber: currentPhone,
              isPhoneValid: _calculateIsPhoneValid(currentPhone),
            );
          } else {
            // If state is not LoginPhoneInputState, try to get current phone from controller
            final currentPhone = _phoneController.text.trim();
            phoneInputState = LoginPhoneInputState(
              phoneNumber: currentPhone,
              isPhoneValid: _calculateIsPhoneValid(currentPhone),
            );
          }

          // Debug print to track state changes
          debugPrint(
              '[MobileInputPage Builder] State: ${state.runtimeType}, Phone: ${phoneInputState.phoneNumber}, Local isValid: $_isPhoneValid (BLoC: ${phoneInputState.isPhoneValid})');

          return SafeArea(
            child: Stack(
              children: [
                // Main Content
                Column(
                  children: [
                    // Back button - matching Java layout_back_icon_black
                    // Position: top left, margin 30dp
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                          left: 30,
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Image.asset(
                            'assets/images/ic_back_custom_black.png',
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.arrow_back,
                                color: AppColors.colorBlack,
                                size: 24,
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),

                            // Title: "أهلاً و سهلاً! أدخل" - matching Java PageHint_TextView
                            // textSize: 26sp, textStyle: bold, color: colorTitleBlack (#333333)
                            const Text(
                              'أهلاً و سهلاً! أدخل',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.colorTitleBlack, // #333333
                                fontFamily: 'SourceSansPro',
                                height: 1.3, // lineSpacingExtra: 7.5sp
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Phone Icon - matching Java mobile_number_page_icon
                            // Size: 161dp x 100dp, centered
                            Center(
                              child: Image.asset(
                                'assets/images/mobile_number_page_icon.png',
                                width: 161,
                                height: 100,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                    width: 161,
                                    height: 100,
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Phone Number Input Section
                            PhoneInputSection(
                              controller: _phoneController,
                              focusNode: _phoneFocusNode,
                              isMobileMode: true,
                              autoFocus:
                                  false, // Will be focused programmatically
                              phoneNumber: phoneInputState.phoneNumber,
                              isPhoneValid:
                                  _isPhoneValid, // Use local state for immediate UI updates
                              onPhoneNumberChanged: (value) {
                                // CRITICAL: This callback is called immediately when user types (matching Java onTextChanged)
                                // Matching Java: validatePhoneNumber logic called from onTextChanged
                                print(
                                    '[MobileInputPage] ⚡ onPhoneNumberChanged FIRED: "$value", controller.text="${_phoneController.text}"');

                                // Calculate validation immediately (matching Java validatePhoneNumber)
                                final trimmed = value.trim();
                                final isValid = _calculateIsPhoneValid(trimmed);

                                print(
                                    '[MobileInputPage] ⚡ Validation: "$trimmed" -> isValid=$isValid');

                                // Update state immediately for UI feedback (matching Java enableView/disableView)
                                // enableView: alpha=1.0, enabled=true, clickable=true, background=blue_button_continue
                                // disableView: alpha=0.3, enabled=false, clickable=false, background=gray_button_continue
                                if (mounted) {
                                  setState(() {
                                    _isPhoneValid = isValid;
                                    _showValidationError = false;
                                  });
                                  print(
                                      '[MobileInputPage] ⚡ setState called: _isPhoneValid=$isValid');
                                }

                                // Send to BLoC for state management (async, doesn't block UI update)
                                if (mounted && context.mounted) {
                                  context.read<LoginBloc>().add(
                                        LoginPhoneNumberChanged(
                                            phoneNumber: trimmed),
                                      );
                                }
                              },
                              onPhoneNumberTapped: () {
                                _phoneFocusNode.requestFocus();
                              },
                            ),

                            const SizedBox(height: 8),

                            // Validation message - matching Java InvalidMessage_TextView
                            // textSize: 11sp, color: colorRedError (#e0544b)
                            if (_showValidationError)
                              const Center(
                                child: Text(
                                  'Invalid number', // matching Java @string/invalid_number
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.colorRedError, // #e0544b
                                    fontFamily: 'SourceSansPro',
                                  ),
                                ),
                              ),

                            const SizedBox(height: 6),

                            // Continue button container - matching Java layout
                            // Matching Java: Continue button always visible, but enabled/disabled based on phone validation
                            // enableView: alpha=1.0, enabled=true, clickable=true, background=blue_button_continue (gradient)
                            // disableView: alpha=0.3, enabled=false, clickable=false, background=gray_button_continue (solid)
                            // CRITICAL: Use _isPhoneValid state variable updated via setState in onPhoneNumberChanged
                            // This matches Java's validatePhoneNumber -> enableView/disableView pattern
                            Builder(
                              builder: (context) {
                                print(
                                    '[MobileInputPage ContinueButton] Builder rebuild: _isPhoneValid=$_isPhoneValid');
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Continue button - matching Java Continue_ImageView (ImageView with drawable background)
                                    // Size: 50dp x 50dp, position: alignParentEnd, margin 27dp, marginTop 6dp
                                    AbsorbPointer(
                                      absorbing:
                                          !_isPhoneValid, // Disable interaction when not valid (matching Java setClickable(false))
                                      child: GestureDetector(
                                        onTap: _isPhoneValid
                                            ? () {
                                                print(
                                                    '[MobileInputPage] Continue button tapped - phone is valid');
                                                _handleCheckMobile();
                                              }
                                            : null,
                                        behavior: HitTestBehavior.opaque,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 27, top: 6),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              // Matching Java: blue_button_continue.xml gradient when enabled
                                              // gradient angle=74, startColor=#73D9A1, endColor=#62B5B3
                                              gradient: _isPhoneValid
                                                  ? const LinearGradient(
                                                      // Matching Java blue_button_continue.xml: angle="74" degrees
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Color(
                                                            0xFF73D9A1), // Exact match: startColor from Java
                                                        Color(
                                                            0xFF62B5B3), // Exact match: endColor from Java
                                                      ],
                                                    )
                                                  : null,
                                              // Matching Java: gray_button_continue.xml solid color when disabled
                                              // solid android:color="@color/grey_3" = #ECEEF0
                                              color: _isPhoneValid
                                                  ? null
                                                  : const Color(
                                                      0xFFECEEF0), // Exact grey_3 from Java colors.xml
                                              // Matching Java: corners android:radius="4dp"
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              shape: BoxShape
                                                  .rectangle, // Matching Java rectangle shape with rounded corners
                                            ),
                                            // Matching Java: enableView sets alpha=1.0, disableView sets alpha=0.3
                                            child: Opacity(
                                              opacity:
                                                  _isPhoneValid ? 1.0 : 0.3,
                                              child: Center(
                                                child: Image.asset(
                                                  'assets/images/go_to_next_page_icon.png',
                                                  width: 24,
                                                  height: 24,
                                                  color: Colors
                                                      .white, // White icon on colored background
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.white,
                                                      size: 24,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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
                  ],
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
