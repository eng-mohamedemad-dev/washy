import 'package:wash_flutter/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    super.id,
    super.name,
    super.email,
    super.phoneNumber,
    super.token,
    super.profileImage,
    required super.accountStatus,
    required super.loginType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone'] ?? json['mobile'],
      token: json['token'],
      profileImage: json['profile_image'],
      accountStatus: _parseAccountStatus(json['login_status'] ?? json['status']),
      loginType: _parseLoginType(json['login_type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phoneNumber,
      'token': token,
      'profile_image': profileImage,
      'login_status': _accountStatusToString(accountStatus),
      'login_type': _loginTypeToString(loginType),
    };
  }

  static AccountStatus _parseAccountStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'new_customer':
        return AccountStatus.newCustomer;
      case 'not_verified_customer':
      case 'unverified': // بعض الاستجابات ترجع unverified للبريد
        return AccountStatus.notVerifiedCustomer;
      case 'verified_customer':
      case 'verified':
        return AccountStatus.verifiedCustomer;
      case 'enter_password':
        return AccountStatus.enterPassword;
      case 'missing_headers': // معالجة حالة missing_headers
        return AccountStatus.notVerifiedCustomer;
      default:
        return AccountStatus.newCustomer;
    }
  }

  static LoginType _parseLoginType(String? type) {
    switch (type?.toLowerCase()) {
      case 'phone':
        return LoginType.phone;
      case 'email':
        return LoginType.email;
      case 'google':
        return LoginType.google;
      case 'facebook':
        return LoginType.facebook;
      case 'guest':
        return LoginType.guest;
      default:
        return LoginType.phone;
    }
  }

  static String _accountStatusToString(AccountStatus status) {
    switch (status) {
      case AccountStatus.newCustomer:
        return 'new_customer';
      case AccountStatus.notVerifiedCustomer:
        return 'not_verified_customer';
      case AccountStatus.verifiedCustomer:
        return 'verified_customer';
      case AccountStatus.enterPassword:
        return 'enter_password';
    }
  }

  static String _loginTypeToString(LoginType type) {
    switch (type) {
      case LoginType.phone:
        return 'phone';
      case LoginType.email:
        return 'email';
      case LoginType.google:
        return 'google';
      case LoginType.facebook:
        return 'facebook';
      case LoginType.guest:
        return 'guest';
    }
  }

  factory UserModel.guest() {
    return const UserModel(
      accountStatus: AccountStatus.verifiedCustomer,
      loginType: LoginType.guest,
    );
  }
}

