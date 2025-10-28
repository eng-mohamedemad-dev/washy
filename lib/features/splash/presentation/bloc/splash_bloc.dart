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
    
    // Initialize app
    final initResult = await initializeApp(NoParams());
    await initResult.fold(
      (failure) async => emit(SplashError(failure.message)),
      (success) async {
        // Fetch server URL
        add(FetchServerUrlEvent());
      },
    );
  }

  Future<void> _onFetchServerUrl(FetchServerUrlEvent event, Emitter<SplashState> emit) async {
    final result = await fetchServerUrl(NoParams());
    await result.fold(
      (failure) async => emit(SplashError(failure.message)),
      (serverUrl) async {
        // After fetching server URL, check app config
        add(CheckAppConfig());
      },
    );
  }

  Future<void> _onCheckAppConfig(CheckAppConfig event, Emitter<SplashState> emit) async {
    final result = await getAppConfig(NoParams());
    await result.fold(
      (failure) async => emit(SplashError(failure.message)),
      (appConfig) async {
        emit(SplashConfigLoaded(appConfig));
        
        // Determine navigation after a delay (like Java version)
        await Future.delayed(const Duration(milliseconds: 3000));
        add(NavigateToNext());
      },
    );
  }

  Future<void> _onNavigateToNext(NavigateToNext event, Emitter<SplashState> emit) async {
    final currentState = state;
    if (currentState is SplashConfigLoaded) {
      final appConfig = currentState.appConfig;
      
      if (appConfig.isWalkThroughConsumed) {
        // Go to splash screen (user has seen intro)
        emit(SplashNavigateToSplash());
      } else {
        // Go to intro screen (user hasn't seen intro)
        emit(SplashNavigateToIntro());
      }
    }
  }
}

