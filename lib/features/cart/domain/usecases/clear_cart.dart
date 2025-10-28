import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

/// Use case for clearing entire cart
class ClearCart implements UseCase<void, ClearCartParams> {
  final CartRepository repository;

  ClearCart(this.repository);

  @override
  Future<Either<Failure, void>> call(ClearCartParams params) async {
    if (params.orderType != null) {
      return await repository.clearCartByType(params.orderType!);
    }
    return await repository.clearCart();
  }
}

class ClearCartParams extends Equatable {
  final String? orderType; // null means clear entire cart

  const ClearCartParams({this.orderType});

  @override
  List<Object?> get props => [orderType];
}
