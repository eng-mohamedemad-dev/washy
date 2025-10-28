import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/splash_repository.dart';

class FetchServerUrl implements UseCase<String, NoParams> {
  final SplashRepository repository;

  FetchServerUrl(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.fetchServerUrl();
  }
}

