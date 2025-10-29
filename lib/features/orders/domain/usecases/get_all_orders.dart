import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_summary.dart';
import '../repositories/orders_repository.dart';

/// Use case for getting all current orders
/// Matches the getAllOrders functionality in Java OrdersActivity
class GetAllOrders implements UseCase<List<OrderSummary>, GetAllOrdersParams> {
  final OrdersRepository repository;

  GetAllOrders(this.repository);

  @override
  Future<Either<Failure, List<OrderSummary>>> call(GetAllOrdersParams params) async {
    return await repository.getAllOrders(params.token, params.page);
  }
}

/// Parameters for GetAllOrders use case
class GetAllOrdersParams {
  final String token;
  final int page;

  GetAllOrdersParams({
    required this.token,
    required this.page,
  });
}

