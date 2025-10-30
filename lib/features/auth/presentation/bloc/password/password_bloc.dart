import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/core/usecases/usecase.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
import 'package:wash_flutter/features/auth/domain/entities/verification_request.dart';
import 'package:wash_flutter/features/auth/domain/usecases/send_verification_code.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_state.dart';

/// PasswordBloc - Handles password logic like Java PasswordActivity
class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final SendVerificationCode sendVerificationCode;
  // TODO: Add more use cases for password operations

  PasswordBloc({
    required this.sendVerificationCode,
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
    final currentState = state as PasswordInitial;
    
    // Validate password (like Java's validation)
    final isValid = _validatePassword(event.password);
    
    String? validationMessage;
    if (event.password.isNotEmpty && !isValid) {
      if (currentState.isNewUser) {
        validationMessage = 'Password must be at least 8 characters with uppercase, lowercase, number and special character';
      } else {
        validationMessage = 'Invalid password';
      }
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
  Future<void> _onForgetPasswordPressed(
    ForgetPasswordPressed event,
    Emitter<PasswordState> emit,
  ) async {
    emit(const PasswordLoading());

    // Determine identifier (phone or email)
    String identifier = '';
    VerificationType type = VerificationType.email;
    
    if (event.user.phoneNumber != null && event.user.phoneNumber!.isNotEmpty) {
      identifier = event.user.phoneNumber!;
      type = VerificationType.sms;
    } else if (event.user.email != null && event.user.email!.isNotEmpty) {
      identifier = event.user.email!;
      type = VerificationType.email;
    } else {
      emit(const PasswordError('No phone number or email found for password reset'));
      return;
    }

    final verificationRequest = VerificationRequest(
      identifier: identifier,
      type: type,
      isFromForgetPassword: true,
    );

    final result = await sendVerificationCode(
      SendVerificationCodeParams(request: verificationRequest),
    );

    result.fold(
      (failure) => emit(PasswordError(_mapFailureToMessage(failure))),
      (_) => emit(NavigateToForgotPasswordVerification(
        identifier: identifier,
        type: type == VerificationType.sms ? 'sms' : 'email',
      )),
    );
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
    
    // For new users, require stronger password
    if ((state as PasswordInitial).isNewUser) {
      return password.length >= 8 &&
          password.contains(RegExp(r'[A-Z]')) && // uppercase
          password.contains(RegExp(r'[a-z]')) && // lowercase
          password.contains(RegExp(r'[0-9]')) && // number
          password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')); // special char
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
