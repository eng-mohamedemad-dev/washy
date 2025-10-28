import 'package:equatable/equatable.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial login state
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Loading state (like Java's progress dialog)
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Phone input state (like Java's phone validation)
class LoginPhoneInputState extends LoginState {
  final String phoneNumber;
  final bool isPhoneValid;
  final String? validationMessage;

  const LoginPhoneInputState({
    this.phoneNumber = '',
    this.isPhoneValid = false,
    this.validationMessage,
  });

  @override
  List<Object?> get props => [phoneNumber, isPhoneValid, validationMessage];

  LoginPhoneInputState copyWith({
    String? phoneNumber,
    bool? isPhoneValid,
    String? validationMessage,
  }) {
    return LoginPhoneInputState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      validationMessage: validationMessage ?? this.validationMessage,
    );
  }
}

/// Check mobile success (existing user found)
class LoginCheckMobileSuccess extends LoginState {
  final User user;
  final String message;

  const LoginCheckMobileSuccess({
    required this.user,
    this.message = '',
  });

  @override
  List<Object?> get props => [user, message];
}

/// Login success
class LoginSuccess extends LoginState {
  final User user;

  const LoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Login error
class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Navigate to verification
class LoginNavigateToVerification extends LoginState {
  final String identifier;
  final String type;

  const LoginNavigateToVerification({
    required this.identifier,
    required this.type,
  });

  @override
  List<Object?> get props => [identifier, type];
}

/// Navigate to password
class LoginNavigateToPassword extends LoginState {
  final User user;

  const LoginNavigateToPassword(this.user);

  @override
  List<Object?> get props => [user];
}

/// Navigate to email login
class LoginNavigateToEmail extends LoginState {
  const LoginNavigateToEmail();
}

/// Navigate to sign up
class LoginNavigateToSignUp extends LoginState {
  const LoginNavigateToSignUp();
}
