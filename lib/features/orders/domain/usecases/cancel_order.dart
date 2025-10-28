import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/orders_repository.dart';

/// Use case for cancelling an order
/// Matches the cancel order functionality in Java OrdersActivity
class CancelOrder implements UseCase<bool, CancelOrderParams> {
  final OrdersRepository repository;

  CancelOrder(this.repository);

  @override
  Future<Either<Failure, bool>> call(CancelOrderParams params) async {
    return await repository.cancelOrder(params.token, params.orderId);
  }
}

/// Parameters for CancelOrder use case
class CancelOrderParams {
  final String token;
  final int orderId;

  CancelOrderParams({
    required this.token,
    required this.orderId,
  });
}
