import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/new_order_request.dart';
import '../entities/order_type.dart';
import '../repositories/order_repository.dart';

/// Use case for submitting a new order
class SubmitOrder implements UseCase<int, SubmitOrderParams> {
  final OrderRepository repository;

  SubmitOrder(this.repository);

  @override
  Future<Either<Failure, int>> call(SubmitOrderParams params) async {
    return await repository.submitOrder(
      params.orderRequest,
      params.orderType,
      params.orderTypeTag,
    );
  }
}

class SubmitOrderParams extends Equatable {
  final NewOrderRequest orderRequest;
  final OrderType orderType;
  final String? orderTypeTag;

  const SubmitOrderParams({
    required this.orderRequest,
    required this.orderType,
    this.orderTypeTag,
  });

  @override
  List<Object?> get props => [orderRequest, orderType, orderTypeTag];
}
