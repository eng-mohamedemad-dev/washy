import 'package:dartz/dartz.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import 'package:wash_flutter/features/auth/domain/repositories/auth_repository.dart';

class IsUserLoggedIn implements UseCase<bool, NoParams> {
  final AuthRepository authRepository;

  IsUserLoggedIn(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.isUserLoggedIn();
  }
}

