class SmsResponse {
  final String status;
  final String? message;
  final SmsCodeData? smsCodeData;

  const SmsResponse({
    required this.status,
    this.message,
    this.smsCodeData,
  });

  factory SmsResponse.fromJson(Map<String, dynamic> json) {
    return SmsResponse(
      status: json['status'] ?? '',
      message: json['message'],
      smsCodeData: json['sms_code_data'] != null
          ? SmsCodeData.fromJson(json['sms_code_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'sms_code_data': smsCodeData?.toJson(),
    };
  }
}

class SmsCodeData {
  final String status;
  final String? code; // For testing purposes only
  final String? message;

  const SmsCodeData({
    required this.status,
    this.code,
    this.message,
  });

  factory SmsCodeData.fromJson(Map<String, dynamic> json) {
    return SmsCodeData(
      status: json['status'] ?? '',
      code: json['code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
    };
  }
}

