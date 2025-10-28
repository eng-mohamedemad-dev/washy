import 'package:equatable/equatable.dart';

class AppConfig extends Equatable {
  final String serverUrl;
  final bool isWalkThroughConsumed;
  final bool isUserLoggedIn;
  final bool isUserLoggedInSkipped;
  final String? userToken;

  const AppConfig({
    required this.serverUrl,
    required this.isWalkThroughConsumed,
    required this.isUserLoggedIn,
    required this.isUserLoggedInSkipped,
    this.userToken,
  });

  @override
  List<Object?> get props => [
        serverUrl,
        isWalkThroughConsumed,
        isUserLoggedIn,
        isUserLoggedInSkipped,
        userToken,
      ];
}

