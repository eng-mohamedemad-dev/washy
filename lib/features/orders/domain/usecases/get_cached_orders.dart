import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_summary.dart';
import '../entities/orders_type.dart';
import '../repositories/orders_repository.dart';

/// Use case for getting cached orders for offline support
class GetCachedOrders implements UseCase<List<OrderSummary>, GetCachedOrdersParams> {
  final OrdersRepository repository;

  GetCachedOrders(this.repository);

  @override
  Future<Either<Failure, List<OrderSummary>>> call(GetCachedOrdersParams params) async {
    return await repository.getCachedOrders(params.orderType);
  }
}

/// Parameters for GetCachedOrders use case
class GetCachedOrdersParams {
  final OrdersType orderType;

  GetCachedOrdersParams({
    required this.orderType,
  });
}

