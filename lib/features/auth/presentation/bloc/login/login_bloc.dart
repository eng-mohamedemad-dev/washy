import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import 'package:wash_flutter/core/utils/phone_validator.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
import 'package:wash_flutter/features/auth/domain/entities/account_status.dart';
import 'package:wash_flutter/features/auth/domain/entities/verification_request.dart';
import 'package:wash_flutter/features/auth/domain/usecases/check_mobile.dart';
import 'package:wash_flutter/features/auth/domain/usecases/login_with_google.dart';
import 'package:wash_flutter/features/auth/domain/usecases/send_verification_code.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/login/login_state.dart';

/// LoginBloc - Handles login logic like Java LoginActivity
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CheckMobile checkMobile;
  final LoginWithGoogle loginWithGoogle;
  final SendVerificationCode sendVerificationCode;

  LoginBloc({
    required this.checkMobile,
    required this.loginWithGoogle,
    required this.sendVerificationCode,
  }) : super(const LoginInitial()) {
    on<LoginPhoneNumberChanged>(_onPhoneNumberChanged);
    on<LoginCheckMobilePressed>(_onCheckMobilePressed);
    on<LoginGoogleSignInPressed>(_onGoogleSignInPressed);
    on<LoginEmailPressed>(_onEmailPressed);
    on<NavigateToSignUpPressed>(_onNavigateToSignUpPressed);
  }

  /// Handle phone number changes (like Java's TextWatcher)
  Future<void> _onPhoneNumberChanged(
    LoginPhoneNumberChanged event,
    Emitter<LoginState> emit,
  ) async {
    final currentState = state is LoginPhoneInputState 
        ? state as LoginPhoneInputState
        : const LoginPhoneInputState();
    
    final isValid = PhoneValidator.isValidJordanianPhoneNumber(event.phoneNumber);
    
    String? validationMessage;
    if (event.phoneNumber.isNotEmpty && !isValid) {
      validationMessage = 'Please enter a valid phone number';
    }

    emit(currentState.copyWith(
      phoneNumber: event.phoneNumber,
      isPhoneValid: isValid,
      validationMessage: validationMessage,
    ));
  }

  /// Handle check mobile for login (like Java's checkMobile for existing users)
  Future<void> _onCheckMobilePressed(
    LoginCheckMobilePressed event,
    Emitter<LoginState> emit,
  ) async {
    final currentState = state is LoginPhoneInputState 
        ? state as LoginPhoneInputState
        : const LoginPhoneInputState();
    
    if (currentState.phoneNumber.isEmpty) {
      emit(currentState.copyWith(validationMessage: 'Please enter mobile number'));
      return;
    }
    
    if (!currentState.isPhoneValid) {
      emit(currentState.copyWith(validationMessage: 'Please enter a valid phone number'));
      return;
    }

    emit(const LoginLoading());

    // Format phone number for API (add Jordan country code)
    final formattedPhone = '+962${event.phoneNumber.replaceAll(RegExp(r'^0+'), '')}';
    
    final result = await checkMobile(CheckMobileParams(phoneNumber: formattedPhone));
    
    result.fold(
      (failure) => emit(LoginError(_mapFailureToMessage(failure))),
      (user) {
        // Handle different account statuses for LOGIN (different from SignUp)
        switch (user.accountStatus) {
          case AccountStatus.NEW_CUSTOMER:
            // User doesn't exist, navigate to sign up
            emit(const LoginNavigateToSignUp());
            break;
          case AccountStatus.NOT_VERIFIED_CUSTOMER:
            // User exists but not verified, send verification code
            _sendVerificationCode(formattedPhone, emit);
            break;
          case AccountStatus.VERIFIED_CUSTOMER:
            // User is verified, navigate to main screen
            emit(LoginSuccess(user: user));
            break;
          case AccountStatus.ENTER_PASSWORD:
            // User needs to enter password
            emit(LoginNavigateToPassword(user));
            break;
          default:
            emit(const LoginError('Unknown account status'));
        }
      },
    );
  }

  /// Send verification code for login
  Future<void> _sendVerificationCode(
    String phoneNumber, 
    Emitter<LoginState> emit,
  ) async {
    final verificationRequest = VerificationRequest(
      identifier: phoneNumber,
      type: VerificationType.sms,
    );

    final result = await sendVerificationCode(
      SendVerificationCodeParams(request: verificationRequest),
    );

    result.fold(
      (failure) => emit(LoginError(_mapFailureToMessage(failure))),
      (_) => emit(LoginNavigateToVerification(identifier: phoneNumber, type: 'sms')),
    );
  }

  /// Handle Google sign in for login
  Future<void> _onGoogleSignInPressed(
    LoginGoogleSignInPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    
    // This would typically trigger Google Sign-In flow
    // For now, we'll show an error since it's not fully implemented
    emit(const LoginError('Google Sign-In not available'));
  }

  /// Handle email login navigation
  Future<void> _onEmailPressed(
    LoginEmailPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginNavigateToEmail());
  }

  /// Handle navigate to sign up
  Future<void> _onNavigateToSignUpPressed(
    NavigateToSignUpPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginNavigateToSignUp());
  }

  /// Map failures to user-friendly messages
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return (failure as ServerFailure).message;
      case CacheFailure _:
        return (failure as CacheFailure).message;
      case NetworkFailure _:
        return (failure as NetworkFailure).message;
      default:
        return 'Unexpected Error';
    }
  }
}
