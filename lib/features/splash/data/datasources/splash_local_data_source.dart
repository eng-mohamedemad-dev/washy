import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/app_config_model.dart';

abstract class SplashLocalDataSource {
  Future<AppConfigModel> getAppConfig();
  Future<void> setServerUrl(String url);
  Future<void> setWalkThroughConsumed(bool consumed);
  Future<bool> isWalkThroughConsumed();
  Future<String?> getUserToken();
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final SharedPreferences sharedPreferences;

  SplashLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<AppConfigModel> getAppConfig() async {
    try {
      final serverUrl =
          sharedPreferences.getString(AppConstants.keyServerUrl) ?? '';
      final walkThroughConsumed =
          sharedPreferences.getBool(AppConstants.keyWalkThroughConsumed) ??
              false;
      final userLoggedIn =
          sharedPreferences.getBool(AppConstants.keyUserLoggedIn) ?? false;
      final userLoggedInSkipped =
          sharedPreferences.getBool(AppConstants.keyUserLoggedInSkipped) ??
              false;
      final userToken = sharedPreferences.getString(AppConstants.keyUserToken);

      return AppConfigModel(
        serverUrl: serverUrl,
        isWalkThroughConsumed: walkThroughConsumed,
        isUserLoggedIn: userLoggedIn,
        isUserLoggedInSkipped: userLoggedInSkipped,
        userToken: userToken,
      );
    } catch (e) {
      throw CacheException('Failed to get app config: $e');
    }
  }

  @override
  Future<void> setServerUrl(String url) async {
    try {
      await sharedPreferences.setString(AppConstants.keyServerUrl, url);
    } catch (e) {
      throw CacheException('Failed to set server URL: $e');
    }
  }

  @override
  Future<void> setWalkThroughConsumed(bool consumed) async {
    try {
      await sharedPreferences.setBool(
          AppConstants.keyWalkThroughConsumed, consumed);
    } catch (e) {
      throw CacheException('Failed to set walk through consumed: $e');
    }
  }

  @override
  Future<bool> isWalkThroughConsumed() async {
    try {
<<<<<<< HEAD
      return sharedPreferences.getBool(AppConstants.keyWalkThroughConsumed) ??
          false;
=======
      return sharedPreferences.getBool(AppConstants.keyWalkThroughConsumed) ?? false;
>>>>>>> 5c5db153474f1b053ffffec8498ffaf3824e95cd
    } catch (e) {
      throw CacheException('Failed to get walk through consumed: $e');
    }
  }

  @override
  Future<String?> getUserToken() async {
    try {
      return sharedPreferences.getString(AppConstants.keyUserToken);
    } catch (e) {
      throw CacheException('Failed to get user token: $e');
    }
  }
}
