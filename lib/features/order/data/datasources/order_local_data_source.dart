import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/new_order_request_model.dart';
import '../models/washy_address_model.dart';
import '../models/date_slot_model.dart';
import '../models/time_slot_model.dart';
import '../models/credit_card_model.dart';

/// Local data source for order operations (matching Java local storage)
abstract class OrderLocalDataSource {
  Future<NewOrderRequestModel?> getCachedOrderRequest();
  Future<void> cacheOrderRequest(NewOrderRequestModel orderRequest);
  Future<void> clearCachedOrderRequest();
  
  Future<List<WashyAddressModel>> getCachedAddresses();
  Future<void> cacheAddresses(List<WashyAddressModel> addresses);
  
  Future<List<DateSlotModel>> getCachedDateSlots();
  Future<void> cacheDateSlots(List<DateSlotModel> dateSlots);
  
  Future<List<TimeSlotModel>> getCachedTimeSlots(int dateSlotId);
  Future<void> cacheTimeSlots(int dateSlotId, List<TimeSlotModel> timeSlots);
  
  Future<List<CreditCardModel>> getCachedCreditCards();
  Future<void> cacheCreditCards(List<CreditCardModel> creditCards);
  
  Future<bool> hasValidOrderCache();
  Future<void> clearAllOrderCache();
}

/// Keys for SharedPreferences (matching Java local storage keys)
const String ORDER_REQUEST_KEY = 'ORDER_REQUEST_KEY';
const String ADDRESSES_KEY = 'ADDRESSES_KEY';
const String DATE_SLOTS_KEY = 'DATE_SLOTS_KEY';
const String TIME_SLOTS_KEY = 'TIME_SLOTS_KEY';
const String CREDIT_CARDS_KEY = 'CREDIT_CARDS_KEY';
const String ORDER_CACHE_TIMESTAMP_KEY = 'ORDER_CACHE_TIMESTAMP_KEY';

/// Cache validity duration (1 hour)
const int CACHE_VALIDITY_MINUTES = 60;

/// Implementation of OrderLocalDataSource
class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final SharedPreferences sharedPreferences;

  OrderLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NewOrderRequestModel?> getCachedOrderRequest() async {
    try {
      final jsonString = sharedPreferences.getString(ORDER_REQUEST_KEY);
      if (jsonString != null) {
        return NewOrderRequestModel.fromJson(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      throw const CacheException('Failed to load cached order request');
    }
  }

  @override
  Future<void> cacheOrderRequest(NewOrderRequestModel orderRequest) async {
    try {
      final jsonString = json.encode(orderRequest.toJson());
      await sharedPreferences.setString(ORDER_REQUEST_KEY, jsonString);
      
      // Update cache timestamp
      await _updateCacheTimestamp();
    } catch (e) {
      throw const CacheException('Failed to cache order request');
    }
  }

  @override
  Future<void> clearCachedOrderRequest() async {
    try {
      await sharedPreferences.remove(ORDER_REQUEST_KEY);
    } catch (e) {
      throw const CacheException('Failed to clear cached order request');
    }
  }

  @override
  Future<List<WashyAddressModel>> getCachedAddresses() async {
    try {
      final jsonString = sharedPreferences.getString(ADDRESSES_KEY);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((item) => WashyAddressModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      throw const CacheException('Failed to load cached addresses');
    }
  }

  @override
  Future<void> cacheAddresses(List<WashyAddressModel> addresses) async {
    try {
      final jsonList = addresses.map((address) => address.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(ADDRESSES_KEY, jsonString);
      
      // Update cache timestamp
      await _updateCacheTimestamp();
    } catch (e) {
      throw const CacheException('Failed to cache addresses');
    }
  }

  @override
  Future<List<DateSlotModel>> getCachedDateSlots() async {
    try {
      final jsonString = sharedPreferences.getString(DATE_SLOTS_KEY);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((item) => DateSlotModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      throw const CacheException('Failed to load cached date slots');
    }
  }

  @override
  Future<void> cacheDateSlots(List<DateSlotModel> dateSlots) async {
    try {
      final jsonList = dateSlots.map((slot) => slot.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(DATE_SLOTS_KEY, jsonString);
      
      // Update cache timestamp
      await _updateCacheTimestamp();
    } catch (e) {
      throw const CacheException('Failed to cache date slots');
    }
  }

  @override
  Future<List<TimeSlotModel>> getCachedTimeSlots(int dateSlotId) async {
    try {
      final key = '${TIME_SLOTS_KEY}_$dateSlotId';
      final jsonString = sharedPreferences.getString(key);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((item) => TimeSlotModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      throw const CacheException('Failed to load cached time slots');
    }
  }

  @override
  Future<void> cacheTimeSlots(int dateSlotId, List<TimeSlotModel> timeSlots) async {
    try {
      final key = '${TIME_SLOTS_KEY}_$dateSlotId';
      final jsonList = timeSlots.map((slot) => slot.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(key, jsonString);
      
      // Update cache timestamp
      await _updateCacheTimestamp();
    } catch (e) {
      throw const CacheException('Failed to cache time slots');
    }
  }

  @override
  Future<List<CreditCardModel>> getCachedCreditCards() async {
    try {
      final jsonString = sharedPreferences.getString(CREDIT_CARDS_KEY);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((item) => CreditCardModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      throw const CacheException('Failed to load cached credit cards');
    }
  }

  @override
  Future<void> cacheCreditCards(List<CreditCardModel> creditCards) async {
    try {
      final jsonList = creditCards.map((card) => card.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(CREDIT_CARDS_KEY, jsonString);
      
      // Update cache timestamp
      await _updateCacheTimestamp();
    } catch (e) {
      throw const CacheException('Failed to cache credit cards');
    }
  }

  @override
  Future<bool> hasValidOrderCache() async {
    try {
      final timestamp = sharedPreferences.getInt(ORDER_CACHE_TIMESTAMP_KEY);
      if (timestamp == null) return false;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime).inMinutes;
      
      return difference < CACHE_VALIDITY_MINUTES;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearAllOrderCache() async {
    try {
      await Future.wait([
        sharedPreferences.remove(ORDER_REQUEST_KEY),
        sharedPreferences.remove(ADDRESSES_KEY),
        sharedPreferences.remove(DATE_SLOTS_KEY),
        sharedPreferences.remove(CREDIT_CARDS_KEY),
        sharedPreferences.remove(ORDER_CACHE_TIMESTAMP_KEY),
      ]);

      // Clear all time slots cache (we don't know all dateSlotIds, so clear by pattern)
      final keys = sharedPreferences.getKeys();
      final timeSlotsKeys = keys.where((key) => key.startsWith(TIME_SLOTS_KEY));
      
      await Future.wait(
        timeSlotsKeys.map((key) => sharedPreferences.remove(key)),
      );
    } catch (e) {
      throw const CacheException('Failed to clear order cache');
    }
  }

  /// Update cache timestamp
  Future<void> _updateCacheTimestamp() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await sharedPreferences.setInt(ORDER_CACHE_TIMESTAMP_KEY, timestamp);
  }
}
