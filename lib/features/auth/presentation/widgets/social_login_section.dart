import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_strings.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback? onEmailLogin;

  const SocialLoginSection({
    super.key,
    this.onEmailLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email Login Button (matching Java layout only)
        SizedBox(
          width: double.infinity,
          height: AppDimensions.signUpContinueButtonHeight,
          child: ElevatedButton(
            onPressed: onEmailLogin,
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
                // Email Icon placeholder
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset(
                    'assets/images/email.png', // Email icon from Java
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
                ),
                const SizedBox(width: AppDimensions.countryCodeSpacing),
                const Text(
                  AppStrings.continueWithEmail,
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
}
