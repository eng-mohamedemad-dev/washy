import 'package:dartz/dartz.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import '../entities/cart_summary.dart';
import '../repositories/cart_repository.dart';

/// Use case for getting cart summary
class GetCartSummary implements UseCase<CartSummary, NoParams> {
  final CartRepository repository;

  GetCartSummary(this.repository);

  @override
  Future<Either<Failure, CartSummary>> call(NoParams params) async {
    return await repository.getCartSummary();
  }
}
