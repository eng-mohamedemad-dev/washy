import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

/// Use case for removing item from cart
class RemoveItemFromCart implements UseCase<void, RemoveItemFromCartParams> {
  final CartRepository repository;

  RemoveItemFromCart(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveItemFromCartParams params) async {
    return await repository.removeItemFromCart(params.productId);
  }
}

class RemoveItemFromCartParams extends Equatable {
  final int productId;

  const RemoveItemFromCartParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
