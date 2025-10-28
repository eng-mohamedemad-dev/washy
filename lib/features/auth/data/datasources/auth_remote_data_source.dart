import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wash_flutter/core/constants/app_constants.dart';
import 'package:wash_flutter/core/errors/exceptions.dart';
import 'package:wash_flutter/features/auth/data/models/check_user_response.dart';
import 'package:wash_flutter/features/auth/data/models/sms_response.dart';
import 'package:wash_flutter/features/auth/data/models/user_model.dart';
import 'package:wash_flutter/features/auth/data/models/verify_code_response.dart';

abstract class AuthRemoteDataSource {
  Future<CheckUserResponse> checkMobile(String phoneNumber);
  Future<CheckUserResponse> checkEmail(String email);
  Future<SmsResponse> sendSmsVerificationCode(String phoneNumber);
  Future<SmsResponse> sendEmailVerificationCode(String email);
  Future<VerifyCodeResponse> verifySmsCode(String phoneNumber, String code);
  Future<VerifyCodeResponse> verifyEmailCode(String email, String code);
  Future<UserModel> loginWithGoogle(String idToken);
  Future<UserModel> loginWithFacebook(String accessToken);
  Future<UserModel> loginWithPassword(String identifier, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<CheckUserResponse> checkMobile(String phoneNumber) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}apicheck_mobile'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mobile': phoneNumber}),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      // Both success and expected errors (like user exists) are handled here
      return CheckUserResponse.fromJson(json.decode(response.body));
    } else {
      throw const ServerException('Failed to check mobile number');
    }
  }

  @override
  Future<CheckUserResponse> checkEmail(String email) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}api}check_email'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return CheckUserResponse.fromJson(json.decode(response.body));
    } else {
      throw const ServerException('Failed to check email');
    }
  }

  @override
  Future<SmsResponse> sendSmsVerificationCode(String phoneNumber) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}api}send_sms_code'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mobile': phoneNumber}),
    );

    if (response.statusCode == 200) {
      return SmsResponse.fromJson(json.decode(response.body));
    } else {
      throw const ServerException('Failed to send SMS verification code');
    }
  }

  @override
  Future<SmsResponse> sendEmailVerificationCode(String email) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}api}send_email_code'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      return SmsResponse.fromJson(json.decode(response.body));
    } else {
      throw const ServerException('Failed to send email verification code');
    }
  }

  @override
  Future<VerifyCodeResponse> verifySmsCode(String phoneNumber, String code) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}api}verify_sms_code'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'mobile': phoneNumber,
        'code': code,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return VerifyCodeResponse.fromJson(json.decode(response.body));
    } else {
      throw const ServerException('Failed to verify SMS code');
    }
  }

  @override
  Future<VerifyCodeResponse> verifyEmailCode(String email, String code) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}api}verify_email_code'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'code': code,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return VerifyCodeResponse.fromJson(json.decode(response.body));
    } else {
      throw const ServerException('Failed to verify email code');
    }
  }

  @override
  Future<UserModel> loginWithGoogle(String idToken) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}api}login_google'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id_token': idToken}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserModel.fromJson(jsonResponse['data']);
    } else {
      throw const ServerException('Failed to login with Google');
    }
  }

  @override
  Future<UserModel> loginWithFacebook(String accessToken) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}api}login_facebook'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'access_token': accessToken}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserModel.fromJson(jsonResponse['data']);
    } else {
      throw const ServerException('Failed to login with Facebook');
    }
  }

  @override
  Future<UserModel> loginWithPassword(String identifier, String password) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}api}login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'identifier': identifier, // phone or email
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserModel.fromJson(jsonResponse['data']);
    } else {
      throw const ServerException('Failed to login with password');
    }
  }
}
