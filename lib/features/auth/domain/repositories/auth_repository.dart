import 'package:dartz/dartz.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  // Check user methods (like Java checkMobile/checkEmail)
  Future<Either<Failure, User>> checkMobile(String phoneNumber);
  Future<Either<Failure, User>> checkEmail(String email);

  // Send verification codes
  Future<Either<Failure, String>> sendSmsVerificationCode(String phoneNumber);
  Future<Either<Failure, String>> sendEmailVerificationCode(String email);
  
  // Forget password - send verification codes
  Future<Either<Failure, String>> sendMobileForgetPasswordCode(String phoneNumber);
  Future<Either<Failure, String>> sendEmailForgetPasswordCode(String email);

  // Verify codes
  Future<Either<Failure, User>> verifySmsCode(String phoneNumber, String code);
  Future<Either<Failure, User>> verifyEmailCode(String email, String code);

  // Social login
  Future<Either<Failure, User>> loginWithGoogle(String idToken);
  Future<Either<Failure, User>> loginWithFacebook(String accessToken);

  // Password related
  Future<Either<Failure, User>> loginWithPassword(String identifier, String password);
  Future<Either<Failure, User>> createPassword(String password);

  // Skip login (guest mode)
  Future<Either<Failure, void>> skipLogin();

  // Session management
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, bool>> isUserLoggedIn();
  Future<Either<Failure, void>> logout();

  // Local session state
  Future<Either<Failure, void>> saveUserSession(User user);
  Future<Either<Failure, void>> clearUserSession();
}

