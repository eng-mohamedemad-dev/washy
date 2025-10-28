part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashConfigLoaded extends SplashState {
  final AppConfig appConfig;

  const SplashConfigLoaded(this.appConfig);

  @override
  List<Object> get props => [appConfig];
}

class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object> get props => [message];
}

class SplashNavigateToIntro extends SplashState {}

class SplashNavigateToSplash extends SplashState {}

