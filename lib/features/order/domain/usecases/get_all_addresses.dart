import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/washy_address.dart';
import '../repositories/order_repository.dart';

/// Use case for getting all user addresses
class GetAllAddresses implements UseCase<List<WashyAddress>, NoParams> {
  final OrderRepository repository;

  GetAllAddresses(this.repository);

  @override
  Future<Either<Failure, List<WashyAddress>>> call(NoParams params) async {
    return await repository.getAllAddresses();
  }
}
