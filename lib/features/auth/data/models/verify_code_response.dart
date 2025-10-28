import 'package:wash_flutter/features/auth/data/models/user_model.dart';

class VerifyCodeResponse {
  final VerifyCodeData data;
  final String? message;
  final bool success;

  const VerifyCodeResponse({
    required this.data,
    this.message,
    this.success = true,
  });

  factory VerifyCodeResponse.fromJson(Map<String, dynamic> json) {
    return VerifyCodeResponse(
      data: VerifyCodeData.fromJson(json['data'] ?? json),
      message: json['message'],
      success: json['success'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'message': message,
      'success': success,
    };
  }
}

class VerifyCodeData {
  final String status;
  final String? message;
  final String? token;
  final UserModel? user;

  const VerifyCodeData({
    required this.status,
    this.message,
    this.token,
    this.user,
  });

  factory VerifyCodeData.fromJson(Map<String, dynamic> json) {
    return VerifyCodeData(
      status: json['status'] ?? json['message'] ?? '',
      message: json['message'],
      token: json['token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token': token,
      'user': user?.toJson(),
    };
  }
}

