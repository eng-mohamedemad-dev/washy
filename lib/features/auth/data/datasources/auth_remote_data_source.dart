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
    try {
      final url = '${AppConstants.baseUrl}customer/auth/check-mobile';
      final body = 'mobile=${Uri.encodeComponent(phoneNumber)}';

      print('[API] Check Mobile - URL: $url');
      print('[API] Check Mobile - Body: $body');
      print('[API] Check Mobile - Phone Number: $phoneNumber');

      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'device': 'mobile'
        },
        body: body,
      );

      print('[API] Check Mobile Response Status: ${response.statusCode}');
      print('[API] Check Mobile Response Headers: ${response.headers}');
      print('[API] Check Mobile Response Body: ${response.body}');

      // Java handles both 200 and 400 as valid responses
      if (response.statusCode == 200 || response.statusCode == 400) {
        try {
          final jsonData = json.decode(response.body) as Map<String, dynamic>;
          print('[API] Parsed Check Mobile Response: $jsonData');
          return CheckUserResponse.fromJson(jsonData);
        } catch (e) {
          print('[API] JSON Parse Error: $e');
          print('[API] Response body that failed to parse: ${response.body}');
          throw ServerException('Invalid response format: ${e.toString()}');
        }
      } else {
        // Try to parse error response
        try {
          final errorJson = json.decode(response.body) as Map<String, dynamic>;
          print('[API] Check Mobile Error Response: $errorJson');
          final errorMessage = errorJson['message'] ??
              errorJson['error'] ??
              'Failed to check mobile number (${response.statusCode})';
          throw ServerException(errorMessage);
        } catch (e) {
          if (e is ServerException) rethrow;
          print(
              '[API] Check Mobile Error: ${response.statusCode} - ${response.body}');
          throw ServerException(
              'Failed to check mobile number (${response.statusCode}): ${response.body}');
        }
      }
    } catch (e) {
      print('[API] Check Mobile Exception: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<CheckUserResponse> checkEmail(String email) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}customer/auth/check-email'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'device': 'mobile'
      },
      body: 'email=${Uri.encodeComponent(email)}',
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return CheckUserResponse.fromJson(json.decode(response.body));
    } else {
      throw const ServerException('Failed to check email');
    }
  }

  @override
  Future<SmsResponse> sendSmsVerificationCode(String phoneNumber) async {
    try {
      final url = '${AppConstants.baseUrl}customer/auth/send-verification';
      final body = 'mobile=${Uri.encodeComponent(phoneNumber)}';

      print('[API] Send SMS Verification - URL: $url');
      print('[API] Send SMS Verification - Body: $body');
      print('[API] Send SMS Verification - Phone Number: $phoneNumber');

      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'device': 'mobile'
        },
        body: body,
      );

      print('[API] SMS Verification Response Status: ${response.statusCode}');
      print('[API] SMS Verification Response Headers: ${response.headers}');
      print('[API] SMS Verification Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body) as Map<String, dynamic>;
          print('[API] Parsed SMS Response: $jsonData');
          return SmsResponse.fromJson(jsonData);
        } catch (e) {
          print('[API] SMS JSON Parse Error: $e');
          print('[API] Response body that failed to parse: ${response.body}');
          throw ServerException('Invalid response format: ${e.toString()}');
        }
      } else {
        // Try to parse error response
        try {
          final errorJson = json.decode(response.body) as Map<String, dynamic>;
          print('[API] SMS Error Response: $errorJson');
          final errorMessage = errorJson['message'] ??
              errorJson['error'] ??
              'Failed to send SMS verification code (${response.statusCode})';
          throw ServerException(errorMessage);
        } catch (e) {
          if (e is ServerException) rethrow;
          print('[API] SMS Error: ${response.statusCode} - ${response.body}');
          throw ServerException(
              'Failed to send SMS verification code (${response.statusCode}): ${response.body}');
        }
      }
    } catch (e) {
      print('[API] Send SMS Verification Exception: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<SmsResponse> sendEmailVerificationCode(String email) async {
    try {
      final response = await client.post(
        Uri.parse(
            '${AppConstants.baseUrl}customer/auth/send-email-verification'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'device': 'mobile'
        },
        body: 'email=${Uri.encodeComponent(email)}',
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return SmsResponse.fromJson(jsonData);
      } else {
        // Try to parse error response
        try {
          final errorJson = json.decode(response.body) as Map<String, dynamic>;
          throw ServerException(
              errorJson['message'] ?? 'Failed to send email verification code');
        } catch (_) {
          throw ServerException(
              'Failed to send email verification code (${response.statusCode})');
        }
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<VerifyCodeResponse> verifySmsCode(
      String phoneNumber, String code) async {
    final response = await client.post(
      Uri.parse('${AppConstants.baseUrl}customer/auth/code-verification'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'device': 'mobile'
      },
      body:
          'mobile=${Uri.encodeComponent(phoneNumber)}&code=${Uri.encodeComponent(code)}',
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
      Uri.parse('${AppConstants.baseUrl}customer/auth/code-verification'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'device': 'mobile'
      },
      body:
          'email=${Uri.encodeComponent(email)}&code=${Uri.encodeComponent(code)}',
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
  Future<UserModel> loginWithPassword(
      String identifier, String password) async {
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
