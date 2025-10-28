import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_details.dart';
import '../repositories/orders_repository.dart';

/// Use case for getting detailed order information
/// Matches the callGetOrderDetail functionality in Java OrdersActivity
class GetOrderDetails implements UseCase<OrderDetails, GetOrderDetailsParams> {
  final OrdersRepository repository;

  GetOrderDetails(this.repository);

  @override
  Future<Either<Failure, OrderDetails>> call(GetOrderDetailsParams params) async {
    return await repository.getOrderDetails(params.token, params.orderId);
  }
}

/// Parameters for GetOrderDetails use case
class GetOrderDetailsParams {
  final String token;
  final int orderId;

  GetOrderDetailsParams({
    required this.token,
    required this.orderId,
  });
}
