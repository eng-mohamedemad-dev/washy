import 'package:equatable/equatable.dart';

abstract class EmailEvent extends Equatable {
  const EmailEvent();

  @override
  List<Object?> get props => [];
}

class CheckEmailEvent extends EmailEvent {
  final String email;

  const CheckEmailEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class SendEmailCodeEvent extends EmailEvent {
  final String email;

  const SendEmailCodeEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetEmailState extends EmailEvent {}
