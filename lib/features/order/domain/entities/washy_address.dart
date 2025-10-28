import 'package:equatable/equatable.dart';

/// Address Type enumeration
enum AddressType {
  home,
  work,
  other;

  String get displayName {
    switch (this) {
      case AddressType.home:
        return 'Home';
      case AddressType.work:
        return 'Work';
      case AddressType.other:
        return 'Other';
    }
  }

  String get arabicDisplayName {
    switch (this) {
      case AddressType.home:
        return 'المنزل';
      case AddressType.work:
        return 'العمل';
      case AddressType.other:
        return 'آخر';
    }
  }
}

/// WashyAddress entity (matching Java WashyAddress)
class WashyAddress extends Equatable {
  final int addressId;
  final String address;
  final String area;
  final double latitude;
  final double longitude;
  final String mobile;
  final AddressType addressType;
  final bool isDefault;
  final String? building;
  final String? apartment;
  final String? floor;
  final String? additionalInfo;

  const WashyAddress({
    required this.addressId,
    required this.address,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.mobile,
    required this.addressType,
    this.isDefault = false,
    this.building,
    this.apartment,
    this.floor,
    this.additionalInfo,
  });

  /// Get full address display
  String get fullAddress {
    final parts = <String>[address];
    if (area.isNotEmpty) parts.add(area);
    if (building != null && building!.isNotEmpty) parts.add('Building $building');
    if (apartment != null && apartment!.isNotEmpty) parts.add('Apt $apartment');
    if (floor != null && floor!.isNotEmpty) parts.add('Floor $floor');
    return parts.join(', ');
  }

  /// Get short address display
  String get shortAddress {
    if (area.isNotEmpty) {
      return '$area - ${addressType.arabicDisplayName}';
    }
    return addressType.arabicDisplayName;
  }

  /// Get address title (alias for short address)
  String get addressTitle => shortAddress;

  @override
  List<Object?> get props => [
        addressId,
        address,
        area,
        latitude,
        longitude,
        mobile,
        addressType,
        isDefault,
        building,
        apartment,
        floor,
        additionalInfo,
      ];

  /// Copy with updated values
  WashyAddress copyWith({
    int? addressId,
    String? address,
    String? area,
    double? latitude,
    double? longitude,
    String? mobile,
    AddressType? addressType,
    bool? isDefault,
    String? building,
    String? apartment,
    String? floor,
    String? additionalInfo,
  }) {
    return WashyAddress(
      addressId: addressId ?? this.addressId,
      address: address ?? this.address,
      area: area ?? this.area,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      mobile: mobile ?? this.mobile,
      addressType: addressType ?? this.addressType,
      isDefault: isDefault ?? this.isDefault,
      building: building ?? this.building,
      apartment: apartment ?? this.apartment,
      floor: floor ?? this.floor,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}
