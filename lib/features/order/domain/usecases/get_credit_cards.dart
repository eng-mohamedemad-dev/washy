import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/credit_card.dart';
import '../repositories/order_repository.dart';

/// Use case for getting user credit cards
class GetCreditCards implements UseCase<List<CreditCard>, NoParams> {
  final OrderRepository repository;

  GetCreditCards(this.repository);

  @override
  Future<Either<Failure, List<CreditCard>>> call(NoParams params) async {
    return await repository.getCreditCards();
  }
}
