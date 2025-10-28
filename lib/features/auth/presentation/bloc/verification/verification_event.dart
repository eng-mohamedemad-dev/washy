import 'package:equatable/equatable.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object?> get props => [];
}

/// Code changed event (like Java's PIN input)
class VerificationCodeChanged extends VerificationEvent {
  final String code;
  final int position; // Which digit position (0-3)

  const VerificationCodeChanged({
    required this.code,
    required this.position,
  });

  @override
  List<Object?> get props => [code, position];
}

/// Verify code event (like Java's verify code)
class VerifyCodePressed extends VerificationEvent {
  final String code;
  final String identifier; // phone or email
  final bool isPhone;
  final bool isFromForgetPassword;

  const VerifyCodePressed({
    required this.code,
    required this.identifier,
    required this.isPhone,
    this.isFromForgetPassword = false,
  });

  @override
  List<Object?> get props => [code, identifier, isPhone, isFromForgetPassword];
}

/// Resend code event (like Java's resend code)
class ResendCodePressed extends VerificationEvent {
  final String identifier;
  final bool isPhone;
  final bool isFromForgetPassword;

  const ResendCodePressed({
    required this.identifier,
    required this.isPhone,
    this.isFromForgetPassword = false,
  });

  @override
  List<Object?> get props => [identifier, isPhone, isFromForgetPassword];
}

/// Timer tick event (like Java's countdown timer)
class TimerTick extends VerificationEvent {
  final int remainingSeconds;

  const TimerTick(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}

/// Start timer event
class StartTimer extends VerificationEvent {}

/// Clear code event
class ClearCode extends VerificationEvent {}

/// Back button pressed
class VerificationBackPressed extends VerificationEvent {}
