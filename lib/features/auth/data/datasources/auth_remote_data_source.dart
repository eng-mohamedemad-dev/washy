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
import 'package:wash_flutter/features/auth/domain/entities/user.dart' show AccountStatus, LoginType;

abstract class AuthRemoteDataSource {
  Future<CheckUserResponse> checkMobile(String phoneNumber);
  Future<CheckUserResponse> checkEmail(String email);
  Future<SmsResponse> sendSmsVerificationCode(String phoneNumber);
  Future<SmsResponse> sendEmailVerificationCode(String email);
  Future<SmsResponse> sendMobileForgetPasswordCode(String phoneNumber);
  Future<SmsResponse> sendEmailForgetPasswordCode(String email);
  Future<VerifyCodeResponse> verifySmsCode(String phoneNumber, String code);
  Future<VerifyCodeResponse> verifyEmailCode(String email, String code);
  // Forget password verification
  Future<VerifyCodeResponse> verifyMobileForgetPasswordCode(String phoneNumber, String code);
  Future<VerifyCodeResponse> verifyEmailFromForgetPassword(String email, String code);
  Future<UserModel> loginWithGoogle(String idToken);
  Future<UserModel> loginWithFacebook(String accessToken);
  Future<UserModel> loginWithPassword(String identifier, String password);
  Future<UserModel> setPassword(String token, String password);
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
  Future<SmsResponse> sendMobileForgetPasswordCode(String phoneNumber) async {
    try {
      // Java: POST customer/account/mobile/forgot-password/send-code
      final url =
          '${AppConstants.baseUrl}customer/account/mobile/forgot-password/send-code';
      final body = 'mobile=${Uri.encodeComponent(phoneNumber)}';
      print('[API] Send Mobile Forget Password Code - URL: $url');
      print('[API] Send Mobile Forget Password Code - Body: $body');

      final response = await client.post(
        Uri.parse(url),
        headers: await _headersForm(),
        body: body,
      );

      print('[API] Mobile Forget Password Code Response Status: ${response.statusCode}');
      print('[API] Mobile Forget Password Code Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return SmsResponse.fromJson(jsonData);
      } else {
        final errorJson = json.decode(response.body) as Map<String, dynamic>;
        throw ServerException(
            errorJson['message'] ?? 'فشل إرسال كود التحقق للهاتف');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<SmsResponse> sendEmailForgetPasswordCode(String email) async {
    try {
      // Java: POST customer/account/email/forgot-password/send-code
      final url =
          '${AppConstants.baseUrl}customer/account/email/forgot-password/send-code';
      final body = 'email=${Uri.encodeComponent(email)}';
      print('[API] Send Email Forget Password Code - URL: $url');
      print('[API] Send Email Forget Password Code - Body: $body');

      final response = await client.post(
        Uri.parse(url),
        headers: await _headersForm(),
        body: body,
      );

      print('[API] ========================================');
      print('[API] Email Forget Password Code Response');
      print('[API] ========================================');
      print('[API] Status Code: ${response.statusCode}');
      print('[API] Response Body: ${response.body}');
      print('[API] Response Headers: ${response.headers}');
      print('[API] ========================================');
      
      // Parse JSON to check response structure
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      print('[API] Parsed JSON: $jsonData');
      final status = jsonData['status'] as String?;
      final data = jsonData['data'] as Map<String, dynamic>?;
      final message = data?['message'] as String?;
      final totalEmailsLeft = data?['total_emails_left'] as int?;
      print('[API] Extracted values:');
      print('[API]   - status: $status');
      print('[API]   - message: $message');
      print('[API]   - total_emails_left: $totalEmailsLeft');
      print('[API]   - data: $data');

      if (response.statusCode == 200) {
        // Check if status is "fail" with "exceeds_limit" message (like Java)
        if (status == 'fail' && message == 'exceeds_limit') {
          // Return response with "exceeds_limit" status (like Java - navigates directly to password page)
          print('[API] ⚠️ EXCEEDS_LIMIT detected - no code will be sent');
          print('[API] Returning exceeds_limit status to navigate directly to create password page');
          return SmsResponse.fromJson({
            'status': 'exceeds_limit',
            'data': {
              'message': 'exceeds_limit',
              'status': 'exceeds_limit',
              'total_emails_left': totalEmailsLeft ?? 0,
            },
          });
        }
        
        // Normal success case - code was sent successfully
        print('[API] ✅ Normal success response - code was sent');
        print('[API] Parsing as SmsResponse...');
        final smsResponse = SmsResponse.fromJson(jsonData);
        print('[API] Parsed SmsResponse:');
        print('[API]   - status: ${smsResponse.status}');
        print('[API]   - message: ${smsResponse.message}');
        print('[API]   - smsCodeData.status: ${smsResponse.smsCodeData?.status}');
        print('[API]   - smsCodeData.message: ${smsResponse.smsCodeData?.message}');
        print('[API]   - data.message: ${smsResponse.data?.message}');
        print('[API]   - data.loginStatus: ${smsResponse.data?.loginStatus}');
        return smsResponse;
      } else {
        final errorJson = json.decode(response.body) as Map<String, dynamic>;
        throw ServerException(
            errorJson['message'] ?? 'فشل إرسال كود التحقق عبر الإيميل');
      }
    } catch (e) {
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
            // Build response with loginStatus in data (matching Java structure)
            // Make sure loginStatus is accessible via response.data.loginStatus
            final errorData = {
              'login_status': loginStatus,
              'message': data?['message'],
              'total_emails_left': data?['total_emails_left'],
              'total_sms_left': data?['total_sms_left'],
            };
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
  Future<VerifyCodeResponse> verifyMobileForgetPasswordCode(
      String phoneNumber, String code) async {
    // Java: POST customer/account/mobile/forgot-password/verify-code
    final url =
        '${AppConstants.baseUrl}customer/account/mobile/forgot-password/verify-code';
    print('[API] Verify Mobile Forget Password Code - URL: $url');
    print('[API] Verify Mobile Forget Password Code - Body: mobile=$phoneNumber&code=$code');

    final response = await client.post(
      Uri.parse(url),
      headers: await _headersForm(),
      body:
          'mobile=${Uri.encodeComponent(phoneNumber)}&code=${Uri.encodeComponent(code)}',
    );

    print('[API] Verify Mobile Forget Password Code Response Status: ${response.statusCode}');
    print('[API] Verify Mobile Forget Password Code Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 400) {
      return VerifyCodeResponse.fromJson(json.decode(response.body));
    } else {
      throw const ServerException('Failed to verify mobile forget password code');
    }
  }

  @override
  Future<VerifyCodeResponse> verifyEmailFromForgetPassword(
      String email, String code) async {
    // Java: POST customer/account/email/forgot-password/verify-code
    final url =
        '${AppConstants.baseUrl}customer/account/email/forgot-password/verify-code';
    print('[API] Verify Email Forget Password Code - URL: $url');
    print('[API] Verify Email Forget Password Code - Body: email=$email&code=$code');

    final response = await client.post(
      Uri.parse(url),
      headers: await _headersForm(),
      body:
          'email=${Uri.encodeComponent(email)}&code=${Uri.encodeComponent(code)}',
    );

    print('[API] Verify Email Forget Password Code Response Status: ${response.statusCode}');
    print('[API] Verify Email Forget Password Code Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 400) {
      return VerifyCodeResponse.fromJson(json.decode(response.body));
    } else {
      throw const ServerException('Failed to verify email forget password code');
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
      String token, String password) async {
    // Java: POST customer/auth with token and password
    // Java: WebServiceManager.login(SessionStateManager.getInstance().getToken(this), password, device)
    final url = '${AppConstants.baseUrl}customer/auth';
    final body = 'token=${Uri.encodeComponent(token)}&password=${Uri.encodeComponent(password)}';
    print('[API] Login With Password - URL: $url');
    print('[API] Login With Password - Body: token=***&password=***');

    final response = await client.post(
      Uri.parse(url),
      headers: await _headersForm(),
      body: body,
    );

    print('[API] Login With Password Response Status: ${response.statusCode}');
    print('[API] Login With Password Response Body: ${response.body}');

    // Parse response regardless of status code (like Java handles 403)
    final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    final data = jsonResponse['data'] as Map<String, dynamic>?;
    
    if (response.statusCode == 200) {
      print('[API] Login successful, parsing response...');
      if (data != null) {
        // Java LoginResponse structure: { "data": { "login_status": "...", "token": "...", "name": "..." } }
        final loginStatus = data['login_status'] as String?;
        final token = data['token'] as String?;
        final name = data['name'] as String?;
        print('[API] Login response - loginStatus: $loginStatus, token: ${token != null ? "***" : "null"}, name: $name');
        
        // Check if login was successful (Java: LOGGED_IN_STATUS.equals(loginResponse.getData().getLoginStatus()))
        if (loginStatus?.toLowerCase() == 'logged_in') {
          // Create UserModel from response (matching Java LoginResponse structure)
          // Use fromJson to parse the response correctly
          return UserModel.fromJson({
            'id': data['id']?.toString(),
            'name': name,
            'email': data['email'],
            'phone': data['phone_number'],
            'token': token,
            'login_status': 'verified_customer',
            'login_type': 'phone',
          });
        } else {
          throw ServerException('Login failed: ${data['message'] ?? "Unknown error"}');
        }
      } else {
        throw const ServerException('Invalid login response');
      }
    } else if (response.statusCode == 403 || response.statusCode == 400) {
      // Java: onError() checks for WRONG_LOGIN_STATUS and shows error layout
      // Java: WRONG_LOGIN_STATUS = "wrong_login"
      if (data != null) {
        final loginStatus = data['login_status'] as String?;
        print('[API] Login failed - loginStatus: $loginStatus');
        
        if (loginStatus?.toLowerCase() == 'wrong_login') {
          // Java shows error with wrong_password_icon and invalid_password message
          throw ServerException('كلمة السر غير صحيحة، حاول مرة أخرى');
        } else {
          final message = data['message'] as String? ?? jsonResponse['message'] as String?;
          throw ServerException(message ?? 'فشل تسجيل الدخول');
        }
      } else {
        throw ServerException('فشل تسجيل الدخول');
      }
    } else {
      final errorJson = json.decode(response.body) as Map<String, dynamic>;
      throw ServerException(errorJson['message'] ?? 'Failed to login with password');
    }
  }

  @override
  Future<UserModel> setPassword(String token, String password) async {
    // Java: WebServiceManager.setPassword(token, password, device)
    // Endpoint: customer/auth/set-password
    // Parameters: token, password
    // Header: device
    print('[API] Set Password - Starting...');
    print('[API] Set Password - Token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...');
    
    final headers = await _headersForm();
    final device = headers['device'] ?? 'android';
    
    final url = '${AppConstants.baseUrl}customer/auth/set-password';
    final body = 'token=${Uri.encodeComponent(token)}&password=${Uri.encodeComponent(password)}';
    print('[API] Set Password - URL: $url');
    print('[API] Set Password - Body: token=***&password=***');
    print('[API] Common Headers: $headers');
    
    final response = await client.post(
      Uri.parse(url),
      headers: {
        ...headers,
        'device': device, // Add device header separately
      },
      body: body,
    );
    
    print('[API] Set Password Response Status: ${response.statusCode}');
    print('[API] Set Password Response Body: ${response.body}');
    
    final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    final data = jsonResponse['data'] as Map<String, dynamic>?;
    
    if (response.statusCode == 200) {
      // Java: handlePasswordUpdated() checks for PASSWORD_UPDATED status
      // Java: if (PASSWORD_UPDATED.equals(setPasswordResponse.getSetPasswordData().getStatus()))
      // API Response: {"status":"success","data":{"login_status":"password_updated"}}
      if (data != null) {
        // Check login_status in data (like Java checks setPasswordData.getStatus())
        final loginStatus = data['login_status'] as String?;
        print('[API] Set Password - login_status: $loginStatus');
        
        if (loginStatus?.toLowerCase() == 'password_updated') {
          // Java: goToTermsAndConditionsPage() after successful password update
          // Return user with updated token if available
          final userToken = data['token'] as String? ?? token;
          
          // Get user data from SharedPreferences or use minimal user
          // AccountStatus and LoginType are defined in user.dart, not separate files
          return UserModel(
            id: 'temp',
            name: '',
            email: '',
            phoneNumber: '',
            token: userToken,
            accountStatus: AccountStatus.verifiedCustomer, // After password is set, user is verified
            loginType: LoginType.phone, // Default, can be updated
          );
        } else {
          throw ServerException('Password update failed: ${data['message'] ?? "Unknown error"}');
        }
      } else {
        throw const ServerException('Invalid set password response');
      }
    } else {
      final errorJson = json.decode(response.body) as Map<String, dynamic>;
      throw ServerException(errorJson['message'] ?? 'Failed to set password');
    }
  }
}
