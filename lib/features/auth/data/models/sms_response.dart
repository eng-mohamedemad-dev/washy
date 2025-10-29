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
    // Java SendSMSCodeResponse structure: { "data": { "login_status": "..." } }
    final data = json['data'] ?? json['sms_code_data'];
    final dataMap = data is Map<String, dynamic>
        ? data
        : data is Map
            ? Map<String, dynamic>.from(data)
            : null;
    return SmsResponse(
      status: dataMap?['login_status'] ??
          dataMap?['status'] ??
          json['status'] ??
          '',
      message: json['message'] ?? dataMap?['message'],
      smsCodeData: dataMap != null ? SmsCodeData.fromJson(dataMap) : null,
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
    // Java Data structure: { "login_status": "..." }
    return SmsCodeData(
      status: json['login_status'] ?? json['status'] ?? '',
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
