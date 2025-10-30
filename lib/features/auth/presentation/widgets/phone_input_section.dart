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
        margin: const EdgeInsets.symmetric(
            horizontal: 24), // مسافة جانبية معقولة مثل الجافا
        decoration: BoxDecoration(
          border: const Border(
            bottom: BorderSide(
              color: AppColors.grey3,
              width: 1.2,
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
              const Text(
                '+962',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 8, 14, 19),
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
                    LengthLimitingTextInputFormatter(9),
                  ],
                  style: const TextStyle(
                    fontSize: 18,
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
                    // زيادة مسافة اليمين داخل الحقل
                    contentPadding:
                        const EdgeInsets.only(left: 10, bottom: 12, right: 60),
                  ),
                  onChanged: onPhoneNumberChanged,
                  showCursor: !readOnly,
                  enableInteractiveSelection: !readOnly,
                ),
              ),
              const SizedBox(width: 4),
              // زر مسح يمين الحقل (يتفاعل مباشرة مع تغير النص)
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: hasText
                            ? Colors.grey.shade600
                            : Colors.grey.shade300,
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
