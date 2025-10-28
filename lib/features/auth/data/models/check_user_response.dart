import 'package:wash_flutter/features/auth/data/models/user_model.dart';

class CheckUserResponse {
  final UserModel userData;
  final String? message;
  final bool success;

  const CheckUserResponse({
    required this.userData,
    this.message,
    this.success = true,
  });

  factory CheckUserResponse.fromJson(Map<String, dynamic> json) {
    return CheckUserResponse(
      userData: UserModel.fromJson(json['data'] ?? json['user_data'] ?? json),
      message: json['message'],
      success: json['success'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': userData.toJson(),
      'message': message,
      'success': success,
    };
  }
}

