import 'package:equatable/equatable.dart';
import 'washy_address.dart';
import 'date_slot.dart';
import 'time_slot.dart';
import 'redeem_result.dart';
import 'photo.dart';
import 'audio_record.dart';
import 'navigation_destination.dart';

/// New Order Request entity (matching Java NewOrderRequest)
class NewOrderRequest extends Equatable {
  final WashyAddress? pickUpAddress;
  final WashyAddress? dropOffAddress;
  final String? note;
  final DateSlot? pickUpDate;
  final DateSlot? dropOffDate;
  final TimeSlot? pickUpTimeSlot;
  final TimeSlot? dropOffTimeSlot;
  final String? redeemCode;
  final bool isDeliverAtSameLocation;
  final int positionOfSelectedPickupDate;
  final int positionOfSelectedPickupTime;
  final int positionOfSelectedDropOffDate;
  final int positionOfSelectedDropOffTime;
  final RedeemResult? redeemResult;
  final bool isDifferenceMoreThanDay;
  final bool animateProgressBar;
  final int lastProgress;
  final bool isRecycleHanger;
  final bool isFirstOrderCouponCalled;
  final bool isEditOrder;
  final List<Photo> fileDataList;
  final List<AudioRecord> fileDataVoiceList;
  final String? fromTime;
  final String? toTime;
  final String? orderDate;
  final double total;
  final double lastSubTotalValue;
  final NavigationDestination? navigationDestination;

  const NewOrderRequest({
    this.pickUpAddress,
    this.dropOffAddress,
    this.note,
    this.pickUpDate,
    this.dropOffDate,
    this.pickUpTimeSlot,
    this.dropOffTimeSlot,
    this.redeemCode,
    this.isDeliverAtSameLocation = true,
    this.positionOfSelectedPickupDate = 0,
    this.positionOfSelectedPickupTime = 0,
    this.positionOfSelectedDropOffDate = 0,
    this.positionOfSelectedDropOffTime = 0,
    this.redeemResult,
    this.isDifferenceMoreThanDay = true,
    this.animateProgressBar = false,
    this.lastProgress = -1,
    this.isRecycleHanger = false,
    this.isFirstOrderCouponCalled = false,
    this.isEditOrder = false,
    this.fileDataList = const [],
    this.fileDataVoiceList = const [],
    this.fromTime,
    this.toTime,
    this.orderDate,
    this.total = 0.0,
    this.lastSubTotalValue = 0.0,
    this.navigationDestination,
  });

  /// Check if pickup address is selected
  bool get hasPickupAddress => pickUpAddress != null;

  /// Check if dropoff address is selected
  bool get hasDropoffAddress => dropOffAddress != null || isDeliverAtSameLocation;

  /// Check if pickup date and time are selected
  bool get hasPickupDateTime => pickUpDate != null && pickUpTimeSlot != null;

  /// Check if dropoff date and time are selected
  bool get hasDropoffDateTime => dropOffDate != null && dropOffTimeSlot != null;

  /// Check if order is ready to be submitted
  bool get isReadyToSubmit {
    return hasPickupAddress &&
           hasDropoffAddress &&
           hasPickupDateTime &&
           hasDropoffDateTime &&
           isDifferenceMoreThanDay;
  }

  /// Get total number of attachments
  int get totalAttachments => fileDataList.length + fileDataVoiceList.length;

  /// Check if has any attachments
  bool get hasAttachments => totalAttachments > 0;

  /// Get formatted pickup date time
  String? get formattedPickupDateTime {
    if (pickUpDate == null || pickUpTimeSlot == null) return null;
    return '${pickUpDate!.displayDate} - ${pickUpTimeSlot!.displayTime}';
  }

  /// Get formatted dropoff date time
  String? get formattedDropoffDateTime {
    if (dropOffDate == null || dropOffTimeSlot == null) return null;
    return '${dropOffDate!.displayDate} - ${dropOffTimeSlot!.displayTime}';
  }

  @override
  List<Object?> get props => [
        pickUpAddress,
        dropOffAddress,
        note,
        pickUpDate,
        dropOffDate,
        pickUpTimeSlot,
        dropOffTimeSlot,
        redeemCode,
        isDeliverAtSameLocation,
        positionOfSelectedPickupDate,
        positionOfSelectedPickupTime,
        positionOfSelectedDropOffDate,
        positionOfSelectedDropOffTime,
        redeemResult,
        isDifferenceMoreThanDay,
        animateProgressBar,
        lastProgress,
        isRecycleHanger,
        isFirstOrderCouponCalled,
        isEditOrder,
        fileDataList,
        fileDataVoiceList,
        fromTime,
        toTime,
        orderDate,
        total,
        lastSubTotalValue,
        navigationDestination,
      ];

  /// Copy with updated values
  NewOrderRequest copyWith({
    WashyAddress? pickUpAddress,
    WashyAddress? dropOffAddress,
    String? note,
    DateSlot? pickUpDate,
    DateSlot? dropOffDate,
    TimeSlot? pickUpTimeSlot,
    TimeSlot? dropOffTimeSlot,
    String? redeemCode,
    bool? isDeliverAtSameLocation,
    int? positionOfSelectedPickupDate,
    int? positionOfSelectedPickupTime,
    int? positionOfSelectedDropOffDate,
    int? positionOfSelectedDropOffTime,
    RedeemResult? redeemResult,
    bool? isDifferenceMoreThanDay,
    bool? animateProgressBar,
    int? lastProgress,
    bool? isRecycleHanger,
    bool? isFirstOrderCouponCalled,
    bool? isEditOrder,
    List<Photo>? fileDataList,
    List<AudioRecord>? fileDataVoiceList,
    String? fromTime,
    String? toTime,
    String? orderDate,
    double? total,
    double? lastSubTotalValue,
    NavigationDestination? navigationDestination,
  }) {
    return NewOrderRequest(
      pickUpAddress: pickUpAddress ?? this.pickUpAddress,
      dropOffAddress: dropOffAddress ?? this.dropOffAddress,
      note: note ?? this.note,
      pickUpDate: pickUpDate ?? this.pickUpDate,
      dropOffDate: dropOffDate ?? this.dropOffDate,
      pickUpTimeSlot: pickUpTimeSlot ?? this.pickUpTimeSlot,
      dropOffTimeSlot: dropOffTimeSlot ?? this.dropOffTimeSlot,
      redeemCode: redeemCode ?? this.redeemCode,
      isDeliverAtSameLocation: isDeliverAtSameLocation ?? this.isDeliverAtSameLocation,
      positionOfSelectedPickupDate: positionOfSelectedPickupDate ?? this.positionOfSelectedPickupDate,
      positionOfSelectedPickupTime: positionOfSelectedPickupTime ?? this.positionOfSelectedPickupTime,
      positionOfSelectedDropOffDate: positionOfSelectedDropOffDate ?? this.positionOfSelectedDropOffDate,
      positionOfSelectedDropOffTime: positionOfSelectedDropOffTime ?? this.positionOfSelectedDropOffTime,
      redeemResult: redeemResult ?? this.redeemResult,
      isDifferenceMoreThanDay: isDifferenceMoreThanDay ?? this.isDifferenceMoreThanDay,
      animateProgressBar: animateProgressBar ?? this.animateProgressBar,
      lastProgress: lastProgress ?? this.lastProgress,
      isRecycleHanger: isRecycleHanger ?? this.isRecycleHanger,
      isFirstOrderCouponCalled: isFirstOrderCouponCalled ?? this.isFirstOrderCouponCalled,
      isEditOrder: isEditOrder ?? this.isEditOrder,
      fileDataList: fileDataList ?? this.fileDataList,
      fileDataVoiceList: fileDataVoiceList ?? this.fileDataVoiceList,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      orderDate: orderDate ?? this.orderDate,
      total: total ?? this.total,
      lastSubTotalValue: lastSubTotalValue ?? this.lastSubTotalValue,
      navigationDestination: navigationDestination ?? this.navigationDestination,
    );
  }
}
