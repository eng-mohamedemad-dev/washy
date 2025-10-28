import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

/// Recreation of Java drawable: signupedittext.xml
class SignUpEditTextBorder extends StatelessWidget {
  final Widget child;
  final bool hasFocus;
  
  const SignUpEditTextBorder({
    super.key,
    required this.child,
    this.hasFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
        border: Border.all(
          color: hasFocus ? AppColors.blue1 : AppColors.grey3,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Recreation of Java drawable: after_typing_input_field.xml  
class AfterTypingInputFieldBorder extends StatelessWidget {
  final Widget child;
  
  const AfterTypingInputFieldBorder({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
        border: Border.all(
          color: AppColors.blue1,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue1.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Recreation of Java drawable: blue_button_continue.xml
class BlueButtonContinueStyle extends StatelessWidget {
  final Widget child;
  final bool isEnabled;
  final VoidCallback? onPressed;
  
  const BlueButtonContinueStyle({
    super.key,
    required this.child,
    this.isEnabled = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(25),
      color: isEnabled ? AppColors.washyBlue : AppColors.grey3,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: isEnabled ? onPressed : null,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: isEnabled ? const LinearGradient(
              colors: [AppColors.colorGreenButton, AppColors.washyBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ) : null,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Recreation of Java drawable: white_border_continue_button.xml
class WhiteBorderContinueButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  
  const WhiteBorderContinueButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(25),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onPressed,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppColors.white,
              width: 2.0,
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

