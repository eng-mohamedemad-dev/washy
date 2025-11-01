import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/errors/failures.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
import 'package:wash_flutter/features/auth/domain/entities/verification_request.dart';
import 'package:wash_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:wash_flutter/features/auth/domain/usecases/send_verification_code.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_state.dart';
import 'package:wash_flutter/features/auth/data/datasources/auth_local_data_source.dart';

/// PasswordBloc - Handles password logic like Java PasswordActivity
class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final SendVerificationCode sendVerificationCode;
  final AuthLocalDataSource authLocalDataSource;
  final AuthRepository authRepository;

  PasswordBloc({
    required this.sendVerificationCode,
    required this.authLocalDataSource,
    required this.authRepository,
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
    print('[PasswordBloc] SetPasswordPressed event received, password length: ${event.password.length}');
    final currentState = state as PasswordInitial;
    
    if (!currentState.isPasswordValid) {
      print('[PasswordBloc] Password not valid, returning');
      emit(currentState.copyWith(
        validationMessage: 'Please enter a valid password',
      ));
      return;
    }

    print('[PasswordBloc] Setting password loading state...');
    emit(const PasswordLoading());

    try {
      // Java: PasswordActivity.callSetPassword() -> WebServiceManager.setPassword(token, password, device)
      // Java: handlePasswordUpdated() checks for PASSWORD_UPDATED, then goes to TermsAndConditionsPage
      print('[PasswordBloc] Calling createPassword API...');
      final result = await authRepository.createPassword(event.password);
      
      result.fold(
        (failure) {
          print('[PasswordBloc] Set password failed: ${failure.message}');
          emit(PasswordError(failure.message));
          
          // Restore to initial state to allow retry
          if (!isClosed) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!isClosed) {
                emit(PasswordInitial(
                  user: event.user,
                  isNewUser: true,
                  password: '', // Clear password to force user to retype
                  isPasswordValid: false,
                  validationMessage: null,
                ));
              }
            });
          }
        },
        (updatedUser) {
          print('[PasswordBloc] Password set successfully');
          // Java: handlePasswordUpdated() -> goToTermsAndConditionsPage()
          // Java: PasswordActivity.goToTermsAndConditionsPage() navigates to TermsAndConditionsActivity
          emit(PasswordSetSuccess(user: updatedUser));
          
          // Navigate to TermsAndConditions (matching Java flow)
          if (!isClosed) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!isClosed) {
                emit(NavigateToTermsAndConditions(user: updatedUser));
              }
            });
          }
        },
      );
    } catch (e) {
      print('[PasswordBloc] EXCEPTION in _onSetPasswordPressed: $e');
      emit(PasswordError('حدث خطأ غير متوقع: ${e.toString()}'));
      
      // Restore to initial state
      if (!isClosed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) {
            emit(PasswordInitial(
              user: event.user,
              isNewUser: true,
              password: '',
              isPasswordValid: false,
              validationMessage: null,
            ));
          }
        });
      }
    }
  }

  /// Handle login with password for existing users (like Java's login)
  /// Java: callLoginApi() calls WebServiceManager.login(token, password, device)
  Future<void> _onLoginWithPasswordPressed(
    LoginWithPasswordPressed event,
    Emitter<PasswordState> emit,
  ) async {
    try {
      print('[PasswordBloc] LoginWithPasswordPressed event received, password length: ${event.password.length}');
      print('[PasswordBloc] Current state type: ${state.runtimeType}');
      
      // Get PasswordInitial state - if current state is not PasswordInitial, restore it from event.user
      PasswordInitial currentState;
      if (state is PasswordInitial) {
        currentState = state as PasswordInitial;
        print('[PasswordBloc] Current state password: ${currentState.password.length} chars');
      } else {
        // If we're in an error state, restore to initial state with the user from event
        print('[PasswordBloc] Restoring from ${state.runtimeType} to PasswordInitial state');
        currentState = PasswordInitial(
          user: event.user,
          isNewUser: false,
          password: event.password,
          isPasswordValid: event.password.length >= 6,
        );
      }
      
      if (event.password.isEmpty) {
        print('[PasswordBloc] Password is empty, returning');
        emit(currentState.copyWith(
          validationMessage: 'من فضلك أدخل كلمة السر',
        ));
        return;
      }

      print('[PasswordBloc] Setting password loading state...');
      emit(const PasswordLoading());

      // Java: WebServiceManager.login(SessionStateManager.getInstance().getToken(this), password, device)
      // Get token from user or SharedPreferences (like Java's SessionStateManager)
      var token = event.user.token;
      
      // If token is empty, try to get it from SharedPreferences (like Java's SessionStateManager)
      if (token == null || token.isEmpty) {
        print('[PasswordBloc] Token not found in user object, trying SharedPreferences...');
        try {
          final lastUser = await authLocalDataSource.getLastUser();
          if (lastUser != null && lastUser.token != null && lastUser.token!.isNotEmpty) {
            token = lastUser.token;
            print('[PasswordBloc] Found token in SharedPreferences: ${token!.substring(0, token.length > 10 ? 10 : token.length)}...');
          }
        } catch (e) {
          print('[PasswordBloc] Error getting token from SharedPreferences: $e');
        }
      }
      
      print('[PasswordBloc] User token: ${token != null && token.isNotEmpty ? "${token.substring(0, token.length > 10 ? 10 : token.length)}..." : "null/empty"}');
      
      if (token == null || token.isEmpty) {
        print('[PasswordBloc] ERROR: No token found for login');
        emit(PasswordError('خطأ في المصادقة: لم يتم العثور على رمز التحقق'));
        emit(currentState.copyWith(validationMessage: 'خطأ في المصادقة'));
        return;
      }

      print('[PasswordBloc] Calling loginWithPassword API with token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...');
      print('[PasswordBloc] authRepository: ${authRepository.runtimeType}');
      
      final result = await authRepository.loginWithPassword(token, event.password);
      
      print('[PasswordBloc] API call completed, result: ${result.isRight() ? "Success" : "Failure"}');

      result.fold(
        (failure) {
          print('[PasswordBloc] Login failed: ${failure.runtimeType}, message: ${failure.message}');
          final errorMessage = _mapFailureToMessage(failure);
          print('[PasswordBloc] Mapped error message: $errorMessage');
          
          // Emit error state first to trigger dialog close and show SnackBar
          emit(PasswordError(errorMessage));
          
          // Restore to initial state after a short delay to allow retry
          // This ensures dialog is closed and SnackBar is shown before clearing password
          Future.delayed(const Duration(milliseconds: 400), () {
            // Check if bloc is still active before emitting
            if (!isClosed) {
              try {
                emit(PasswordInitial(
                  user: event.user,
                  isNewUser: false,
                  password: '', // Clear password to force user to retype
                  isPasswordValid: false,
                  validationMessage: null, // Clear validation message - error will show in SnackBar only
                ));
              } catch (e) {
                print('[PasswordBloc] ⚠️ Error emitting PasswordInitial: $e');
              }
            } else {
              print('[PasswordBloc] ⚠️ Bloc is closed, skipping PasswordInitial emit');
            }
          });
        },
        (loggedInUser) {
          print('[PasswordBloc] Login successful! User: ${loggedInUser.email ?? loggedInUser.phoneNumber}');
          emit(PasswordLoginSuccess(user: loggedInUser));
          // Navigate to home after short delay (like Java)
          Future.delayed(const Duration(milliseconds: 500), () {
            // Check if bloc is still active before emitting
            if (!isClosed) {
              try {
                emit(NavigateToHome(user: loggedInUser));
              } catch (e) {
                print('[PasswordBloc] ⚠️ Error emitting NavigateToHome: $e');
              }
            } else {
              print('[PasswordBloc] ⚠️ Bloc is closed, skipping NavigateToHome emit');
            }
          });
        },
      );
    } catch (e, stackTrace) {
      print('[PasswordBloc] EXCEPTION in _onLoginWithPasswordPressed: $e');
      print('[PasswordBloc] StackTrace: $stackTrace');
      final currentState = state is PasswordInitial ? state as PasswordInitial : null;
      if (currentState != null) {
        emit(PasswordError('حدث خطأ غير متوقع: ${e.toString()}'));
        emit(currentState.copyWith(validationMessage: 'حدث خطأ غير متوقع'));
      } else {
        emit(PasswordError('حدث خطأ غير متوقع: ${e.toString()}'));
      }
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
          
          // If exceeds_limit, no code was actually sent - show error message in same page
          if (status.toLowerCase() == 'exceeds_limit') {
            print('[PasswordBloc] ⚠️ exceeds_limit - no code was sent, showing error message');
            // Show error message in same page instead of navigating
            emit(PasswordError('لقد استنفدت عدد مرات إرسال الأكواد، يرجى المحاولة غداً'));
          } else {
            // Normal flow: code was sent, navigate to verification page to enter code
            print('[PasswordBloc] ✅ Code was sent, navigating to verification page');
            print('[PasswordBloc] Navigating to verification page: identifier=$identifier, type=${type == VerificationType.sms ? 'sms' : 'email'}');
            emit(NavigateToForgotPasswordVerification(
              identifier: identifier,
              type: type == VerificationType.sms ? 'sms' : 'email',
              isExceedsLimit: false, // Show verification page to enter code
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
  /// Java: NUMBER_OF_MINIMUM_PASSWORD_DIGITS = 6 for all cases (new users and existing users)
  /// Java: PasswordActivity.afterTextChanged() checks: editable.toString().length() >= NUMBER_OF_MINIMUM_PASSWORD_DIGITS
  bool _validatePassword(String password) {
    if (password.isEmpty) return false;
    
    // Java requires minimum 6 characters for all cases (new users and existing users)
    // PasswordActivity: NUMBER_OF_MINIMUM_PASSWORD_DIGITS = 6
    // CreatePasswordActivity: newPassword.length() < 6 returns false
    return password.length >= 6;
  }

  /// Map failures to user-friendly messages
  String _mapFailureToMessage(Failure failure) {
    print('[PasswordBloc] _mapFailureToMessage: failure type = ${failure.runtimeType}, message = ${failure.message}');
    
    if (failure is ServerFailure) {
      // Return the message as-is (it should already be in Arabic from the API)
      print('[PasswordBloc] _mapFailureToMessage: ServerFailure detected, returning: ${failure.message}');
      return failure.message;
    } else if (failure is CacheFailure) {
      print('[PasswordBloc] _mapFailureToMessage: CacheFailure detected, returning: ${failure.message}');
      return failure.message;
    } else if (failure is NetworkFailure) {
      print('[PasswordBloc] _mapFailureToMessage: NetworkFailure detected, returning: ${failure.message}');
      return failure.message;
    } else {
      print('[PasswordBloc] _mapFailureToMessage: Unknown failure type, returning default message');
      return 'حدث خطأ غير متوقع';
    }
  }
}
