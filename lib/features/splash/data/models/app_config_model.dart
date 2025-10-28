import '../../domain/entities/app_config.dart';

class AppConfigModel extends AppConfig {
  const AppConfigModel({
    required super.serverUrl,
    required super.isWalkThroughConsumed,
    required super.isUserLoggedIn,
    required super.isUserLoggedInSkipped,
    super.userToken,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      serverUrl: json['server_url'] ?? '',
      isWalkThroughConsumed: json['walk_through_consumed'] ?? false,
      isUserLoggedIn: json['user_logged_in'] ?? false,
      isUserLoggedInSkipped: json['user_logged_in_skipped'] ?? false,
      userToken: json['user_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'server_url': serverUrl,
      'walk_through_consumed': isWalkThroughConsumed,
      'user_logged_in': isUserLoggedIn,
      'user_logged_in_skipped': isUserLoggedInSkipped,
      'user_token': userToken,
    };
  }

  AppConfigModel copyWith({
    String? serverUrl,
    bool? isWalkThroughConsumed,
    bool? isUserLoggedIn,
    bool? isUserLoggedInSkipped,
    String? userToken,
  }) {
    return AppConfigModel(
      serverUrl: serverUrl ?? this.serverUrl,
      isWalkThroughConsumed: isWalkThroughConsumed ?? this.isWalkThroughConsumed,
      isUserLoggedIn: isUserLoggedIn ?? this.isUserLoggedIn,
      isUserLoggedInSkipped: isUserLoggedInSkipped ?? this.isUserLoggedInSkipped,
      userToken: userToken ?? this.userToken,
    );
  }
}

