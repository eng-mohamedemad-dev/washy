import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/redeem_result.dart';
import '../repositories/order_repository.dart';

/// Use case for applying redeem/coupon code
class ApplyRedeemCode implements UseCase<RedeemResult, ApplyRedeemCodeParams> {
  final OrderRepository repository;

  ApplyRedeemCode(this.repository);

  @override
  Future<Either<Failure, RedeemResult>> call(ApplyRedeemCodeParams params) async {
    return await repository.applyRedeemCode(
      params.redeemCode,
      params.orderType,
      params.orderId,
      params.products,
    );
  }
}

class ApplyRedeemCodeParams extends Equatable {
  final String redeemCode;
  final String orderType;
  final int? orderId;
  final String? products;

  const ApplyRedeemCodeParams({
    required this.redeemCode,
    required this.orderType,
    this.orderId,
    this.products,
  });

  @override
  List<Object?> get props => [redeemCode, orderType, orderId, products];
}
