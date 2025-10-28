import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_summary.dart';
import '../repositories/orders_repository.dart';

/// Use case for getting order history
/// Matches the getHistoryOrders functionality in Java OrdersActivity
class GetHistoryOrders implements UseCase<List<OrderSummary>, GetHistoryOrdersParams> {
  final OrdersRepository repository;

  GetHistoryOrders(this.repository);

  @override
  Future<Either<Failure, List<OrderSummary>>> call(GetHistoryOrdersParams params) async {
    return await repository.getHistoryOrders(params.token, params.page);
  }
}

/// Parameters for GetHistoryOrders use case
class GetHistoryOrdersParams {
  final String token;
  final int page;

  GetHistoryOrdersParams({
    required this.token,
    required this.page,
  });
}
