import 'package:equatable/equatable.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';

abstract class EmailState extends Equatable {
  const EmailState();

  @override
  List<Object?> get props => [];
}

class EmailInitial extends EmailState {}

class EmailLoading extends EmailState {}

class EmailChecked extends EmailState {
  final User user;

  const EmailChecked({required this.user});

  @override
  List<Object?> get props => [user];
}

class EmailCodeSent extends EmailState {
  final String email;

  const EmailCodeSent({required this.email});

  @override
  List<Object?> get props => [email];
}

class EmailError extends EmailState {
  final String message;

  const EmailError({required this.message});

  @override
  List<Object?> get props => [message];
}
