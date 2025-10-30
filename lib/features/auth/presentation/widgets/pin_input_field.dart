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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 56,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controllers[index],
                focusNode: focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.greyDark,
                  fontFamily: 'SourceSansPro',
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 8),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (index < 3) {
                      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                    } else {
                      FocusScope.of(context).unfocus();
                      _checkCompletion();
                    }
                  } else {
                    if (index > 0) {
                      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                    }
                  }
                },
                onTap: () => controllers[index].clear(),
              ),
              // Underline like Java style
              Container(
                height: 2,
                color: AppColors.grey3,
              ),
            ],
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
