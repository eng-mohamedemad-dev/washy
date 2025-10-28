import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/time_slot.dart';
import '../repositories/order_repository.dart';

/// Use case for getting available time slots for a specific date
class GetAvailableTimeSlots implements UseCase<List<TimeSlot>, GetAvailableTimeSlotsParams> {
  final OrderRepository repository;

  GetAvailableTimeSlots(this.repository);

  @override
  Future<Either<Failure, List<TimeSlot>>> call(GetAvailableTimeSlotsParams params) async {
    return await repository.getAvailableTimeSlots(params.dateSlotId);
  }
}

class GetAvailableTimeSlotsParams extends Equatable {
  final int dateSlotId;

  const GetAvailableTimeSlotsParams({required this.dateSlotId});

  @override
  List<Object?> get props => [dateSlotId];
}
