import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_config.dart';
import '../../domain/usecases/fetch_server_url.dart';
import '../../domain/usecases/get_app_config.dart';
import '../../domain/usecases/initialize_app.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FetchServerUrl fetchServerUrl;
  final GetAppConfig getAppConfig;
  final InitializeApp initializeApp;

  SplashBloc({
    required this.fetchServerUrl,
    required this.getAppConfig,
    required this.initializeApp,
  }) : super(SplashInitial()) {
    on<StartApp>(_onStartApp);
    on<FetchServerUrlEvent>(_onFetchServerUrl);
    on<CheckAppConfig>(_onCheckAppConfig);
    on<NavigateToNext>(_onNavigateToNext);
  }

  Future<void> _onStartApp(StartApp event, Emitter<SplashState> emit) async {
    emit(SplashLoading());

    try {
      // Initialize app with timeout
      final initResult =
          await initializeApp(NoParams()).timeout(const Duration(seconds: 5));
      await initResult.fold(
        (failure) async {
          // On failure, still proceed to check app config
          add(CheckAppConfig());
        },
        (success) async {
          // Fetch server URL
          add(FetchServerUrlEvent());
        },
      );
    } catch (e) {
      // On timeout or error, proceed directly to check app config
      add(CheckAppConfig());
    }
  }

  Future<void> _onFetchServerUrl(
      FetchServerUrlEvent event, Emitter<SplashState> emit) async {
    try {
      final result =
          await fetchServerUrl(NoParams()).timeout(const Duration(seconds: 5));
      await result.fold(
        (failure) async {
          // On failure, proceed to check app config anyway
          add(CheckAppConfig());
        },
        (serverUrl) async {
          // After fetching server URL, check app config
          add(CheckAppConfig());
        },
      );
    } catch (e) {
      // On timeout or error, proceed to check app config
      add(CheckAppConfig());
    }
  }

  Future<void> _onCheckAppConfig(
      CheckAppConfig event, Emitter<SplashState> emit) async {
    try {
      final result =
          await getAppConfig(NoParams()).timeout(const Duration(seconds: 5));
      await result.fold(
        (failure) async {
          // On failure, use default config and navigate to intro
          emit(SplashConfigLoaded(AppConfig(
            serverUrl: '',
            isWalkThroughConsumed: false,
            isUserLoggedIn: false,
            isUserLoggedInSkipped: false,
            userToken: null,
          )));
          await Future.delayed(const Duration(milliseconds: 1500));
          add(NavigateToNext());
        },
        (appConfig) async {
          emit(SplashConfigLoaded(appConfig));

          // Determine navigation after a delay (like Java version)
          await Future.delayed(const Duration(milliseconds: 1500));
          add(NavigateToNext());
        },
      );
    } catch (e) {
      // On timeout or error, use default config and navigate to intro
      emit(SplashConfigLoaded(AppConfig(
        serverUrl: '',
        isWalkThroughConsumed: false,
        isUserLoggedIn: false,
        isUserLoggedInSkipped: false,
        userToken: null,
      )));
      await Future.delayed(const Duration(milliseconds: 500));
      add(NavigateToNext());
    }
  }

  Future<void> _onNavigateToNext(
      NavigateToNext event, Emitter<SplashState> emit) async {
    // Navigate directly to Login after Splash
    emit(SplashNavigateToSplash());
  }
}
