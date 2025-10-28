import 'package:dartz/dartz.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import 'package:wash_flutter/features/splash/data/datasources/splash_local_data_source.dart';

class IsWalkThroughConsumed implements UseCase<bool, NoParams> {
  final SplashLocalDataSource localDataSource;

  IsWalkThroughConsumed(this.localDataSource);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final isConsumed = await localDataSource.isWalkThroughConsumed();
      return Right(isConsumed);
    } catch (e) {
        return Left(CacheFailure(e.toString()));
    }
  }
}
