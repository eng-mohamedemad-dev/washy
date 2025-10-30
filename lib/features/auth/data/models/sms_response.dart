class SmsResponse {
  final String status;
  final String? message;
  final SmsCodeData? smsCodeData;
  final SmsResponseData? data;

  const SmsResponse({
    required this.status,
    this.message,
    this.smsCodeData,
    this.data,
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
      data: dataMap != null ? SmsResponseData.fromJson(dataMap) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'sms_code_data': smsCodeData?.toJson(),
      'data': data?.toJson(),
    };
  }
}

/// Data wrapper for error responses (like Java BaseErrorResponse.Data)
class SmsResponseData {
  final String? loginStatus;
  final String? message;
  final int? totalSmsLeft;

  const SmsResponseData({
    this.loginStatus,
    this.message,
    this.totalSmsLeft,
  });

  factory SmsResponseData.fromJson(Map<String, dynamic> json) {
    return SmsResponseData(
      loginStatus: json['login_status'],
      message: json['message'],
      totalSmsLeft: json['total_sms_left'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login_status': loginStatus,
      'message': message,
      'total_sms_left': totalSmsLeft,
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
