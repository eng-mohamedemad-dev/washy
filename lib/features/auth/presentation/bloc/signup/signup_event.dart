import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

/// Phone number changed event
class PhoneNumberChanged extends SignUpEvent {
  final String phoneNumber;

  const PhoneNumberChanged({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

/// Check mobile number (like Java's checkMobile)
class CheckMobilePressed extends SignUpEvent {
  final String phoneNumber;

  const CheckMobilePressed({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

/// Google Sign In event
class GoogleSignInPressed extends SignUpEvent {}

/// Facebook Sign In event
class FacebookSignInPressed extends SignUpEvent {}

/// Email registration event (navigates to EmailActivity)
class EmailSignUpPressed extends SignUpEvent {}

/// Skip login event
class SkipLoginPressed extends SignUpEvent {}

/// Navigate to mobile registration screen (Java's isMobileRegistrationShowed)
class NavigateToMobileRegistration extends SignUpEvent {}

/// Back to previous screen
class BackToPreviousScreen extends SignUpEvent {}

/// Clear phone number
class ClearPhoneNumber extends SignUpEvent {}

/// Send SMS verification code
class SendSmsVerificationCode extends SignUpEvent {
  final String phoneNumber;

  const SendSmsVerificationCode({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}