import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart' as user;
import 'package:wash_flutter/features/auth/domain/entities/verification_request.dart';
import 'package:wash_flutter/features/auth/domain/usecases/send_verification_code.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/verification/verification_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/verification/verification_state.dart';

/// VerificationBloc - Handles verification logic like Java VerificationActivity
class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final SendVerificationCode sendVerificationCode;
  // TODO: Add verify code use cases

  Timer? _timer;

  VerificationBloc({
    required this.sendVerificationCode,
    required String identifier,
    required bool isPhone,
    bool isFromForgetPassword = false,
  }) : super(VerificationInitial(
          identifier: identifier,
          isPhone: isPhone,
          isFromForgetPassword: isFromForgetPassword,
        )) {
    on<VerificationCodeChanged>(_onCodeChanged);
    on<VerifyCodePressed>(_onVerifyCodePressed);
    on<ResendCodePressed>(_onResendCodePressed);
    on<TimerTick>(_onTimerTick);
    on<StartTimer>(_onStartTimer);
    on<ClearCode>(_onClearCode);

    // Start timer automatically like Java
    add(StartTimer());
  }

  /// Handle code changes (like Java's PIN input)
  Future<void> _onCodeChanged(
    VerificationCodeChanged event,
    Emitter<VerificationState> emit,
  ) async {
    final currentState = state as VerificationInitial;

    // Update code at specific position
    String newCode = currentState.code;
    if (event.position < 4 && event.position >= 0) {
      if (newCode.length <= event.position) {
        newCode = newCode.padRight(event.position, ' ') +
            event.code.substring(event.code.length - 1);
      } else {
        newCode = newCode.substring(0, event.position) +
            event.code.substring(event.code.length - 1) +
            newCode.substring(event.position + 1);
      }
    } else {
      newCode = event.code;
    }

    // Clean code (remove spaces and limit to 4 digits)
    newCode = newCode.replaceAll(' ', '').replaceAll(RegExp(r'[^0-9]'), '');
    if (newCode.length > 4) {
      newCode = newCode.substring(0, 4);
    }

    final isComplete = newCode.length == 4;

    emit(currentState.copyWith(
      code: newCode,
      isCodeComplete: isComplete,
      validationMessage: null, // Clear validation when typing
    ));

    // Don't auto-verify - wait for user to complete entry
    // In Java, verification happens manually when user clicks continue button
    // or when they finish typing (handled by PinView)
  }

  /// Handle verify code (like Java's verify code)
  Future<void> _onVerifyCodePressed(
    VerifyCodePressed event,
    Emitter<VerificationState> emit,
  ) async {
    final currentState = state as VerificationInitial;

    if (event.code.length != 4) {
      emit(currentState.copyWith(
        validationMessage: 'Please enter complete 4-digit code',
      ));
      return;
    }

    emit(const VerificationLoading());

    // TODO: Call verify code API based on type
    // For now, simulate verification
    await Future.delayed(const Duration(seconds: 2));

    if (event.isFromForgetPassword) {
      // For forget password flow
      emit(ForgotPasswordVerificationSuccess(identifier: event.identifier));

      // Navigate to password reset after delay
      await Future.delayed(const Duration(milliseconds: 500));
      emit(NavigateToPasswordReset(identifier: event.identifier));
    } else {
      // For regular verification (sign up/login) - مطابق لـ Java handleVerifiedCustomerCode()
      // TODO: Get actual user from API response
      final mockUser = user.User(
        id: '123',
        name: 'Test User',
        email: event.isPhone ? null : event.identifier,
        phoneNumber: event.isPhone ? event.identifier : null,
        accountStatus: user.AccountStatus.verifiedCustomer, // بعد التحقق يصبح verified
        loginType: event.isPhone ? user.LoginType.phone : user.LoginType.email,
      );

      emit(VerificationSuccess(user: mockUser));

      // Navigate to password page like Java (PasswordActivity)
      await Future.delayed(const Duration(milliseconds: 500));
      emit(NavigateToPassword(user: mockUser));
    }
  }

  /// Handle resend code (like Java's resend code)
  Future<void> _onResendCodePressed(
    ResendCodePressed event,
    Emitter<VerificationState> emit,
  ) async {
    emit(const VerificationLoading());

    final verificationRequest = VerificationRequest(
      identifier: event.identifier,
      type: event.isPhone ? VerificationType.sms : VerificationType.email,
      isFromForgetPassword: event.isFromForgetPassword,
    );

    final result = await sendVerificationCode(
      SendVerificationCodeParams(request: verificationRequest),
    );

    result.fold(
      (failure) => emit(VerificationError(_mapFailureToMessage(failure))),
      (status) {
        // Check if code was sent successfully (like Java)
        if (status.toLowerCase() == 'sms_sent' ||
            status.toLowerCase() == 'email_sent') {
          // Prepare next initial state BEFORE emitting transient success state
          final nextInitial = VerificationInitial(
            identifier: event.identifier,
            isPhone: event.isPhone,
            isFromForgetPassword: event.isFromForgetPassword,
          );

          emit(nextInitial.copyWith(
            code: '',
            isCodeComplete: false,
            remainingSeconds: 60,
            canResend: false,
            validationMessage: null,
          ));

          // Restart timer
          add(StartTimer());

          // Emit success notification state at the end (UI may show a toast/snackbar)
          emit(const CodeSentSuccess());
        } else if (status.toLowerCase() == 'exceeds_limit') {
          // في حالة تجاوز الحد، انتقل مباشرة لصفحة كلمة المرور كما في تطبيق الجافا
          final mockUser = user.User(
            id: 'temp',
            name: '',
            email: event.isPhone ? null : event.identifier,
            phoneNumber: event.isPhone ? event.identifier : null,
            accountStatus: user.AccountStatus.verifiedCustomer,
            loginType: event.isPhone ? user.LoginType.phone : user.LoginType.email,
          );

          emit(NavigateToPassword(user: mockUser));
        } else {
          emit(VerificationError('فشل إرسال كود التحقق: $status'));
        }
      },
    );
  }

  /// Handle timer tick (like Java's countdown)
  Future<void> _onTimerTick(
    TimerTick event,
    Emitter<VerificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! VerificationInitial) {
      return; // Ignore ticks while in transient states (e.g., CodeSentSuccess)
    }

    emit(currentState.copyWith(
      remainingSeconds: event.remainingSeconds,
      canResend: event.remainingSeconds <= 0,
    ));

    if (event.remainingSeconds <= 0) {
      _timer?.cancel();
    }
  }

  /// Start timer (like Java's timer start)
  Future<void> _onStartTimer(
    StartTimer event,
    Emitter<VerificationState> emit,
  ) async {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state;
      if (currentState is VerificationInitial) {
        final newSeconds = currentState.remainingSeconds - 1;
        add(TimerTick(newSeconds));

        if (newSeconds <= 0) {
          timer.cancel();
        }
      }
    });
  }

  /// Clear code
  Future<void> _onClearCode(
    ClearCode event,
    Emitter<VerificationState> emit,
  ) async {
    final currentState = state as VerificationInitial;

    emit(currentState.copyWith(
      code: '',
      isCodeComplete: false,
      validationMessage: null,
    ));
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

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
