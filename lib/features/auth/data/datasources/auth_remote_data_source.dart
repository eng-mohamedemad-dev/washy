import 'dart:convert';
import 'dart:ui' as ui;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

  Future<Map<String, String>> _headersForm() async {
    String platform = 'android';
    String version = '1.0.0';
    String device = 'android';
    String lang = ui.PlatformDispatcher.instance.locale.languageCode;

    try {
      final info = await DeviceInfoPlugin().androidInfo;
      device = '${info.manufacturer} ${info.model}'.trim();
    } catch (_) {}

    try {
      final pkg = await PackageInfo.fromPlatform();
      version = pkg.version;
    } catch (_) {}

    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'platform': platform,
      'version': version,
      'device': device,
      'lang': lang,
    };
    print('[API] Common Headers: ' + headers.toString());
    return headers;
  }

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
        headers: await _headersForm(),
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
    final url = '${AppConstants.baseUrl}customer/auth/check-email';
    final body = 'email=${Uri.encodeComponent(email)}';
    print('[API] Check Email - URL: $url');
    print('[API] Check Email - Body: $body');

    final response = await client.post(
      Uri.parse(url),
      headers: await _headersForm(),
      body: body,
    );

    print('[API] Check Email Response Status: ${response.statusCode}');
    print('[API] Check Email Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 403) {
      return CheckUserResponse.fromJson(json.decode(response.body));
    } else {
      try {
        final err = json.decode(response.body) as Map<String, dynamic>;
        throw ServerException(err['message'] ?? 'Failed to check email');
      } catch (_) {
        throw const ServerException('Failed to check email');
      }
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
        headers: await _headersForm(),
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
      final url =
          '${AppConstants.baseUrl}customer/auth/send-email-verification';
      final body = 'email=${Uri.encodeComponent(email)}';
      print('[API] Send Email Verification - URL: $url');
      print('[API] Send Email Verification - Body: $body');

      final response = await client.post(
        Uri.parse(url),
        headers: await _headersForm(),
        body: body,
      );

      print('[API] Email Verification Response Status: ${response.statusCode}');
      print('[API] Email Verification Response Headers: ${response.headers}');
      print('[API] Email Verification Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return SmsResponse.fromJson(jsonData);
      } else if (response.statusCode == 301 || response.statusCode == 400 || response.statusCode == 403) {
        // Handle error response with login_status (like Java)
        try {
          final errorJson = json.decode(response.body) as Map<String, dynamic>;
          print('[API] Error JSON: $errorJson');
          final data = errorJson['data'] as Map<String, dynamic>?;
          print('[API] Error data: $data');
          final loginStatus = data != null ? (data['login_status'] as String?) : null;
          print('[API] Login status: $loginStatus');
          
          // Handle different error cases (matching Java)
          // In Java, even when login_status is exceeds_limit, it still navigates to password page
          // So we return the status as a valid response, not as an error
          if (loginStatus == 'does_not_exists') {
            throw ServerException('أنت عميل جديد. من فضلك أنشئ حساباً.');
          }
          
          // Return ANY login_status as a valid response for bloc to handle (like Java)
          if (loginStatus != null) {
            print('[API] Returning login_status as valid response: $loginStatus');
            final errorData = {'login_status': loginStatus};
            return SmsResponse.fromJson({
              'status': 'success',
              'data': errorData,
            });
          }
          
          throw ServerException(
              errorJson['message'] ?? 'فشل إرسال كود التحقق عبر الإيميل');
        } catch (e) {
          if (e is ServerException) rethrow;
          throw ServerException(
              'فشل إرسال كود التحقق عبر الإيميل (${response.statusCode})');
        }
      } else {
        // Handle any other error status codes
        try {
          final errorJson = json.decode(response.body) as Map<String, dynamic>;
          throw ServerException(
              errorJson['message'] ?? 'فشل إرسال كود التحقق عبر الإيميل (${response.statusCode})');
        } catch (e) {
          if (e is ServerException) rethrow;
          throw ServerException(
              'فشل إرسال كود التحقق عبر الإيميل (${response.statusCode})');
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
