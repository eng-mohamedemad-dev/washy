import 'package:equatable/equatable.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object?> get props => [];
}

/// Initial verification state
class VerificationInitial extends VerificationState {
  final String identifier; // phone or email
  final bool isPhone;
  final bool isFromForgetPassword;
  final String code;
  final bool isCodeComplete;
  final int remainingSeconds;
  final bool canResend;
  final String? validationMessage;

  const VerificationInitial({
    required this.identifier,
    required this.isPhone,
    this.isFromForgetPassword = false,
    this.code = '',
    this.isCodeComplete = false,
    this.remainingSeconds = 60, // Like Java's 60-second timer
    this.canResend = false,
    this.validationMessage,
  });

  @override
  List<Object?> get props => [
        identifier,
        isPhone,
        isFromForgetPassword,
        code,
        isCodeComplete,
        remainingSeconds,
        canResend,
        validationMessage,
      ];

  VerificationInitial copyWith({
    String? identifier,
    bool? isPhone,
    bool? isFromForgetPassword,
    String? code,
    bool? isCodeComplete,
    int? remainingSeconds,
    bool? canResend,
    String? validationMessage,
  }) {
    return VerificationInitial(
      identifier: identifier ?? this.identifier,
      isPhone: isPhone ?? this.isPhone,
      isFromForgetPassword: isFromForgetPassword ?? this.isFromForgetPassword,
      code: code ?? this.code,
      isCodeComplete: isCodeComplete ?? this.isCodeComplete,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      canResend: canResend ?? this.canResend,
      validationMessage: validationMessage ?? this.validationMessage,
    );
  }
}

/// Loading state (like Java's progress dialog)
class VerificationLoading extends VerificationState {
  const VerificationLoading();
}

/// Verification success (for regular verification)
class VerificationSuccess extends VerificationState {
  final User user;
  final String message;

  const VerificationSuccess({
    required this.user,
    this.message = 'Verification successful',
  });

  @override
  List<Object?> get props => [user, message];
}

/// Forgot password verification success
class ForgotPasswordVerificationSuccess extends VerificationState {
  final String identifier;
  final String message;

  const ForgotPasswordVerificationSuccess({
    required this.identifier,
    this.message = 'Verification successful. You can now reset your password.',
  });

  @override
  List<Object?> get props => [identifier, message];
}

/// Code sent successfully (for resend)
class CodeSentSuccess extends VerificationState {
  final String message;

  const CodeSentSuccess({
    this.message = 'Verification code sent successfully',
  });

  @override
  List<Object?> get props => [message];
}

/// Verification error
class VerificationError extends VerificationState {
  final String message;

  const VerificationError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Navigate to password reset
class NavigateToPasswordReset extends VerificationState {
  final String identifier;

  const NavigateToPasswordReset({required this.identifier});

  @override
  List<Object?> get props => [identifier];
}

/// Navigate to main screen
class NavigateToHome extends VerificationState {
  final User user;

  const NavigateToHome({required this.user});

  @override
  List<Object?> get props => [user];
}
