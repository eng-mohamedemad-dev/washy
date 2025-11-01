import 'package:equatable/equatable.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object?> get props => [];
}

/// Initial password state
class PasswordInitial extends PasswordState {
  final User user;
  final bool isNewUser; // true for setting password, false for login
  final String password;
  final bool isPasswordValid;
  final bool isPasswordVisible;
  final String? validationMessage;

  const PasswordInitial({
    required this.user,
    required this.isNewUser,
    this.password = '',
    this.isPasswordValid = false,
    this.isPasswordVisible = false,
    this.validationMessage,
  });

  @override
  List<Object?> get props => [
        user,
        isNewUser,
        password,
        isPasswordValid,
        isPasswordVisible,
        validationMessage,
      ];

  PasswordInitial copyWith({
    User? user,
    bool? isNewUser,
    String? password,
    bool? isPasswordValid,
    bool? isPasswordVisible,
    String? validationMessage,
  }) {
    return PasswordInitial(
      user: user ?? this.user,
      isNewUser: isNewUser ?? this.isNewUser,
      password: password ?? this.password,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      validationMessage: validationMessage ?? this.validationMessage,
    );
  }
}

/// Loading state (like Java's progress dialog)
class PasswordLoading extends PasswordState {
  const PasswordLoading();
}

/// Password set successfully (for new users)
class PasswordSetSuccess extends PasswordState {
  final User user;
  final String message;

  const PasswordSetSuccess({
    required this.user,
    this.message = 'Password set successfully',
  });

  @override
  List<Object?> get props => [user, message];
}

/// Login success (for existing users with password)
class PasswordLoginSuccess extends PasswordState {
  final User user;

  const PasswordLoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Password error
class PasswordError extends PasswordState {
  final String message;

  const PasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Navigate to forgot password verification
class NavigateToForgotPasswordVerification extends PasswordState {
  final String identifier; // email or phone
  final String type; // 'email' or 'sms'
  final bool isExceedsLimit; // Skip verification if exceeds_limit

  const NavigateToForgotPasswordVerification({
    required this.identifier,
    required this.type,
    this.isExceedsLimit = false,
  });

  @override
  List<Object?> get props => [identifier, type, isExceedsLimit];
}

/// Navigate to main screen
class NavigateToHome extends PasswordState {
  final User user;

  const NavigateToHome({required this.user});

  @override
  List<Object?> get props => [user];
}
