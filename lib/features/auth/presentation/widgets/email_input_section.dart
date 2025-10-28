import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_strings.dart';
import 'package:wash_flutter/core/widgets/custom_border_container.dart';

class EmailInputSection extends StatelessWidget {
  final TextEditingController emailController;
  final FocusNode focusNode;
  final bool isEmailValid;
  final String? validationMessage;
  final ValueChanged<String> onEmailChanged;

  const EmailInputSection({
    super.key,
    required this.emailController,
    required this.focusNode,
    required this.isEmailValid,
    this.validationMessage,
    required this.onEmailChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Label (matching Java strings.xml)
        const Text(
          'Email Address',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.grey1,
            fontFamily: 'SourceSansPro',
          ),
        ),
        
        const SizedBox(height: AppDimensions.signUpPhoneInputTopMargin),
        
        // Email Input Container (matching Java continue_with_email.xml)
        SignUpEditTextBorder(
          hasFocus: focusNode.hasFocus,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.signUpPhoneInputPadding),
            child: Row(
              children: [
                // Email Icon
                Container(
                  width: AppDimensions.jordanFlagSize,
                  height: AppDimensions.jordanFlagSize,
                  child: Image.asset(
                    'assets/images/email.png',
                    width: AppDimensions.jordanFlagSize,
                    height: AppDimensions.jordanFlagSize,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: AppColors.grey1,
                      );
                    },
                  ),
                ),
                
                const SizedBox(width: AppDimensions.countryCodeSpacing),
                
                // Email Input Field (matching Java)
                Expanded(
                  child: TextFormField(
                    controller: emailController,
                    focusNode: focusNode,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.greyDark,
                      fontFamily: 'SourceSansPro',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your email address',
                      hintStyle: const TextStyle(
                        color: AppColors.grey2,
                        fontFamily: 'SourceSansPro',
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: onEmailChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Validation Message (matching Java)
        if (validationMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            validationMessage!,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.colorRedError,
              fontFamily: 'SourceSansPro',
            ),
          ),
        ],
      ],
    );
  }
}
