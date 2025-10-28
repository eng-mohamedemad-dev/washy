import 'package:equatable/equatable.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object?> get props => [];
}

/// Password changed event (like Java's TextWatcher)
class PasswordChanged extends PasswordEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

/// Set password for new user (like Java's setPassword)
class SetPasswordPressed extends PasswordEvent {
  final String password;
  final User user;

  const SetPasswordPressed({
    required this.password,
    required this.user,
  });

  @override
  List<Object?> get props => [password, user];
}

/// Login with password for existing user (like Java's login)
class LoginWithPasswordPressed extends PasswordEvent {
  final String password;
  final User user;

  const LoginWithPasswordPressed({
    required this.password,
    required this.user,
  });

  @override
  List<Object?> get props => [password, user];
}

/// Forget password (like Java's forget password)
class ForgetPasswordPressed extends PasswordEvent {
  final User user;

  const ForgetPasswordPressed({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Toggle password visibility (like Java's password show/hide)
class TogglePasswordVisibility extends PasswordEvent {}

/// Back button pressed
class PasswordBackPressed extends PasswordEvent {}
