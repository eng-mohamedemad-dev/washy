import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/constants/app_dimensions.dart';
import 'package:wash_flutter/core/constants/app_strings.dart';

class PhoneInputSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isMobileMode;
  final bool readOnly;
  final String phoneNumber;
  final bool isPhoneValid;
  final String? validationMessage;
  final ValueChanged<String> onPhoneNumberChanged;
  final VoidCallback onPhoneNumberTapped;
  final VoidCallback? onHintTextTapped;

  const PhoneInputSection({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isMobileMode,
    this.readOnly = false,
    required this.phoneNumber,
    required this.isPhoneValid,
    this.validationMessage,
    required this.onPhoneNumberChanged,
    required this.onPhoneNumberTapped,
    this.onHintTextTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Phone Input Container (matching Java signupedittext.xml) - No label, no border
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final isEmpty = value.text.isEmpty;
        final hasHintTapCallback = onHintTextTapped != null;

        return GestureDetector(
          onTap: () {
            if (readOnly) {
              onPhoneNumberTapped();
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            // Shorten underline length a bit more from both sides
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              // No border like image
              border: Border(
                bottom: BorderSide(
                  color: focusNode.hasFocus ? AppColors.grey3 : AppColors.grey3,
                  width: 2,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Row(
                children: [
                  if (isMobileMode) ...[
                    // Shift flag + country code a bit to the left without touching the underline
                    GestureDetector(
                      onTap: () {
                        if (controller.text.isEmpty) {
                          (onHintTextTapped ?? onPhoneNumberTapped)();
                        } else {
                          onPhoneNumberTapped();
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Transform.translate(
                        offset: const Offset(-35, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Jordan Flag (matching Java layout)
                            SizedBox(
                              width: AppDimensions.jordanFlagSize,
                              height: AppDimensions.jordanFlagSize,
                              child: Image.asset(
                                'assets/images/jordan_flag.png',
                                width: AppDimensions.jordanFlagSize,
                                height: AppDimensions.jordanFlagSize,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // If flag asset missing, keep area transparent (no box)
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Country Code (matching Java)
                            const Text(
                              '+962',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 8, 14, 19),
                                fontFamily: 'SourceSansPro',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Phone Input Field (matching Java) - Make tappable when empty
                    Expanded(
                      child: isEmpty && hasHintTapCallback
                          ? GestureDetector(
                              onTap: () {
                                // If onHintTextTapped is null, fallback to onPhoneNumberTapped
                                (onHintTextTapped ?? onPhoneNumberTapped)();
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppStrings.enterMobileNumber,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade400,
                                    fontFamily: 'SourceSansPro',
                                  ),
                                ),
                              ),
                            )
                          : TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              readOnly: readOnly,
                              onTap: () {
                                if (readOnly) {
                                  onPhoneNumberTapped();
                                }
                              },
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    9), // Jordan phone: 9 digits
                              ],
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.greyDark,
                                fontFamily: 'SourceSansPro',
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppStrings.enterMobileNumber,
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontFamily: 'SourceSansPro',
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: onPhoneNumberChanged,
                            ),
                    ),

                    // زر مسح (X) على يمين الحقل مثل الجافا
                    const SizedBox(width: 8),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller,
                      builder: (context, value, _) {
                        if (value.text.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return GestureDetector(
                          onTap: () {
                            controller.clear();
                            onPhoneNumberChanged('');
                          },
                          child: Image.asset(
                            'assets/images/ic_cancel.png',
                            width: 13,
                            height: 13,
                            errorBuilder: (context, error, stack) {
                              return const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.black54,
                              );
                            },
                          ),
                        );
                      },
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
      },
    );
  }
}
