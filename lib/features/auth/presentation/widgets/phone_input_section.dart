import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_strings.dart';

class PhoneInputSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isMobileMode;
  final String phoneNumber;
  final bool isPhoneValid;
  final String? validationMessage;
  final ValueChanged<String> onPhoneNumberChanged;
  final VoidCallback onPhoneNumberTapped;

  const PhoneInputSection({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isMobileMode,
    required this.phoneNumber,
    required this.isPhoneValid,
    this.validationMessage,
    required this.onPhoneNumberChanged,
    required this.onPhoneNumberTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Phone Input Container (matching Java signupedittext.xml) - No label, no border
    return GestureDetector(
      onTap: onPhoneNumberTapped,
      child: Container(
        decoration: BoxDecoration(
          // No border like image
          border: Border(
            bottom: BorderSide(
              color: focusNode.hasFocus ? AppColors.washyBlue : AppColors.grey3,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              if (isMobileMode) ...[
                // Jordan Flag (matching Java layout)
                Container(
                  width: AppDimensions.jordanFlagSize,
                  height: AppDimensions.jordanFlagSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset(
                      'assets/images/jordan_flag.png',
                      width: AppDimensions.jordanFlagSize,
                      height: AppDimensions.jordanFlagSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Jordan flag colors placeholder
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF000000), // Black stripe
                                Color(0xFFFFFFFF), // White stripe
                                Color(0xFF007A3D), // Green stripe
                              ],
                              stops: [0.0, 0.33, 1.0],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.star,
                              size: 8,
                              color: Color(0xFFCE1126), // Red triangle
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Country Code (matching Java)
                const Text(
                  '+962',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.greyDark,
                    fontFamily: 'SourceSansPro',
                  ),
                ),

                const SizedBox(width: 8),

                // Phone Input Field (matching Java)
                Flexible(
                  child: TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                          9), // Jordan phone: 9 digits
                    ],
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.greyDark,
                      fontFamily: 'SourceSansPro',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppStrings.enterMobileNumber,
                      hintStyle: const TextStyle(
                        color: AppColors.grey2,
                        fontFamily: 'SourceSansPro',
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: onPhoneNumberChanged,
                  ),
                ),
              ] else ...[
                // Non-mobile mode - just show "Phone Number" text
                const Expanded(
                  child: Text(
                    AppStrings.yourMobile,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey2,
                      fontFamily: 'SourceSansPro',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
