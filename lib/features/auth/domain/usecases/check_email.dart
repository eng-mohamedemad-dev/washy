import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
import 'package:wash_flutter/features/auth/domain/repositories/auth_repository.dart';

class CheckEmail implements UseCase<User, CheckEmailParams> {
  final AuthRepository repository;

  CheckEmail(this.repository);

  @override
  Future<Either<Failure, User>> call(CheckEmailParams params) async {
    return await repository.checkEmail(params.email);
  }
}

class CheckEmailParams extends Equatable {
  final String email;

  const CheckEmailParams({required this.email});

  @override
  List<Object?> get props => [email];
}

