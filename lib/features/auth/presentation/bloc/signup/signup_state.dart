import 'package:equatable/equatable.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

/// Loading state (like Java's progress dialog)
class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

/// Mobile registration mode (Java's isMobileRegistrationShowed = true)
class MobileRegistrationMode extends SignUpState {
  final String phoneNumber;
  final bool isPhoneValid;
  final String? validationMessage;

  const MobileRegistrationMode({
    this.phoneNumber = '',
    this.isPhoneValid = false,
    this.validationMessage,
  });

  @override
  List<Object?> get props => [phoneNumber, isPhoneValid, validationMessage];

  MobileRegistrationMode copyWith({
    String? phoneNumber,
    bool? isPhoneValid,
    String? validationMessage,
  }) {
    return MobileRegistrationMode(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      validationMessage: validationMessage ?? this.validationMessage,
    );
  }
}

/// Mobile check success (from checkMobile API)
class CheckMobileSuccess extends SignUpState {
  final User user;
  final String message;

  const CheckMobileSuccess({
    required this.user,
    this.message = '',
  });

  @override
  List<Object?> get props => [user, message];
}

/// Sign up success
class SignUpSuccess extends SignUpState {
  final User user;
  final String message;

  const SignUpSuccess({
    required this.user,
    this.message = '',
  });

  @override
  List<Object?> get props => [user, message];
}

/// Error state (like Java's error handling)
class SignUpError extends SignUpState {
  final String message;

  const SignUpError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Skip login success
class SkipLoginSuccess extends SignUpState {
  const SkipLoginSuccess();
}

/// Navigate to email registration
class NavigateToEmail extends SignUpState {
  const NavigateToEmail();
}

/// Navigate to verification (like Java's VerificationActivity)
class NavigateToVerification extends SignUpState {
  final String identifier; // phone or email
  final String type; // 'sms' or 'email'

  const NavigateToVerification({
    required this.identifier,
    required this.type,
  });

  @override
  List<Object?> get props => [identifier, type];
}

/// Navigate to password activity
class NavigateToPassword extends SignUpState {
  final User user;

  const NavigateToPassword(this.user);

  @override
  List<Object?> get props => [user];
}

/// Navigate to home/main screen
class NavigateToHome extends SignUpState {
  final User user;

  const NavigateToHome(this.user);

  @override
  List<Object?> get props => [user];
}