part of 'splash_bloc.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class StartApp extends SplashEvent {}

class FetchServerUrlEvent extends SplashEvent {}

class CheckAppConfig extends SplashEvent {}

class NavigateToNext extends SplashEvent {}

