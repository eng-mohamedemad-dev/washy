import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class PinInputField extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final ValueChanged<String>? onCompleted;

  const PinInputField({
    super.key,
    required this.controllers,
    required this.focusNodes,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 60,
          height: 60,
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.greyDark,
              fontFamily: 'SourceSansPro',
            ),
            decoration: InputDecoration(
              counterText: '', // Hide character counter
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.grey3,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.washyBlue,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.grey3,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: AppColors.white,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.isNotEmpty) {
                // Move to next field
                if (index < 3) {
                  FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                } else {
                  // Last field, unfocus and check if complete
                  FocusScope.of(context).unfocus();
                  _checkCompletion();
                }
              } else {
                // Move to previous field if current is empty
                if (index > 0) {
                  FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                }
              }
            },
            onTap: () {
              // Clear the field when tapped (matching Java behavior)
              controllers[index].clear();
            },
          ),
        );
      }),
    );
  }

  void _checkCompletion() {
    String code = '';
    for (var controller in controllers) {
      code += controller.text;
    }
    
    if (code.length == 4 && onCompleted != null) {
      onCompleted!(code);
    }
  }
}
