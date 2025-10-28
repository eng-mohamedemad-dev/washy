import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_flutter/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getLastUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser();
  Future<bool> isUserLoggedIn();
  Future<void> setUserLoggedIn(bool loggedIn);
  Future<void> setUserLoggedInSkipped(bool skipped);
  Future<bool> isUserLoggedInSkipped();
  Future<void> setPhoneNumber(String phoneNumber);
  Future<String?> getPhoneNumber();
  Future<void> setEmail(String email);
  Future<String?> getEmail();
}

const CACHED_USER = 'CACHED_USER';
const USER_LOGGED_IN = 'USER_LOGGED_IN';
const USER_LOGGED_IN_SKIPPED = 'USER_LOGGED_IN_SKIPPED';
const CACHED_PHONE_NUMBER = 'CACHED_PHONE_NUMBER';
const CACHED_EMAIL = 'CACHED_EMAIL';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getLastUser() async {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      try {
        return UserModel.fromJson(json.decode(jsonString));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      CACHED_USER,
      json.encode(user.toJson()),
    );
    await setUserLoggedIn(true);
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(CACHED_USER);
    await setUserLoggedIn(false);
    await setUserLoggedInSkipped(false);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return sharedPreferences.getBool(USER_LOGGED_IN) ?? false;
  }

  @override
  Future<void> setUserLoggedIn(bool loggedIn) async {
    await sharedPreferences.setBool(USER_LOGGED_IN, loggedIn);
  }

  @override
  Future<void> setUserLoggedInSkipped(bool skipped) async {
    await sharedPreferences.setBool(USER_LOGGED_IN_SKIPPED, skipped);
    if (skipped) {
      // If user skipped login, cache a guest user
      await cacheUser(UserModel.guest());
    }
  }

  @override
  Future<bool> isUserLoggedInSkipped() async {
    return sharedPreferences.getBool(USER_LOGGED_IN_SKIPPED) ?? false;
  }

  @override
  Future<void> setPhoneNumber(String phoneNumber) async {
    await sharedPreferences.setString(CACHED_PHONE_NUMBER, phoneNumber);
  }

  @override
  Future<String?> getPhoneNumber() async {
    return sharedPreferences.getString(CACHED_PHONE_NUMBER);
  }

  @override
  Future<void> setEmail(String email) async {
    await sharedPreferences.setString(CACHED_EMAIL, email);
  }

  @override
  Future<String?> getEmail() async {
    return sharedPreferences.getString(CACHED_EMAIL);
  }
}
