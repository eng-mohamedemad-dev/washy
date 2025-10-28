import 'dart:convert';
import '../../domain/entities/new_order_request.dart';
import '../../domain/entities/navigation_destination.dart';
import 'washy_address_model.dart';
import 'date_slot_model.dart';
import 'time_slot_model.dart';
import 'redeem_result_model.dart';
import 'photo_model.dart';
import 'audio_record_model.dart';

/// NewOrderRequest data model for serialization
class NewOrderRequestModel extends NewOrderRequest {
  const NewOrderRequestModel({
    super.pickUpAddress,
    super.dropOffAddress,
    super.note,
    super.pickUpDate,
    super.dropOffDate,
    super.pickUpTimeSlot,
    super.dropOffTimeSlot,
    super.redeemCode,
    super.isDeliverAtSameLocation,
    super.positionOfSelectedPickupDate,
    super.positionOfSelectedPickupTime,
    super.positionOfSelectedDropOffDate,
    super.positionOfSelectedDropOffTime,
    super.redeemResult,
    super.isDifferenceMoreThanDay,
    super.animateProgressBar,
    super.lastProgress,
    super.isRecycleHanger,
    super.isFirstOrderCouponCalled,
    super.isEditOrder,
    super.fileDataList,
    super.fileDataVoiceList,
    super.fromTime,
    super.toTime,
    super.orderDate,
    super.total,
    super.lastSubTotalValue,
    super.navigationDestination,
  });

  /// Create from JSON (matching Java NewOrderRequest)
  factory NewOrderRequestModel.fromJson(Map<String, dynamic> json) {
    return NewOrderRequestModel(
      pickUpAddress: json['pickup_address'] != null
          ? WashyAddressModel.fromJson(json['pickup_address'])
          : null,
      dropOffAddress: json['dropoff_address'] != null
          ? WashyAddressModel.fromJson(json['dropoff_address'])
          : null,
      note: json['note'],
      pickUpDate: json['pickup_date'] != null
          ? DateSlotModel.fromJson(json['pickup_date'])
          : null,
      dropOffDate: json['dropoff_date'] != null
          ? DateSlotModel.fromJson(json['dropoff_date'])
          : null,
      pickUpTimeSlot: json['pickup_time_slot'] != null
          ? TimeSlotModel.fromJson(json['pickup_time_slot'])
          : null,
      dropOffTimeSlot: json['dropoff_time_slot'] != null
          ? TimeSlotModel.fromJson(json['dropoff_time_slot'])
          : null,
      redeemCode: json['redeem_code'],
      isDeliverAtSameLocation: json['is_deliver_at_same_location'] ?? true,
      positionOfSelectedPickupDate: json['position_of_selected_pickup_date'] ?? 0,
      positionOfSelectedPickupTime: json['position_of_selected_pickup_time'] ?? 0,
      positionOfSelectedDropOffDate: json['position_of_selected_dropoff_date'] ?? 0,
      positionOfSelectedDropOffTime: json['position_of_selected_dropoff_time'] ?? 0,
      redeemResult: json['redeem_result'] != null
          ? RedeemResultModel.fromJson(json['redeem_result'])
          : null,
      isDifferenceMoreThanDay: json['is_difference_more_than_day'] ?? true,
      animateProgressBar: json['animate_progress_bar'] ?? false,
      lastProgress: json['last_progress'] ?? -1,
      isRecycleHanger: json['is_recycle_hanger'] ?? false,
      isFirstOrderCouponCalled: json['is_first_order_coupon_called'] ?? false,
      isEditOrder: json['is_edit_order'] ?? false,
      fileDataList: json['file_data_list'] != null
          ? List<PhotoModel>.from(
              json['file_data_list'].map((x) => PhotoModel.fromJson(x)),
            )
          : [],
      fileDataVoiceList: json['file_data_voice_list'] != null
          ? List<AudioRecordModel>.from(
              json['file_data_voice_list'].map((x) => AudioRecordModel.fromJson(x)),
            )
          : [],
      fromTime: json['from_time'],
      toTime: json['to_time'],
      orderDate: json['order_date'],
      total: (json['total'] ?? 0.0).toDouble(),
      lastSubTotalValue: (json['last_sub_total_value'] ?? 0.0).toDouble(),
      navigationDestination: json['navigation_destination'] != null
          ? NavigationDestination.fromString(json['navigation_destination'])
          : null,
    );
  }

  /// Convert to JSON (matching Java NewOrderRequest)
  Map<String, dynamic> toJson() {
    return {
      'pickup_address': pickUpAddress != null
          ? WashyAddressModel.fromEntity(pickUpAddress!).toJson()
          : null,
      'dropoff_address': dropOffAddress != null
          ? WashyAddressModel.fromEntity(dropOffAddress!).toJson()
          : null,
      'note': note,
      'pickup_date': pickUpDate != null
          ? DateSlotModel.fromEntity(pickUpDate!).toJson()
          : null,
      'dropoff_date': dropOffDate != null
          ? DateSlotModel.fromEntity(dropOffDate!).toJson()
          : null,
      'pickup_time_slot': pickUpTimeSlot != null
          ? TimeSlotModel.fromEntity(pickUpTimeSlot!).toJson()
          : null,
      'dropoff_time_slot': dropOffTimeSlot != null
          ? TimeSlotModel.fromEntity(dropOffTimeSlot!).toJson()
          : null,
      'redeem_code': redeemCode,
      'is_deliver_at_same_location': isDeliverAtSameLocation,
      'position_of_selected_pickup_date': positionOfSelectedPickupDate,
      'position_of_selected_pickup_time': positionOfSelectedPickupTime,
      'position_of_selected_dropoff_date': positionOfSelectedDropOffDate,
      'position_of_selected_dropoff_time': positionOfSelectedDropOffTime,
      'redeem_result': redeemResult != null
          ? RedeemResultModel.fromEntity(redeemResult!).toJson()
          : null,
      'is_difference_more_than_day': isDifferenceMoreThanDay,
      'animate_progress_bar': animateProgressBar,
      'last_progress': lastProgress,
      'is_recycle_hanger': isRecycleHanger,
      'is_first_order_coupon_called': isFirstOrderCouponCalled,
      'is_edit_order': isEditOrder,
      'file_data_list': fileDataList
          .map((photo) => PhotoModel.fromEntity(photo).toJson())
          .toList(),
      'file_data_voice_list': fileDataVoiceList
          .map((audio) => AudioRecordModel.fromEntity(audio).toJson())
          .toList(),
      'from_time': fromTime,
      'to_time': toTime,
      'order_date': orderDate,
      'total': total,
      'last_sub_total_value': lastSubTotalValue,
      'navigation_destination': navigationDestination?.toApiString(),
    };
  }

  /// Create from entity
  factory NewOrderRequestModel.fromEntity(NewOrderRequest entity) {
    return NewOrderRequestModel(
      pickUpAddress: entity.pickUpAddress,
      dropOffAddress: entity.dropOffAddress,
      note: entity.note,
      pickUpDate: entity.pickUpDate,
      dropOffDate: entity.dropOffDate,
      pickUpTimeSlot: entity.pickUpTimeSlot,
      dropOffTimeSlot: entity.dropOffTimeSlot,
      redeemCode: entity.redeemCode,
      isDeliverAtSameLocation: entity.isDeliverAtSameLocation,
      positionOfSelectedPickupDate: entity.positionOfSelectedPickupDate,
      positionOfSelectedPickupTime: entity.positionOfSelectedPickupTime,
      positionOfSelectedDropOffDate: entity.positionOfSelectedDropOffDate,
      positionOfSelectedDropOffTime: entity.positionOfSelectedDropOffTime,
      redeemResult: entity.redeemResult,
      isDifferenceMoreThanDay: entity.isDifferenceMoreThanDay,
      animateProgressBar: entity.animateProgressBar,
      lastProgress: entity.lastProgress,
      isRecycleHanger: entity.isRecycleHanger,
      isFirstOrderCouponCalled: entity.isFirstOrderCouponCalled,
      isEditOrder: entity.isEditOrder,
      fileDataList: entity.fileDataList,
      fileDataVoiceList: entity.fileDataVoiceList,
      fromTime: entity.fromTime,
      toTime: entity.toTime,
      orderDate: entity.orderDate,
      total: entity.total,
      lastSubTotalValue: entity.lastSubTotalValue,
      navigationDestination: entity.navigationDestination,
    );
  }

  /// Convert to JSON string
  String toJsonString() => json.encode(toJson());

  /// Create from JSON string
  static NewOrderRequestModel fromJsonString(String jsonString) =>
      NewOrderRequestModel.fromJson(json.decode(jsonString));
}
