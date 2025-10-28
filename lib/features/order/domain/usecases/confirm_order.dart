import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

/// Use case for confirming order with payment
class ConfirmOrder implements UseCase<int, ConfirmOrderParams> {
  final OrderRepository repository;

  ConfirmOrder(this.repository);

  @override
  Future<Either<Failure, int>> call(ConfirmOrderParams params) async {
    return await repository.confirmOrder(
      params.orderId,
      params.paymentMethod,
    );
  }
}

class ConfirmOrderParams extends Equatable {
  final int orderId;
  final String paymentMethod;

  const ConfirmOrderParams({
    required this.orderId,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [orderId, paymentMethod];
}
