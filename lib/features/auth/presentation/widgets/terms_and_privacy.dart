import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_strings.dart';

class TermsAndPrivacy extends StatefulWidget {
  const TermsAndPrivacy({super.key});

  @override
  State<TermsAndPrivacy> createState() => _TermsAndPrivacyState();
}

class _TermsAndPrivacyState extends State<TermsAndPrivacy> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox with text (matching Java layout)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value ?? false;
                  });
                },
                activeColor: AppColors.washyBlue,
                checkColor: AppColors.white,
                side: BorderSide(
                  color: AppColors.grey2.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Send me updates text
                    Text(
                      AppStrings.sendMe,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey1,
                        fontFamily: 'SourceSansPro',
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Unsubscribe text
                    Text(
                      AppStrings.unsubscribe,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.grey2,
                        fontFamily: 'SourceSansPro',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Terms and Privacy text (matching Java layout)
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey1,
              fontFamily: 'SourceSansPro',
            ),
            children: [
              TextSpan(text: AppStrings.subjectToThe),
              TextSpan(
                text: AppStrings.washywashPrivacy,
                style: TextStyle(
                  color: AppColors.washyBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
              TextSpan(text: AppStrings.and),
              TextSpan(
                text: AppStrings.termOfService,
                style: TextStyle(
                  color: AppColors.washyBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}