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
import 'package:wash_flutter/features/auth/domain/usecases/skip_login.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/signup/signup_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/signup/signup_state.dart';

/// SignUpBloc - Handles sign up logic like Java SignUpActivity
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final CheckMobile checkMobile;
  final LoginWithGoogle loginWithGoogle;
  final SendVerificationCode sendVerificationCode;
  final SkipLogin skipLogin;

  SignUpBloc({
    required this.checkMobile,
    required this.loginWithGoogle,
    required this.sendVerificationCode,
    required this.skipLogin,
  }) : super(const SignUpInitial()) {
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<CheckMobilePressed>(_onCheckMobilePressed);
    on<GoogleSignInPressed>(_onGoogleSignInPressed);
    on<EmailSignUpPressed>(_onEmailSignUpPressed);
    on<SkipLoginPressed>(_onSkipLoginPressed);
    on<NavigateToMobileRegistration>(_onNavigateToMobileRegistration);
    on<BackToPreviousScreen>(_onBackToPreviousScreen);
    on<ClearPhoneNumber>(_onClearPhoneNumber);
    on<SendSmsVerificationCode>(_onSendSmsVerificationCode);
  }

  /// Handle phone number changes (like Java's TextWatcher)
  Future<void> _onPhoneNumberChanged(
    PhoneNumberChanged event,
    Emitter<SignUpState> emit,
  ) async {
    if (state is MobileRegistrationMode) {
      final currentState = state as MobileRegistrationMode;
      
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
  }

  /// Handle check mobile pressed (like Java's checkMobile method)
  Future<void> _onCheckMobilePressed(
    CheckMobilePressed event,
    Emitter<SignUpState> emit,
  ) async {
    if (state is MobileRegistrationMode) {
      final currentState = state as MobileRegistrationMode;
      
      if (currentState.phoneNumber.isEmpty) {
        emit(currentState.copyWith(validationMessage: 'Please enter mobile number'));
        return;
      }
      
      if (!currentState.isPhoneValid) {
        emit(currentState.copyWith(validationMessage: 'Please enter a valid phone number'));
        return;
      }

      emit(const SignUpLoading());

      // Format phone number for API (add Jordan country code)
      final formattedPhone = '+962${event.phoneNumber.replaceAll(RegExp(r'^0+'), '')}';
      
      final result = await checkMobile(CheckMobileParams(phoneNumber: formattedPhone));
      
      result.fold(
        (failure) => emit(SignUpError(_mapFailureToMessage(failure))),
        (user) {
          // Handle different account statuses like Java
          switch (user.accountStatus) {
            case AccountStatus.NEW_CUSTOMER:
            case AccountStatus.NOT_VERIFIED_CUSTOMER:
              // Show verification dialog and send SMS
              add(SendSmsVerificationCode(phoneNumber: formattedPhone));
              break;
            case AccountStatus.VERIFIED_CUSTOMER:
              // Navigate to main screen
              emit(NavigateToHome(user));
              break;
            case AccountStatus.ENTER_PASSWORD:
              // Navigate to password screen
              emit(NavigateToPassword(user));
              break;
            default:
              emit(const SignUpError('Unknown account status'));
          }
        },
      );
    }
  }

  /// Handle send SMS verification code (like Java's sendSMSCode)
  Future<void> _onSendSmsVerificationCode(
    SendSmsVerificationCode event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpLoading());

    final verificationRequest = VerificationRequest(
      identifier: event.phoneNumber,
      type: VerificationType.sms,
    );

    final result = await sendVerificationCode(
      SendVerificationCodeParams(request: verificationRequest),
    );

    result.fold(
      (failure) => emit(SignUpError(_mapFailureToMessage(failure))),
      (_) => emit(NavigateToVerification(identifier: event.phoneNumber, type: 'sms')),
    );
  }

  /// Handle Google sign in (like Java's Google login)
  Future<void> _onGoogleSignInPressed(
    GoogleSignInPressed event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpLoading());
    
    // This would typically trigger Google Sign-In flow
    // For now, we'll show an error since it's not fully implemented
    emit(const SignUpError('Google Sign-In not available'));
  }

  /// Handle email sign up (navigates to EmailActivity)
  Future<void> _onEmailSignUpPressed(
    EmailSignUpPressed event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const NavigateToEmail());
  }

  /// Handle skip login (like Java's skip login)
  Future<void> _onSkipLoginPressed(
    SkipLoginPressed event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpLoading());
    
    final result = await skipLogin(NoParams());
    result.fold(
      (failure) => emit(SignUpError(_mapFailureToMessage(failure))),
      (_) => emit(const SkipLoginSuccess()),
    );
  }

  /// Navigate to mobile registration (like Java's isMobileRegistrationShowed = true)
  Future<void> _onNavigateToMobileRegistration(
    NavigateToMobileRegistration event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const MobileRegistrationMode());
  }

  /// Back to previous screen
  Future<void> _onBackToPreviousScreen(
    BackToPreviousScreen event,
    Emitter<SignUpState> emit,
  ) async {
    if (state is MobileRegistrationMode) {
      emit(const SignUpInitial());
    }
  }

  /// Clear phone number
  Future<void> _onClearPhoneNumber(
    ClearPhoneNumber event,
    Emitter<SignUpState> emit,
  ) async {
    if (state is MobileRegistrationMode) {
      final currentState = state as MobileRegistrationMode;
      emit(currentState.copyWith(
        phoneNumber: '',
        isPhoneValid: false,
        validationMessage: null,
      ));
    }
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