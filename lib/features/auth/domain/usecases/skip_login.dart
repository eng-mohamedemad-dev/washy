import 'package:dartz/dartz.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import 'package:wash_flutter/features/auth/domain/repositories/auth_repository.dart';

class SkipLogin implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SkipLogin(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.skipLogin();
  }
}

