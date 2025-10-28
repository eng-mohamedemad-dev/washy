import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import 'package:wash_flutter/features/splash/data/datasources/splash_local_data_source.dart';

class SetWalkThroughConsumed implements UseCase<void, SetWalkThroughConsumedParams> {
  final SplashLocalDataSource localDataSource;

  SetWalkThroughConsumed(this.localDataSource);

  @override
  Future<Either<Failure, void>> call(SetWalkThroughConsumedParams params) async {
    try {
      await localDataSource.setWalkThroughConsumed(params.consumed);
      return const Right(null);
    } catch (e) {
        return Left(CacheFailure(e.toString()));
    }
  }
}

class SetWalkThroughConsumedParams extends Equatable {
  final bool consumed;

  const SetWalkThroughConsumedParams(this.consumed);

  @override
  List<Object?> get props => [consumed];
}
