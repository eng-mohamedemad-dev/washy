import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/utils/phone_validator.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
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
    on<CheckMobileRequested>(_onCheckMobileRequested);
    on<LoginGoogleSignInPressed>(_onGoogleSignInPressed);
    on<LoginEmailPressed>(_onEmailPressed);
    on<NavigateToSignUpPressed>(_onNavigateToSignUpPressed);
  }

  /// Handle phone number changes (like Java's TextWatcher)
  /// Matching Java: MobileValidationUtils.isValidPhoneNumberLength
  Future<void> _onPhoneNumberChanged(
    LoginPhoneNumberChanged event,
    Emitter<LoginState> emit,
  ) async {
    final currentState = state is LoginPhoneInputState
        ? state as LoginPhoneInputState
        : const LoginPhoneInputState();

    // Matching Java: MobileValidationUtils.isValidPhoneNumberLength
    // Java checks: if phone starts with "7", expected length is 9, otherwise 10
    const int countryPhoneNumberCharacters = 10;
    bool isValid = false;
    
    if (event.phoneNumber.isNotEmpty) {
      if (event.phoneNumber.startsWith('7')) {
        isValid = event.phoneNumber.length == (countryPhoneNumberCharacters - 1); // 9 digits
      } else {
        isValid = event.phoneNumber.length == countryPhoneNumberCharacters; // 10 digits
      }
    }

    String? validationMessage;
    if (event.phoneNumber.isNotEmpty && !isValid) {
      validationMessage = null; // Hide validation message when typing (matching Java)
    }

    emit(currentState.copyWith(
      phoneNumber: event.phoneNumber,
      isPhoneValid: isValid,
      validationMessage: validationMessage,
    ));
    
    print('[LoginBloc] Phone changed: ${event.phoneNumber} -> isValid=$isValid');
  }

  /// Handle check mobile requested (matching Java callCheckMobile in SignUpActivity)
  Future<void> _onCheckMobileRequested(
    CheckMobileRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    // تنسيق رقم الهاتف وفق تطبيق الجافا: رقم محلي يبدأ بـ 0
    final rawDigits = event.phoneNumber.replaceAll(RegExp('[^0-9]'), '');
    final formattedPhone = rawDigits.startsWith('0') ? rawDigits : '0$rawDigits';

    print('[LoginBloc] Checking mobile (SignUp): $formattedPhone');

    final result =
        await checkMobile(CheckMobileParams(phoneNumber: formattedPhone));

    result.fold(
      (failure) {
        print('[LoginBloc] Check Mobile Failed: $failure');
        // Handle error response (matching Java handleCheckMobileResponse with error)
        emit(const LoginPhoneInputState(validationMessage: 'Invalid number'));
      },
      (user) {
        print(
            '[LoginBloc] Check Mobile Success: Account Status = ${user.accountStatus}');
        // Handle different account statuses (matching Java handleCheckMobileResponse)
        switch (user.accountStatus) {
          case AccountStatus.newCustomer:
            // New user - send verification code
            _sendVerificationCode(formattedPhone, emit);
            break;
          case AccountStatus.notVerifiedCustomer:
            // Not verified - send verification code
            _sendVerificationCode(formattedPhone, emit);
            break;
          case AccountStatus.verifiedCustomer:
            // Verified customer - navigate to password
            emit(LoginNavigateToPassword(user));
            break;
          case AccountStatus.enterPassword:
            // Enter password
            emit(LoginNavigateToPassword(user));
            break;
        }
      },
    );
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
      emit(currentState.copyWith(
          validationMessage: 'من فضلك أدخل رقم الموبايل'));
      return;
    }

    if (!currentState.isPhoneValid) {
      emit(currentState.copyWith(
          validationMessage: 'من فضلك أدخل رقم موبايل صحيحًا'));
      return;
    }

    emit(const LoginLoading());

    // تنسيق رقم الهاتف وفق تطبيق الجافا: رقم محلي يبدأ بـ 0 (بدون +962)
    final rawDigits = event.phoneNumber.replaceAll(RegExp('[^0-9]'), '');
    final formattedPhone = rawDigits.startsWith('0') ? rawDigits : '0$rawDigits';

    print('[LoginBloc] Checking mobile: $formattedPhone');

    final result =
        await checkMobile(CheckMobileParams(phoneNumber: formattedPhone));

    print(
        '[LoginBloc] Check Mobile Result: ${result.isRight() ? "Success" : "Failure"}');

    result.fold(
      (failure) {
        print('[LoginBloc] Check Mobile Failed: $failure');
        emit(LoginError(_mapFailureToMessage(failure)));
      },
      (user) {
        print(
            '[LoginBloc] Check Mobile Success: Account Status = ${user.accountStatus}');
        // Handle different account statuses for LOGIN (different from SignUp)
        switch (user.accountStatus) {
          case AccountStatus.newCustomer:
            // User doesn't exist, navigate to sign up
            emit(const LoginNavigateToSignUp());
            break;
          case AccountStatus.notVerifiedCustomer:
            // User exists but not verified, send verification code
            _sendVerificationCode(formattedPhone, emit);
            break;
          case AccountStatus.verifiedCustomer:
            // User is verified, navigate to main screen
            emit(LoginSuccess(user: user));
            break;
          case AccountStatus.enterPassword:
            // User needs to enter password
            emit(LoginNavigateToPassword(user));
            break;
        }
      },
    );
  }

  /// Send verification code for login (like Java's sendVerificationCode)
  Future<void> _sendVerificationCode(
    String phoneNumber,
    Emitter<LoginState> emit,
  ) async {
    final verificationRequest = VerificationRequest(
      identifier: phoneNumber,
      type: VerificationType.sms,
    );

    print('[LoginBloc] Sending verification code to: $phoneNumber');

    final result = await sendVerificationCode(
      SendVerificationCodeParams(request: verificationRequest),
    );

    print(
        '[LoginBloc] Send Verification Result: ${result.isRight() ? "Success" : "Failure"}');

    result.fold(
      (failure) {
        print('[LoginBloc] Send Verification Failed: $failure');
        emit(LoginError(_mapFailureToMessage(failure)));
      },
      (status) {
        print('[LoginBloc] Send Verification Success: Status = $status');
        // Check if SMS was sent successfully (like Java: SMS_SENT_SUCCESS.equals(status))
        final statusLower = status.toLowerCase();
        if (statusLower == 'sms_sent' || statusLower == 'sms_sent_success') {
          emit(LoginNavigateToVerification(
              identifier: phoneNumber, type: 'sms'));
        } else {
          print('[LoginBloc] Unexpected status: $status');
          emit(LoginError('فشل إرسال كود التحقق: $status'));
        }
      },
    );
  }

  /// Handle Google sign in for login
  Future<void> _onGoogleSignInPressed(
    LoginGoogleSignInPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    // لم يتم تفعيل تسجيل جوجل حالياً
    emit(const LoginError('تسجيل الدخول عبر جوجل غير متاح حالياً'));
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
    print('[LoginBloc] Failure Type: ${failure.runtimeType}');
    print('[LoginBloc] Failure: $failure');

    if (failure is ServerFailure) {
      final message = failure.message;
      print('[LoginBloc] ServerFailure Message: $message');
      // Return Arabic message if it's already in Arabic, otherwise return the message
      return message.isNotEmpty ? message : 'حدث خطأ في الخادم';
    } else if (failure is CacheFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : 'حدث خطأ في التخزين المحلي';
    } else if (failure is NetworkFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : 'لا يوجد اتصال بالإنترنت';
    } else {
      print(
          '[LoginBloc] Unknown Failure Type: ${failure.runtimeType}, Failure: $failure');
      return 'حدث خطأ غير متوقع: ${failure.toString()}';
    }
  }
}
