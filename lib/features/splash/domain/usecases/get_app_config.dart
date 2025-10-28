import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_config.dart';
import '../repositories/splash_repository.dart';

class GetAppConfig implements UseCase<AppConfig, NoParams> {
  final SplashRepository repository;

  GetAppConfig(this.repository);

  @override
  Future<Either<Failure, AppConfig>> call(NoParams params) async {
    return await repository.getAppConfig();
  }
}

