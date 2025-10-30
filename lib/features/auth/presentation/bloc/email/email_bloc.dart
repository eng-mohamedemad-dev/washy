import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/features/auth/domain/usecases/check_email.dart';
import 'package:wash_flutter/features/auth/domain/usecases/send_verification_code.dart';
import 'package:wash_flutter/features/auth/domain/entities/verification_request.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_state.dart';

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  final CheckEmail checkEmail;
  final SendVerificationCode sendVerificationCode;

  EmailBloc({
    required this.checkEmail,
    required this.sendVerificationCode,
  }) : super(EmailInitial()) {
    on<CheckEmailEvent>(_onCheckEmail);
    on<SendEmailCodeEvent>(_onSendEmailCode);
    on<ResetEmailState>(_onResetState);
  }

  Future<void> _onCheckEmail(
    CheckEmailEvent event,
    Emitter<EmailState> emit,
  ) async {
    emit(EmailLoading());
    final result = await checkEmail(CheckEmailParams(email: event.email));
    result.fold(
      (failure) => emit(EmailError(message: _mapFailureToMessage(failure))),
      (user) => emit(EmailChecked(user: user)),
    );
  }

  Future<void> _onSendEmailCode(
    SendEmailCodeEvent event,
    Emitter<EmailState> emit,
  ) async {
    emit(EmailLoading());
    print('[EmailBloc] Sending email verification code for: ${event.email}');
    final result = await sendVerificationCode(
      SendVerificationCodeParams(
        request: VerificationRequest(
          identifier: event.email,
          type: VerificationType.email,
        ),
      ),
    );
    result.fold(
      (failure) {
        print('[EmailBloc] Error occurred: ${failure.runtimeType}');
        print('[EmailBloc] Failure object: $failure');
        print('[EmailBloc] Failure message property: ${failure.message}');
        final errorMessage = _mapFailureToMessage(failure);
        print('[EmailBloc] Final error message after mapping: "$errorMessage"');
        print('[EmailBloc] Emitting EmailError with message: "$errorMessage"');
        emit(EmailError(message: errorMessage));
      },
      (status) {
        // Check if email code was sent successfully (like Java: SMS_SENT_SUCCESS.equals(status))
        // Note: Java uses same constant for both SMS and email
        print('[EmailBloc] Status received: $status');
        if (status.toLowerCase() == 'sms_sent' ||
            status.toLowerCase() == 'email_sent') {
          print('[EmailBloc] Code sent successfully, emitting EmailCodeSent');
          emit(EmailCodeSent(email: event.email));
        } else if (status.toLowerCase() == 'exceeds_limit' || 
                   status.toLowerCase() == 'verified_customer' ||
                   status.toLowerCase() == 'enter_password') {
          // When exceeds_limit or user is already verified, navigate to password page (like Java)
          print('[EmailBloc] User status: $status, navigating to password page');
          emit(NavigateToPassword(email: event.email));
        } else {
          print('[EmailBloc] Invalid status: $status, emitting error');
          emit(EmailError(message: 'فشل إرسال كود التحقق: $status'));
        }
      },
    );
  }

  void _onResetState(ResetEmailState event, Emitter<EmailState> emit) {
    emit(EmailInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      print('[EmailBloc] Mapping failure message: "${failure.message}"');
      print('[EmailBloc] Message length: ${failure.message.length}');
      print('[EmailBloc] Message is empty: ${failure.message.isEmpty}');
      
      // Just return the message as-is since it's already in Arabic from the API
      // No need to check for specific content - the API already provides the correct message
      if (failure.message.isEmpty) {
        print('[EmailBloc] Empty message, using default');
        return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى';
      }
      
      print('[EmailBloc] Returning message as-is: "${failure.message}"');
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else {
      return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى';
    }
  }
}
