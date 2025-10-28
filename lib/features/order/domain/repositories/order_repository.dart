import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/new_order_request.dart';
import '../entities/washy_address.dart';
import '../entities/date_slot.dart';
import '../entities/time_slot.dart';
import '../entities/credit_card.dart';
import '../entities/order_available_time_slots.dart';
import '../entities/redeem_result.dart';
import '../entities/order_type.dart';

/// Order repository interface following Clean Architecture
abstract class OrderRepository {
  /// Get all user addresses
  Future<Either<Failure, List<WashyAddress>>> getAllAddresses();

  /// Get available time slots for order
  Future<Either<Failure, OrderAvailableTimeSlots>> getOrderAvailableTimeSlots();

  /// Get available date slots
  Future<Either<Failure, List<DateSlot>>> getAvailableDateSlots();

  /// Get available time slots for specific date
  Future<Either<Failure, List<TimeSlot>>> getAvailableTimeSlots(int dateSlotId);

  /// Submit new order
  Future<Either<Failure, int>> submitOrder(
    NewOrderRequest orderRequest,
    OrderType orderType,
    String? orderTypeTag,
  );

  /// Submit skip selection order
  Future<Either<Failure, int>> submitSkipSelectionOrder(
    NewOrderRequest orderRequest,
    int? orderId,
  );

  /// Edit existing order
  Future<Either<Failure, void>> editOrder(
    NewOrderRequest orderRequest,
    List<dynamic> products,
    int orderId,
  );

  /// Get user credit cards
  Future<Either<Failure, List<CreditCard>>> getCreditCards();

  /// Apply redeem/coupon code
  Future<Either<Failure, RedeemResult>> applyRedeemCode(
    String redeemCode,
    String orderType, [
    int? orderId,
    String? products,
  ]);

  /// Upload order files (photos/audio)
  Future<Either<Failure, void>> uploadFiles(
    int orderId,
    List<String> imagePaths,
    List<String> audioPaths,
  );

  /// Confirm order with payment
  Future<Either<Failure, int>> confirmOrder(
    int orderId,
    String paymentMethod,
  );

  /// Make Moto payment
  Future<Either<Failure, int>> makeMotoPayment(
    int orderId,
    int creditCardId,
    String ipAddress,
  );

  /// Get order details for editing
  Future<Either<Failure, dynamic>> getOrderDetails(int orderId);
}
