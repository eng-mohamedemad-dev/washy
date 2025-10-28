import 'package:dartz/dartz.dart';
import 'package:wash_flutter/core/errors/exceptions.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/utils/network_info.dart';
import 'package:wash_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:wash_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:wash_flutter/features/auth/data/models/user_model.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
import 'package:wash_flutter/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> checkMobile(String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.checkMobile(phoneNumber);
        await localDataSource.setPhoneNumber(phoneNumber);
        return Right(response.userData);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> checkEmail(String email) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.checkEmail(email);
        await localDataSource.setEmail(email);
        return Right(response.userData);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendSmsVerificationCode(String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.sendSmsVerificationCode(phoneNumber);
        return Right(response.status);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendEmailVerificationCode(String email) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.sendEmailVerificationCode(email);
        return Right(response.status);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> verifySmsCode(String phoneNumber, String code) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.verifySmsCode(phoneNumber, code);
        if (response.data.status.toLowerCase() == 'verified') {
          // User is verified, cache the user with token
          final user = response.data.user?.copyWith(
            token: response.data.token,
            phoneNumber: phoneNumber,
          );
          if (user != null) {
            await localDataSource.cacheUser(user.toModel());
            return Right(user);
          }
        }
        return Left(ServerFailure(response.data?.message ?? 'Verification failed'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> verifyEmailCode(String email, String code) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.verifyEmailCode(email, code);
        if (response.data.status.toLowerCase() == 'verified') {
          final user = response.data.user?.copyWith(
            token: response.data.token,
            email: email,
          );
          if (user != null) {
            await localDataSource.cacheUser(user.toModel());
            return Right(user);
          }
        }
        return Left(ServerFailure(response.data?.message ?? 'Verification failed'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle(String idToken) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.loginWithGoogle(idToken);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithFacebook(String accessToken) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.loginWithFacebook(accessToken);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithPassword(String identifier, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.loginWithPassword(identifier, password);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> createPassword(String password) async {
    // This would typically create a password for a verified user
    // Implementation depends on API design
    return const Left(ServerFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, void>> skipLogin() async {
    try {
      await localDataSource.setUserLoggedInSkipped(true);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getLastUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isUserLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isUserLoggedIn();
      final isSkipped = await localDataSource.isUserLoggedInSkipped();
      return Right(isLoggedIn || isSkipped);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserSession(User user) async {
    try {
          await localDataSource.cacheUser(user.toModel());
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearUserSession() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

// Helper extension to convert User to UserModel
extension UserModelExtension on User {
  UserModel toModel() {
    return UserModel(
      id: this.id,
      name: this.name,
      email: this.email,
      phoneNumber: this.phoneNumber,
      token: this.token,
      profileImage: this.profileImage,
      accountStatus: this.accountStatus,
      loginType: this.loginType,
    );
  }
}
