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
  Future<Either<Failure, String>> sendSmsVerificationCode(
      String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.sendSmsVerificationCode(phoneNumber);
        // Return status from smsCodeData.login_status (like Java)
        final status = response.smsCodeData?.status ?? response.status;
        return Right(status);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendEmailVerificationCode(
      String email) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.sendEmailVerificationCode(email);
        
        print('[AuthRepository] sendEmailVerificationCode response:');
        print('[AuthRepository] - status: ${response.status}');
        print('[AuthRepository] - smsCodeData?.status: ${response.smsCodeData?.status}');
        print('[AuthRepository] - data?.loginStatus: ${response.data?.loginStatus}');
        
        // Check loginStatus from data first (for exceeds_limit, verified_customer, etc.)
        final loginStatus = response.data?.loginStatus;
        if (loginStatus != null) {
          print('[AuthRepository] Found loginStatus in data: $loginStatus');
          return Right(loginStatus);
        }
        
        // Fallback to smsCodeData.status or response.status
        final status = response.smsCodeData?.status ?? response.status;
        print('[AuthRepository] Using status from smsCodeData or response: $status');
        return Right(status);
      } on ServerException catch (e) {
        print('[AuthRepository] ServerException caught with message: "${e.message}"');
        final failure = ServerFailure(e.message);
        print('[AuthRepository] Created ServerFailure with message: "${failure.message}"');
        return Left(failure);
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendMobileForgetPasswordCode(
      String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.sendMobileForgetPasswordCode(phoneNumber);
        // Return status from smsCodeData.login_status (like Java)
        final status = response.smsCodeData?.status ?? response.status;
        return Right(status);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendEmailForgetPasswordCode(
      String email) async {
    if (await networkInfo.isConnected) {
      try {
        // Call API and check response
        print('[AuthRepository] Calling sendEmailForgetPasswordCode for email: $email');
        final response = await remoteDataSource.sendEmailForgetPasswordCode(email);
        
        print('[AuthRepository] Response received:');
        print('[AuthRepository] - status: ${response.status}');
        print('[AuthRepository] - message: ${response.message}');
        print('[AuthRepository] - smsCodeData.status: ${response.smsCodeData?.status}');
        print('[AuthRepository] - smsCodeData.message: ${response.smsCodeData?.message}');
        print('[AuthRepository] - data.message: ${response.data?.message}');
        print('[AuthRepository] - data.loginStatus: ${response.data?.loginStatus}');
        
        // Check if exceeds_limit - if no code was sent, navigate directly to create password page
        final isExceedsLimit = response.status.toLowerCase() == 'exceeds_limit' ||
                               response.data?.message?.toLowerCase() == 'exceeds_limit';
        final totalEmailsLeft = response.data?.totalEmailsLeft;
        
        if (isExceedsLimit || (totalEmailsLeft != null && totalEmailsLeft == 0)) {
          print('[AuthRepository] ⚠️ exceeds_limit detected - no code was sent');
          print('[AuthRepository] Returning exceeds_limit status to navigate directly to create password page');
          return const Right('exceeds_limit');
        }
        
        // Normal success case - code was sent successfully
        print('[AuthRepository] ✅ Code sent successfully, returning email_sent');
        return const Right('email_sent');
      } on ServerException catch (e) {
        print('[AuthRepository] ServerException: ${e.message}');
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> verifySmsCode(
      String phoneNumber, String code) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.verifySmsCode(phoneNumber, code);
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
        return Left(
            ServerFailure(response.data?.message ?? 'Verification failed'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> verifyEmailCode(
      String email, String code) async {
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
        return Left(
            ServerFailure(response.data?.message ?? 'Verification failed'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> verifyMobileForgetPasswordCode(
      String phoneNumber, String code) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.verifyMobileForgetPasswordCode(
            phoneNumber, code);
        print('[AuthRepository] VerifyMobileForgetPasswordCode response status: ${response.data.status}');
        if (response.data.status.toLowerCase() == 'verified') {
          final user = response.data.user?.copyWith(
            token: response.data.token,
            phoneNumber: phoneNumber,
          );
          if (user != null) {
            await localDataSource.cacheUser(user.toModel());
            return Right(user);
          }
        }
        return Left(
            ServerFailure(response.data?.message ?? 'Verification failed'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> verifyEmailFromForgetPassword(
      String email, String code) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.verifyEmailFromForgetPassword(email, code);
        print('[AuthRepository] VerifyEmailFromForgetPassword response status: ${response.data.status}');
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
        return Left(
            ServerFailure(response.data?.message ?? 'Verification failed'));
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
  Future<Either<Failure, User>> loginWithPassword(
      String token, String password) async {
    if (await networkInfo.isConnected) {
      try {
        print('[AuthRepository] Calling loginWithPassword with token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...');
        final userModel =
            await remoteDataSource.loginWithPassword(token, password);
        await localDataSource.cacheUser(userModel);
        // UserModel extends User, so we can use it directly
        print('[AuthRepository] Login successful, user cached');
        return Right(userModel);
      } on ServerException catch (e) {
        print('[AuthRepository] Login failed: ${e.message}');
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> createPassword(String password) async {
    // Java: PasswordActivity.callSetPassword() -> WebServiceManager.setPassword(token, password, device)
    // Java: handlePasswordUpdated() checks for PASSWORD_UPDATED status, then goes to TermsAndConditionsPage
    if (await networkInfo.isConnected) {
      try {
        // Get token from SharedPreferences (like Java's SessionStateManager.getInstance().getToken(this))
        final lastUser = await localDataSource.getLastUser();
        if (lastUser == null || lastUser.token == null || lastUser.token!.isEmpty) {
          return const Left(ServerFailure('خطأ في المصادقة: لم يتم العثور على رمز التحقق'));
        }
        
        final token = lastUser.token!;
        print('[AuthRepository] Calling setPassword with token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...');
        
        final userModel = await remoteDataSource.setPassword(token, password);
        
        // Cache updated user (like Java saves token and phone number)
        await localDataSource.cacheUser(userModel);
        print('[AuthRepository] Password set successfully, user cached');
        
        return Right(userModel);
      } on ServerException catch (e) {
        print('[AuthRepository] Set password failed: ${e.message}');
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
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
