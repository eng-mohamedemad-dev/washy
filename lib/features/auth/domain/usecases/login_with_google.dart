import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
import 'package:wash_flutter/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogle implements UseCase<User, LoginWithGoogleParams> {
  final AuthRepository repository;

  LoginWithGoogle(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginWithGoogleParams params) async {
    return await repository.loginWithGoogle(params.idToken);
  }
}

class LoginWithGoogleParams extends Equatable {
  final String idToken;

  const LoginWithGoogleParams({required this.idToken});

  @override
  List<Object?> get props => [idToken];
}

