import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

/// Use case for updating cart item quantity
class UpdateItemQuantity implements UseCase<void, UpdateItemQuantityParams> {
  final CartRepository repository;

  UpdateItemQuantity(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateItemQuantityParams params) async {
    return await repository.updateItemQuantity(params.productId, params.newQuantity);
  }
}

class UpdateItemQuantityParams extends Equatable {
  final int productId;
  final int newQuantity;

  const UpdateItemQuantityParams({
    required this.productId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [productId, newQuantity];
}
