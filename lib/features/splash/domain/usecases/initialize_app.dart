import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/splash_repository.dart';

class InitializeApp implements UseCase<void, NoParams> {
  final SplashRepository repository;

  InitializeApp(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.initializeApp();
  }
}

