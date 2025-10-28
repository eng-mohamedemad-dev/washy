import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../../domain/entities/app_config.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/splash_local_data_source.dart';
import '../datasources/splash_remote_data_source.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashRemoteDataSource remoteDataSource;
  final SplashLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SplashRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> fetchServerUrl() async {
    if (await networkInfo.isConnected) {
      try {
        final serverUrl = await remoteDataSource.fetchServerUrl();
        await localDataSource.setServerUrl(serverUrl);
        return Right(serverUrl);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AppConfig>> getAppConfig() async {
    try {
      final appConfig = await localDataSource.getAppConfig();
      return Right(appConfig);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setWalkThroughConsumed(bool consumed) async {
    try {
      await localDataSource.setWalkThroughConsumed(consumed);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkConfigDataFetched() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.fetchConfigData();
        await remoteDataSource.fetchAllStrings();
        return const Right(true);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> initializeApp() async {
    try {
      // Initialize any app-specific data
      // This could include device model, analytics setup, etc.
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure('Failed to initialize app: $e'));
    }
  }
}

