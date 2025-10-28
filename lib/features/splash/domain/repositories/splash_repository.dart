import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_config.dart';

abstract class SplashRepository {
  Future<Either<Failure, String>> fetchServerUrl();
  Future<Either<Failure, AppConfig>> getAppConfig();
  Future<Either<Failure, void>> setWalkThroughConsumed(bool consumed);
  Future<Either<Failure, bool>> checkConfigDataFetched();
  Future<Either<Failure, void>> initializeApp();
}

