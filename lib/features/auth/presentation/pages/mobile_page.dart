import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_event.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:wash_flutter/features/auth/presentation/widgets/phone_input_section.dart';

/// Simple Mobile Page: title + subtitle + image + phone input + back button
class MobilePage extends StatefulWidget {
  const MobilePage({super.key});

  @override
  State<MobilePage> createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
    context
        .read<LoginBloc>()
        .add(const LoginPhoneNumberChanged(phoneNumber: ''));
  }

  void _onPhoneChanged() {
    context
        .read<LoginBloc>()
        .add(LoginPhoneNumberChanged(phoneNumber: _phoneController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back icon at top right
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_forward, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.pageMargin,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    const Text(
                      'أهلاً و سهلاً !أدخل',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 1, 1, 1),
                        fontFamily: 'SourceSansPro',
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'رقم الموبايل',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'SourceSansPro',
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Illustration from assets
                    Image.asset(
                      'assets/images/mobile_number_page_icon.png',
                      width: 200,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 5),
                    // Phone input
                    PhoneInputSection(
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      isMobileMode: true,
                      autoFocus: true,
                      phoneNumber: '',
                      isPhoneValid: false,
                      onPhoneNumberChanged: (_) {},
                      onPhoneNumberTapped: () {},
                    ),
                    const SizedBox(height: 24),
                    // Bottom back button (no continue action here)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomBackButton(
                            onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
