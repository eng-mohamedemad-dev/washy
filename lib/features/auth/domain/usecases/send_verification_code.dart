import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import 'package:wash_flutter/features/auth/domain/entities/verification_request.dart';
import 'package:wash_flutter/features/auth/domain/repositories/auth_repository.dart';

class SendVerificationCode implements UseCase<void, SendVerificationCodeParams> {
  final AuthRepository repository;

  SendVerificationCode(this.repository);

  @override
  Future<Either<Failure, void>> call(SendVerificationCodeParams params) async {
    switch (params.request.type) {
      case VerificationType.sms:
        return await repository.sendSmsVerificationCode(params.request.identifier);
      case VerificationType.email:
        return await repository.sendEmailVerificationCode(params.request.identifier);
    }
  }
}

class SendVerificationCodeParams extends Equatable {
  final VerificationRequest request;

  const SendVerificationCodeParams({required this.request});

  @override
  List<Object?> get props => [request];
}

