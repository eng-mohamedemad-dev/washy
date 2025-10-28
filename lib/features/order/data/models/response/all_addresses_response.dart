import 'package:equatable/equatable.dart';
import '../washy_address_model.dart';

/// All Addresses Response model (matching Java AllAddressesResponse)
class AllAddressesResponse extends Equatable {
  final AllAddressesData? data;
  final String? message;
  final String? status;

  const AllAddressesResponse({
    this.data,
    this.message,
    this.status,
  });

  factory AllAddressesResponse.fromJson(Map<String, dynamic> json) {
    return AllAddressesResponse(
      data: json['data'] != null 
          ? AllAddressesData.fromJson(json['data']) 
          : null,
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'message': message,
      'status': status,
    };
  }

  /// Get addresses list for compatibility with repository  
  List<WashyAddressModel> get addresses => data?.addresses ?? [];

  @override
  List<Object?> get props => [data, message, status];
}

/// All Addresses Data model
class AllAddressesData extends Equatable {
  final List<WashyAddressModel> addresses;

  const AllAddressesData({required this.addresses});

  factory AllAddressesData.fromJson(Map<String, dynamic> json) {
    return AllAddressesData(
      addresses: json['addresses'] != null
          ? List<WashyAddressModel>.from(
              json['addresses'].map((x) => WashyAddressModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addresses': addresses.map((address) => address.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [addresses];
}
