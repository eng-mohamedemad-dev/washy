import 'package:equatable/equatable.dart';
import 'account_status.dart';
import 'login_type.dart';

class User extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? token;
  final String? profileImage;
  final AccountStatus accountStatus;
  final LoginType loginType;

  const User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.token,
    this.profileImage,
    required this.accountStatus,
    required this.loginType,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        token,
        profileImage,
        accountStatus,
        loginType,
      ];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? token,
    String? profileImage,
    AccountStatus? accountStatus,
    LoginType? loginType,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      token: token ?? this.token,
      profileImage: profileImage ?? this.profileImage,
      accountStatus: accountStatus ?? this.accountStatus,
      loginType: loginType ?? this.loginType,
    );
  }
}

enum AccountStatus {
  newCustomer,
  notVerifiedCustomer,
  verifiedCustomer,
  enterPassword,
}

enum LoginType {
  phone,
  email,
  google,
  facebook,
  guest,
}

enum LoginMethod {
  phone,
  email,
  gmail,
  facebook,
}

