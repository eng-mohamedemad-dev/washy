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
  final bool autoFocus;
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
    this.autoFocus = false,
    required this.phoneNumber,
    required this.isPhoneValid,
    this.validationMessage,
    required this.onPhoneNumberChanged,
    required this.onPhoneNumberTapped,
    this.onHintTextTapped,
  });

  @override
  Widget build(BuildContext context) {
    final FocusNode effectiveFocusNode = readOnly
        ? FocusNode(canRequestFocus: false, skipTraversal: true)
        : focusNode;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: readOnly ? onPhoneNumberTapped : null,
      child: Container(
        // Matching Java: separator width, center horizontal
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          border: const Border(
            bottom: BorderSide(
              color: AppColors.colorViewSeparators, // #d5d5db
              width: 1.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10), // بدون padding أفقي إضافي
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // العلم وكود الدولة
              SizedBox(
                width: AppDimensions.jordanFlagSize,
                height: AppDimensions.jordanFlagSize,
                child: Image.asset(
                  'assets/images/jordan_flag.png',
                  width: AppDimensions.jordanFlagSize,
                  height: AppDimensions.jordanFlagSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Matching Java: CountryCode_TextView
              // textSize: 16sp, color: colorTitleBlack (#333333), alpha: 0.95
              const Text(
                '+962',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.colorTitleBlack, // #333333
                  fontFamily: 'SourceSansPro',
                ),
              ),
              const SizedBox(width: 10),
              // الحقل
              Expanded(
                child: TextFormField(
                  controller: controller,
                  focusNode: effectiveFocusNode,
                  readOnly: readOnly,
                  autofocus: autoFocus,
                  onTap: readOnly ? onPhoneNumberTapped : null,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                        10), // Matching Java: maxLength=10
                  ],
                  style: const TextStyle(
                    fontSize: 16, // Matching Java: textSize="16sp"
                    color: AppColors.colorBlack, // #000000
                    fontFamily: 'SourceSansPro',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppStrings.enterMobileNumber,
                    // Matching Java: textColorHint="#BFC0C8" (colorNewTextNotSelected)
                    hintStyle: const TextStyle(
                      color: AppColors.colorNewTextNotSelected, // #BFC0C8
                      fontFamily: 'SourceSansPro',
                    ),
                    // Matching Java: padding 60dp on both sides
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 12),
                  ),
                  onChanged: onPhoneNumberChanged,
                  showCursor: !readOnly,
                  enableInteractiveSelection: !readOnly,
                ),
              ),
              const SizedBox(width: 10),
              // Clear button - matching Java ClearText_RelativeLayout
              // Position: alignEnd, alignRight of Separator, size: 40dp x 40dp
              // Icon size: 13dp, src: ic_cancel
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  final hasText = value.text.isNotEmpty;
                  return GestureDetector(
                    onTap: hasText
                        ? () {
                            controller.clear();
                            onPhoneNumberChanged('');
                          }
                        : null,
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/ic_cancel.png',
                        width: 13,
                        height: 13,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.close,
                            size: 13,
                            color: hasText ? AppColors.grey2 : AppColors.grey3,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
