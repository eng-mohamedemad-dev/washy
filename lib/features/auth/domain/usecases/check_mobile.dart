import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
import 'package:wash_flutter/features/auth/domain/repositories/auth_repository.dart';

class CheckMobile implements UseCase<User, CheckMobileParams> {
  final AuthRepository repository;

  CheckMobile(this.repository);

  @override
  Future<Either<Failure, User>> call(CheckMobileParams params) async {
    return await repository.checkMobile(params.phoneNumber);
  }
}

class CheckMobileParams extends Equatable {
  final String phoneNumber;

  const CheckMobileParams({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

