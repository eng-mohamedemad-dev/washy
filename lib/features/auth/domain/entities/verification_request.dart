import 'package:equatable/equatable.dart';

class VerificationRequest extends Equatable {
  final String identifier; // phone or email
  final VerificationType type;
  final bool isFromForgetPassword;

  const VerificationRequest({
    required this.identifier,
    required this.type,
    this.isFromForgetPassword = false,
  });

  @override
  List<Object?> get props => [identifier, type, isFromForgetPassword];
}

enum VerificationType {
  sms,
  email,
}

