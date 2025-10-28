import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

/// Use case for adding item to cart
class AddItemToCart implements UseCase<void, AddItemToCartParams> {
  final CartRepository repository;

  AddItemToCart(this.repository);

  @override
  Future<Either<Failure, void>> call(AddItemToCartParams params) async {
    return await repository.addItemToCart(params.item);
  }
}

class AddItemToCartParams extends Equatable {
  final CartItem item;

  const AddItemToCartParams({required this.item});

  @override
  List<Object?> get props => [item];
}
