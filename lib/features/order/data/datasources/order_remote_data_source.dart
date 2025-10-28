import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/response/all_addresses_response.dart';
import '../models/response/add_order_response.dart';
import '../models/response/credit_cards_response.dart';
import '../models/response/coupon_response.dart';
import '../models/response/payment_response.dart';
import '../models/new_order_request_model.dart';

/// Remote data source for order operations (matching Java WebServiceManager order APIs)
abstract class OrderRemoteDataSource {
  Future<AllAddressesResponse> getAllAddresses(String token);
  Future<AddOrderResponse> submitOrder(
    String token,
    NewOrderRequestModel orderRequest,
    int? orderId,
    String orderTypeTag,
  );
  Future<AddOrderResponse> submitSkipSelectionOrder(
    String token,
    NewOrderRequestModel orderRequest,
    int? orderId,
  );
  Future<dynamic> getAvailableTimeSlots(String token);
  Future<void> editOrder(
    String token,
    NewOrderRequestModel orderRequest,
    List<dynamic> products,
    int orderId,
  );
  Future<CreditCardsResponse> getCreditCards(String token);
  Future<CouponResponse> applyRedeemCode(
    String token,
    String redeemCode,
    String orderType, [
    int? orderId,
    String? products,
  ]);
  Future<void> uploadFile(
    String fileType,
    int editedBy,
    File file,
    int orderId,
    String token,
  );
  Future<PaymentResponse> confirmOrder(
    String token,
    int orderId,
    String paymentMethod,
  );
  Future<PaymentResponse> makeMotoPayment(
    String token,
    int orderId,
    int creditCardId,
    String ipAddress,
  );
  Future<dynamic> getOrderDetails(String token, int orderId);
}

/// Implementation of OrderRemoteDataSource
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final http.Client client;

  OrderRemoteDataSourceImpl({required this.client});

  @override
  Future<AllAddressesResponse> getAllAddresses(String token) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}customer/address/all'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'token': token},
      );

      if (response.statusCode == 200) {
        return AllAddressesResponse.fromJson(json.decode(response.body));
      } else {
        throw const ServerException('Failed to get addresses');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to get addresses');
    }
  }

  @override
  Future<AddOrderResponse> submitOrder(
    String token,
    NewOrderRequestModel orderRequest,
    int? orderId,
    String orderTypeTag,
  ) async {
    try {
      // Convert order request to form data (matching Java implementation)
      final formData = <String, dynamic>{
        'token': token,
        'pickup_address_id': orderRequest.pickUpAddress?.addressId.toString(),
        'dropoff_address_id': orderRequest.dropOffAddress?.addressId.toString(),
        'pickup_date_id': orderRequest.pickUpDate?.dateSlotId.toString(),
        'dropoff_date_id': orderRequest.dropOffDate?.dateSlotId.toString(),
        'pickup_time_slot_id': orderRequest.pickUpTimeSlot?.timeSlotId.toString(),
        'dropoff_time_slot_id': orderRequest.dropOffTimeSlot?.timeSlotId.toString(),
        'note': orderRequest.note ?? '',
        'is_recycle_hanger': orderRequest.isRecycleHanger ? '1' : '0',
        'order_type': orderTypeTag,
      };

      if (orderId != null) {
        formData['order_id'] = orderId.toString();
      }

      if (orderRequest.redeemCode != null) {
        formData['redeem_code'] = orderRequest.redeemCode!;
      }

      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}customer/order/add'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: formData,
      );

      if (response.statusCode == 200) {
        return AddOrderResponse.fromJson(json.decode(response.body));
      } else {
        throw const ServerException('Failed to submit order');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to submit order');
    }
  }

  @override
  Future<AddOrderResponse> submitSkipSelectionOrder(
    String token,
    NewOrderRequestModel orderRequest,
    int? orderId,
  ) async {
    try {
      final formData = <String, dynamic>{
        'token': token,
        'pickup_address_id': orderRequest.pickUpAddress?.addressId.toString(),
        'dropoff_address_id': orderRequest.dropOffAddress?.addressId.toString(),
        'pickup_date_id': orderRequest.pickUpDate?.dateSlotId.toString(),
        'dropoff_date_id': orderRequest.dropOffDate?.dateSlotId.toString(),
        'pickup_time_slot_id': orderRequest.pickUpTimeSlot?.timeSlotId.toString(),
        'dropoff_time_slot_id': orderRequest.dropOffTimeSlot?.timeSlotId.toString(),
        'note': orderRequest.note ?? '',
        'is_recycle_hanger': orderRequest.isRecycleHanger ? '1' : '0',
      };

      if (orderId != null) {
        formData['order_id'] = orderId.toString();
      }

      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}customer/order/skip_selection'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: formData,
      );

      if (response.statusCode == 200) {
        return AddOrderResponse.fromJson(json.decode(response.body));
      } else {
        throw const ServerException('Failed to submit skip selection order');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to submit skip selection order');
    }
  }

  @override
  Future<void> editOrder(
    String token,
    NewOrderRequestModel orderRequest,
    List<dynamic> products,
    int orderId,
  ) async {
    try {
      final formData = <String, dynamic>{
        'token': token,
        'order_id': orderId.toString(),
        'pickup_address_id': orderRequest.pickUpAddress?.addressId.toString(),
        'dropoff_address_id': orderRequest.dropOffAddress?.addressId.toString(),
        'pickup_date_id': orderRequest.pickUpDate?.dateSlotId.toString(),
        'dropoff_date_id': orderRequest.dropOffDate?.dateSlotId.toString(),
        'pickup_time_slot_id': orderRequest.pickUpTimeSlot?.timeSlotId.toString(),
        'dropoff_time_slot_id': orderRequest.dropOffTimeSlot?.timeSlotId.toString(),
        'note': orderRequest.note ?? '',
        'is_recycle_hanger': orderRequest.isRecycleHanger ? '1' : '0',
        'products': json.encode(products),
      };

      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}customer/order/edit'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: formData,
      );

      if (response.statusCode != 200) {
        throw const ServerException('Failed to edit order');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to edit order');
    }
  }

  @override
  Future<dynamic> getAvailableTimeSlots(String token) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}customer/order/available_time_slots'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException('Failed to get available time slots: ${response.statusCode}');
    }
  }

  @override
  Future<CreditCardsResponse> getCreditCards(String token) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}customer/payment/credit_cards'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'token': token},
      );

      if (response.statusCode == 200) {
        return CreditCardsResponse.fromJson(json.decode(response.body));
      } else {
        throw const ServerException('Failed to get credit cards');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to get credit cards');
    }
  }

  @override
  Future<CouponResponse> applyRedeemCode(
    String token,
    String redeemCode,
    String orderType, [
    int? orderId,
    String? products,
  ]) async {
    try {
      final formData = <String, dynamic>{
        'token': token,
        'redeem_code': redeemCode,
        'order_type': orderType,
      };

      if (orderId != null) {
        formData['order_id'] = orderId.toString();
      }

      if (products != null) {
        formData['products'] = products;
      }

      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}customer/coupon/apply'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: formData,
      );

      if (response.statusCode == 200) {
        return CouponResponse.fromJson(json.decode(response.body));
      } else {
        throw const ServerException('Failed to apply redeem code');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to apply redeem code');
    }
  }

  @override
  Future<void> uploadFile(
    String fileType,
    int editedBy,
    File file,
    int orderId,
    String token,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.baseUrl}customer/order/upload_file'),
      );

      request.fields.addAll({
        'token': token,
        'file_type': fileType,
        'edited_by': editedBy.toString(),
        'order_id': orderId.toString(),
      });

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode != 200) {
        throw const ServerException('Failed to upload file');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to upload file');
    }
  }

  @override
  Future<PaymentResponse> confirmOrder(
    String token,
    int orderId,
    String paymentMethod,
  ) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}customer/order/confirm'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'order_id': orderId.toString(),
          'payment_method': paymentMethod,
        },
      );

      if (response.statusCode == 200) {
        return PaymentResponse.fromJson(json.decode(response.body));
      } else {
        throw const ServerException('Failed to confirm order');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to confirm order');
    }
  }

  @override
  Future<PaymentResponse> makeMotoPayment(
    String token,
    int orderId,
    int creditCardId,
    String ipAddress,
  ) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}customer/payment/moto'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'order_id': orderId.toString(),
          'credit_card_id': creditCardId.toString(),
          'ip_address': ipAddress,
        },
      );

      if (response.statusCode == 200) {
        return PaymentResponse.fromJson(json.decode(response.body));
      } else {
        throw const ServerException('Failed to make moto payment');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to make moto payment');
    }
  }

  @override
  Future<dynamic> getOrderDetails(String token, int orderId) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}customer/order/details'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'order_id': orderId.toString(),
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw const ServerException('Failed to get order details');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Failed to get order details');
    }
  }
}
