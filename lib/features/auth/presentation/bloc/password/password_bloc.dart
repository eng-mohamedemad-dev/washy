import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
import 'package:wash_flutter/features/auth/domain/entities/verification_request.dart';
import 'package:wash_flutter/features/auth/domain/usecases/send_verification_code.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_state.dart';
import 'package:wash_flutter/features/auth/data/datasources/auth_local_data_source.dart';

/// PasswordBloc - Handles password logic like Java PasswordActivity
class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final SendVerificationCode sendVerificationCode;
  final AuthLocalDataSource authLocalDataSource;
  // TODO: Add more use cases for password operations

  PasswordBloc({
    required this.sendVerificationCode,
    required this.authLocalDataSource,
    required User user,
    required bool isNewUser,
  }) : super(PasswordInitial(user: user, isNewUser: isNewUser)) {
    on<PasswordChanged>(_onPasswordChanged);
    on<SetPasswordPressed>(_onSetPasswordPressed);
    on<LoginWithPasswordPressed>(_onLoginWithPasswordPressed);
    on<ForgetPasswordPressed>(_onForgetPasswordPressed);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  /// Handle password changes (like Java's TextWatcher)
  Future<void> _onPasswordChanged(
    PasswordChanged event,
    Emitter<PasswordState> emit,
  ) async {
    // Only handle password changes when in initial state
    if (state is! PasswordInitial) {
      return;
    }
    
    final currentState = state as PasswordInitial;
    
    // Validate password (like Java's validation)
    final isValid = _validatePassword(event.password);
    
    String? validationMessage;
    if (event.password.isNotEmpty && !isValid) {
      // Show error message in Arabic: "يجب أن تكون كلمة السر 6 حروف أو أرقام على الأقل"
      validationMessage = 'يجب أن تكون كلمة السر 6 حروف أو أرقام على الأقل';
    } else {
      // Clear message when valid or empty
      validationMessage = null;
    }

    emit(currentState.copyWith(
      password: event.password,
      isPasswordValid: isValid,
      validationMessage: validationMessage,
    ));
  }

  /// Handle set password for new users (like Java's setPassword)
  Future<void> _onSetPasswordPressed(
    SetPasswordPressed event,
    Emitter<PasswordState> emit,
  ) async {
    final currentState = state as PasswordInitial;
    
    if (!currentState.isPasswordValid) {
      emit(currentState.copyWith(
        validationMessage: 'Please enter a valid password',
      ));
      return;
    }

    emit(const PasswordLoading());

    // TODO: Call setPassword API
    // For now, simulate success
    await Future.delayed(const Duration(seconds: 2));
    
    emit(PasswordSetSuccess(user: event.user));
    
    // Navigate to main screen after a short delay
    await Future.delayed(const Duration(milliseconds: 500));
    emit(NavigateToHome(user: event.user));
  }

  /// Handle login with password for existing users (like Java's login)
  Future<void> _onLoginWithPasswordPressed(
    LoginWithPasswordPressed event,
    Emitter<PasswordState> emit,
  ) async {
    final currentState = state as PasswordInitial;
    if (currentState.password.isEmpty) {
      emit(currentState.copyWith(
        validationMessage: 'من فضلك أدخل كلمة السر',
      ));
      return;
    }

    emit(const PasswordLoading());

    // "محاكاة" تحقق الباسورد: اذا كلمة السر هي "123123" اعتبرها صحيحة
    await Future.delayed(const Duration(seconds: 1));
    if (event.password == '123123') {
      emit(PasswordLoginSuccess(user: event.user));
      // يمكن إضافة تنقل بعد قليل، بناءً على التطبيق الفعلي
      await Future.delayed(const Duration(milliseconds: 500));
      emit(NavigateToHome(user: event.user));
    } else {
      emit(PasswordError('كلمة السر غير صحيحة، حاول مرة أخرى'));
      // أعد الحالة الأولية لتسمح للمستخدم بالمحاولة مجددًا وتظهر الرسالة
      emit(currentState.copyWith(validationMessage: 'كلمة السر غير صحيحة، حاول مرة أخرى'));
    }
  }

  /// Handle forget password (like Java's forget password flow)
  /// Java: callSendVerificationCode() checks if email is empty, then uses phone or email
  /// Java: SessionStateManager.getInstance().getPhoneNumber() for phone
  /// Java: email variable from Intent for email
  Future<void> _onForgetPasswordPressed(
    ForgetPasswordPressed event,
    Emitter<PasswordState> emit,
  ) async {
    try {
      print('[PasswordBloc] ForgetPasswordPressed - Starting...');
      emit(const PasswordLoading());

      // Get email and phoneNumber from SharedPreferences (like Java's SessionStateManager)
      print('[PasswordBloc] Getting saved email and phoneNumber from SharedPreferences...');
      final savedEmail = await authLocalDataSource.getEmail();
      final savedPhoneNumber = await authLocalDataSource.getPhoneNumber();
      print('[PasswordBloc] Saved email: ${savedEmail ?? "null"}, Saved phoneNumber: ${savedPhoneNumber ?? "null"}');

      // Determine identifier (phone or email) - matching Java logic
      // Java: if (TextUtils.isEmpty(email)) { callSendPhoneVerificationCode(); } else { callSendEmailForgetPassword(); }
      String identifier = '';
      VerificationType type = VerificationType.email;
      
      if (savedEmail != null && savedEmail.isNotEmpty) {
        // Java: callSendEmailForgetPassword() if email exists
        identifier = savedEmail;
        type = VerificationType.email;
        print('[PasswordBloc] Using email for forgot password: $identifier');
      } else if (savedPhoneNumber != null && savedPhoneNumber.isNotEmpty) {
        // Java: callSendPhoneVerificationCode() if email is empty
        identifier = savedPhoneNumber;
        type = VerificationType.sms;
        print('[PasswordBloc] Using phoneNumber for forgot password: $identifier');
      } else {
        // Fallback: try user object (in case data not saved to SharedPreferences yet)
        print('[PasswordBloc] No saved data found, checking user object...');
        print('[PasswordBloc] User email: ${event.user.email ?? "null"}, User phoneNumber: ${event.user.phoneNumber ?? "null"}');
        if (event.user.email != null && event.user.email!.isNotEmpty) {
          identifier = event.user.email!;
          type = VerificationType.email;
          print('[PasswordBloc] Using user email: $identifier');
        } else if (event.user.phoneNumber != null && event.user.phoneNumber!.isNotEmpty) {
          identifier = event.user.phoneNumber!;
          type = VerificationType.sms;
          print('[PasswordBloc] Using user phoneNumber: $identifier');
        } else {
          print('[PasswordBloc] ERROR: No phone number or email found');
          emit(const PasswordError('No phone number or email found for password reset'));
          return;
        }
      }

      print('[PasswordBloc] Creating verification request: identifier=$identifier, type=${type.name}, isFromForgetPassword=true');
      final verificationRequest = VerificationRequest(
        identifier: identifier,
        type: type,
        isFromForgetPassword: true,
      );

      print('[PasswordBloc] Calling sendVerificationCode...');
      final result = await sendVerificationCode(
        SendVerificationCodeParams(request: verificationRequest),
      );

      print('[PasswordBloc] sendVerificationCode result: ${result.isRight() ? "Success" : "Failure"}');
      result.fold(
        (failure) {
          print('[PasswordBloc] Error occurred: ${failure.runtimeType}, message: ${failure.message}');
          final errorMessage = _mapFailureToMessage(failure);
          print('[PasswordBloc] Emitting PasswordError: $errorMessage');
          emit(PasswordError(errorMessage));
        },
        (status) {
          print('[PasswordBloc] Code sent successfully, status: $status');
          
          // Handle exceeds_limit - navigate directly to create password page (like Java goToCreatePasswordPage)
          // When exceeds_limit, no code is actually sent, so user cannot verify
          if (status.toLowerCase() == 'exceeds_limit') {
            print('[PasswordBloc] Status is exceeds_limit - no code sent, navigating directly to create password page');
            emit(NavigateToForgotPasswordVerification(
              identifier: identifier,
              type: type == VerificationType.sms ? 'sms' : 'email',
              isExceedsLimit: true, // Skip verification and go directly to create password
            ));
          } else {
            // Normal flow: navigate to verification page to enter code
            print('[PasswordBloc] Navigating to verification page: identifier=$identifier, type=${type == VerificationType.sms ? 'sms' : 'email'}');
            emit(NavigateToForgotPasswordVerification(
              identifier: identifier,
              type: type == VerificationType.sms ? 'sms' : 'email',
              isExceedsLimit: false, // Normal flow - show verification page
            ));
          }
        },
      );
    } catch (e, stackTrace) {
      print('[PasswordBloc] EXCEPTION in _onForgetPasswordPressed: $e');
      print('[PasswordBloc] StackTrace: $stackTrace');
      emit(PasswordError('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  /// Toggle password visibility (like Java's show/hide password)
  Future<void> _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<PasswordState> emit,
  ) async {
    if (state is PasswordInitial) {
      final currentState = state as PasswordInitial;
      emit(currentState.copyWith(
        isPasswordVisible: !currentState.isPasswordVisible,
      ));
    }
  }

  /// Validate password (like Java's password validation)
  bool _validatePassword(String password) {
    if (password.isEmpty) return false;
    
    // Only validate for new users if state is PasswordInitial
    if (state is PasswordInitial) {
      final currentState = state as PasswordInitial;
      // For new users, require stronger password
      if (currentState.isNewUser) {
        return password.length >= 8 &&
            password.contains(RegExp(r'[A-Z]')) && // uppercase
            password.contains(RegExp(r'[a-z]')) && // lowercase
            password.contains(RegExp(r'[0-9]')) && // number
            password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')); // special char
      }
    }
    
    // For existing users, just check minimum length
    return password.length >= 6;
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
