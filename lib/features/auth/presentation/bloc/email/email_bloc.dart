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
    final result = await sendVerificationCode(
      SendVerificationCodeParams(
        request: VerificationRequest(
          identifier: event.email,
          type: VerificationType.email,
        ),
      ),
    );
    result.fold(
      (failure) => emit(EmailError(message: _mapFailureToMessage(failure))),
      (_) => emit(EmailCodeSent(email: event.email)),
    );
  }

  void _onResetState(ResetEmailState event, Emitter<EmailState> emit) {
    emit(EmailInitial());
  }

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
