import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../features/splash/data/datasources/splash_local_data_source.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../../domain/entities/credit_card.dart';
import '../../domain/entities/date_slot.dart';
import '../../domain/entities/new_order_request.dart';
import '../../domain/entities/order_available_time_slots.dart';
import '../../domain/entities/order_type.dart';
import '../../domain/entities/redeem_result.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/entities/washy_address.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/new_order_request_model.dart';

/// Order repository implementation following Clean Architecture
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final SplashLocalDataSource splashLocalDataSource;

  const OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.splashLocalDataSource,
  });

  @override
  Future<Either<Failure, List<WashyAddress>>> getAllAddresses() async {
    final String token = await splashLocalDataSource.getUserToken() ?? '';
    if (await networkInfo.isConnected) {
      try {
        final remoteAddresses = await remoteDataSource.getAllAddresses(token);
        final addresses =
            remoteAddresses.addresses.map((model) => model.toEntity()).toList();

        // Cache addresses
        await localDataSource.cacheAddresses(remoteAddresses.addresses);

        return Right(addresses);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return const Left(ServerFailure('Failed to get addresses'));
      }
    } else {
      try {
        final cachedAddresses = await localDataSource.getCachedAddresses();
        final addresses =
            cachedAddresses.map((model) => model.toEntity()).toList();
        return Right(addresses);
      } on CacheException {
        return const Left(CacheFailure('Failed to load cached addresses'));
      }
    }
  }

  @override
  Future<Either<Failure, OrderAvailableTimeSlots>>
      getOrderAvailableTimeSlots() async {
    // TODO: Implement when API is available
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, List<DateSlot>>> getAvailableDateSlots() async {
    // TODO: Implement when API is available
    return const Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, List<TimeSlot>>> getAvailableTimeSlots(
      int dateSlotId) async {
    // TODO: Get token from session/auth
    const String token = "";

    if (await networkInfo.isConnected) {
      try {
        // TODO: Update remote data source to use dateSlotId
        final timeSlots = await remoteDataSource.getAvailableTimeSlots(token);
        // TODO: Convert API response to List<TimeSlot> when model is ready
        return const Left(
            ServerFailure('API response conversion not implemented'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return const Left(ServerFailure('Failed to get time slots'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, int>> submitOrder(
    NewOrderRequest orderRequest,
    OrderType orderType,
    String? orderTypeTag,
  ) async {
    // TODO: Get token from session/auth
    const String token = "";

    if (await networkInfo.isConnected) {
      try {
        final orderModel = NewOrderRequestModel.fromEntity(orderRequest);
        final response = await remoteDataSource.submitOrder(
          token,
          orderModel,
          null, // orderId
          orderTypeTag ?? 'normal',
        );

        // Cache the order request
        await localDataSource.cacheOrderRequest(orderModel);

        return Right(response.data?.orderId ?? 0);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return const Left(ServerFailure('Failed to submit order'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, int>> submitSkipSelectionOrder(
    NewOrderRequest orderRequest,
    int? skipSelectionId,
  ) async {
    // TODO: Get token from session/auth
    const String token = "";

    if (await networkInfo.isConnected) {
      try {
        final orderModel = NewOrderRequestModel.fromEntity(orderRequest);
        final response = await remoteDataSource.submitSkipSelectionOrder(
          token,
          orderModel,
          skipSelectionId,
        );

        // Cache the order request
        await localDataSource.cacheOrderRequest(orderModel);

        return Right(response.data?.orderId ?? 0);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return const Left(
            ServerFailure('Failed to submit skip selection order'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CreditCard>>> getCreditCards() async {
    // TODO: Get token from session/auth
    const String token = "";

    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getCreditCards(token);
        final creditCards =
            response.creditCards.map((model) => model.toEntity()).toList();

        // Cache credit cards
        await localDataSource.cacheCreditCards(response.creditCards);

        return Right(creditCards);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return const Left(ServerFailure('Failed to get credit cards'));
      }
    } else {
      try {
        final cachedCards = await localDataSource.getCachedCreditCards();
        final creditCards =
            cachedCards.map((model) => model.toEntity()).toList();
        return Right(creditCards);
      } on CacheException {
        return const Left(CacheFailure('Failed to load cached credit cards'));
      }
    }
  }

  @override
  Future<Either<Failure, RedeemResult>> applyRedeemCode(
    String redeemCode,
    String orderType, [
    int? orderId,
    String? priceTotal,
  ]) async {
    // TODO: Get token from session/auth
    const String token = "";

    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.applyRedeemCode(
          token,
          redeemCode,
          orderType,
          orderId,
          null, // products JSON if needed
        );

        final redeemResult = RedeemResult(
          code: redeemCode,
          success: response.success,
          couponId: response.couponId,
          discountTotal: response.discount,
          subTotal: 0.0, // TODO: Calculate from response
          freeShipping: false, // TODO: Get from response
        );

        return Right(redeemResult);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return const Left(ServerFailure('Failed to apply redeem code'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, int>> confirmOrder(
      int orderId, String paymentMethod) async {
    // TODO: Get token from session/auth
    const String token = "";

    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.confirmOrder(
          token,
          orderId,
          paymentMethod,
        );

        return Right(response.data?.orderId ?? orderId);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return const Left(ServerFailure('Failed to confirm order'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> uploadFiles(
    int orderId,
    List<String> imagePaths,
    List<String> audioPaths,
  ) async {
    // TODO: Get token from session/auth
    const String token = "";

    if (await networkInfo.isConnected) {
      try {
        // Upload image files
        for (final imagePath in imagePaths) {
          final imageFile = File(imagePath);
          await remoteDataSource.uploadFile(
            'image',
            0, // editedBy
            imageFile,
            orderId,
            token,
          );
        }

        // Upload audio files
        for (final audioPath in audioPaths) {
          final audioFile = File(audioPath);
          await remoteDataSource.uploadFile(
            'audio',
            0, // editedBy
            audioFile,
            orderId,
            token,
          );
        }

        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return const Left(ServerFailure('Failed to upload files'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getOrderDetails(int orderId) async {
    // TODO: Get token from session/auth
    const String token = "";

    if (await networkInfo.isConnected) {
      try {
        final orderDetails =
            await remoteDataSource.getOrderDetails(token, orderId);
        return Right(orderDetails);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return const Left(ServerFailure('Failed to get order details'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> editOrder(
    NewOrderRequest orderRequest,
    List<dynamic> products,
    int orderId,
  ) async {
    // TODO: Get token from session/auth
    const String token = "";

    if (await networkInfo.isConnected) {
      try {
        final orderModel = NewOrderRequestModel.fromEntity(orderRequest);
        await remoteDataSource.editOrder(
          token,
          orderModel,
          products.cast<Map<String, dynamic>>(),
          orderId,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return const Left(ServerFailure('Failed to edit order'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, int>> makeMotoPayment(
    int orderId,
    int creditCardId,
    String ipAddress,
  ) async {
    // TODO: Get token from session/auth
    const String token = "";

    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.makeMotoPayment(
          token,
          orderId,
          creditCardId,
          ipAddress,
        );
        return Right(response.data?.orderId ?? orderId);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on Exception {
        return const Left(ServerFailure('Failed to process Moto payment'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
