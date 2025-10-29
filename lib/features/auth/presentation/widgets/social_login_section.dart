import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_strings.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onEmailLogin;
  final VoidCallback? onFacebookLogin;

  const SocialLoginSection({
    super.key,
    this.onGoogleLogin,
    this.onEmailLogin,
    this.onFacebookLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Login Button (matching Java layout)
        SizedBox(
          width: double.infinity,
          height: AppDimensions.signUpContinueButtonHeight,
          child: ElevatedButton(
            onPressed: onGoogleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.greyDark,
              side: BorderSide(color: AppColors.grey3, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google Icon placeholder
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Image.asset(
                    'assets/images/search.png', // Google icon from Java
                    width: 20,
                    height: 20,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.g_mobiledata,
                        size: 20,
                        color: Colors.blue,
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.countryCodeSpacing),
                Text(
                  AppStrings.continueWithGoogle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.signUpSocialButtonSpacing),

        // Email Login Button (matching Java layout)
        SizedBox(
          width: double.infinity,
          height: AppDimensions.signUpContinueButtonHeight,
          child: ElevatedButton(
            onPressed: onEmailLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.greyDark,
              side: BorderSide(color: AppColors.grey3, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email Icon placeholder
                Container(
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
                Text(
                  AppStrings.continueWithEmail,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.signUpSocialButtonSpacing),

        // Facebook Connect Button (matching Java layout)
        SizedBox(
          width: double.infinity,
          height: AppDimensions.signUpContinueButtonHeight,
          child: ElevatedButton(
            onPressed: onFacebookLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B5998), // Facebook blue
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Facebook Icon placeholder
                Container(
                  width: 20,
                  height: 20,
                  child: const Icon(
                    Icons.facebook,
                    size: 20,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: AppDimensions.countryCodeSpacing),
                Text(
                  AppStrings.connectWithOthers,
                  style: const TextStyle(
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
