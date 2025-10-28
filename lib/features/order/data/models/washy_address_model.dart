import 'dart:convert';
import '../../domain/entities/washy_address.dart';

/// WashyAddress data model for serialization
class WashyAddressModel extends WashyAddress {
  const WashyAddressModel({
    required super.addressId,
    required super.address,
    required super.area,
    required super.latitude,
    required super.longitude,
    required super.mobile,
    required super.addressType,
    super.isDefault,
    super.building,
    super.apartment,
    super.floor,
    super.additionalInfo,
  });

  /// Create from JSON (matching Java WashyAddress)
  factory WashyAddressModel.fromJson(Map<String, dynamic> json) {
    return WashyAddressModel(
      addressId: json['address_id'] ?? 0,
      address: json['address'] ?? '',
      area: json['area'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      mobile: json['mobile'] ?? '',
      addressType: _mapAddressType(json['address_type'] ?? 'other'),
      isDefault: (json['is_default'] ?? 0) == 1,
      building: json['building'],
      apartment: json['apartment'],
      floor: json['floor'],
      additionalInfo: json['additional_info'],
    );
  }

  /// Convert to JSON (matching Java WashyAddress)
  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'address': address,
      'area': area,
      'latitude': latitude,
      'longitude': longitude,
      'mobile': mobile,
      'address_type': addressType.name,
      'is_default': isDefault ? 1 : 0,
      'building': building,
      'apartment': apartment,
      'floor': floor,
      'additional_info': additionalInfo,
    };
  }

  /// Create from entity
  factory WashyAddressModel.fromEntity(WashyAddress entity) {
    return WashyAddressModel(
      addressId: entity.addressId,
      address: entity.address,
      area: entity.area,
      latitude: entity.latitude,
      longitude: entity.longitude,
      mobile: entity.mobile,
      addressType: entity.addressType,
      isDefault: entity.isDefault,
      building: entity.building,
      apartment: entity.apartment,
      floor: entity.floor,
      additionalInfo: entity.additionalInfo,
    );
  }

  /// Convert to JSON string
  String toJsonString() => json.encode(toJson());

  /// Create from JSON string
  static WashyAddressModel fromJsonString(String jsonString) =>
      WashyAddressModel.fromJson(json.decode(jsonString));

  /// Convert to entity
  WashyAddress toEntity() => this;

  /// Map string to AddressType
  static AddressType _mapAddressType(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return AddressType.home;
      case 'work':
        return AddressType.work;
      case 'other':
      default:
        return AddressType.other;
    }
  }

  /// Copy with updated values (override to return WashyAddressModel)
  @override
  WashyAddressModel copyWith({
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
    return WashyAddressModel(
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
