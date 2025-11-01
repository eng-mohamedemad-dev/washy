import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Phone number changed event (like Java's TextWatcher)
class LoginPhoneNumberChanged extends LoginEvent {
  final String phoneNumber;

  const LoginPhoneNumberChanged({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

/// Check mobile for login (existing user)
class LoginCheckMobilePressed extends LoginEvent {
  final String phoneNumber;

  const LoginCheckMobilePressed({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

/// Check mobile requested (matching Java callCheckMobile)
class CheckMobileRequested extends LoginEvent {
  final String phoneNumber;

  const CheckMobileRequested({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

/// Google Sign In for login
class LoginGoogleSignInPressed extends LoginEvent {}

/// Email login (navigate to email screen)
class LoginEmailPressed extends LoginEvent {}

/// Facebook Sign In for login
class LoginFacebookSignInPressed extends LoginEvent {}

/// Navigate to sign up
class NavigateToSignUpPressed extends LoginEvent {}

/// Back button pressed
class LoginBackPressed extends LoginEvent {}
