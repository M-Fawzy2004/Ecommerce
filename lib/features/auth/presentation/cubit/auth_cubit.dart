import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'package:ecommerce_app/core/cubits/base_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends BaseCubit<AuthState> {
  final SignUpUseCase _signUpUseCase;
  final LoginUseCase _loginUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  final SendPasswordResetEmailUseCase _sendResetEmailUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthCubit({
    required SignUpUseCase signUpUseCase,
    required LoginUseCase loginUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResendOtpUseCase resendOtpUseCase,
    required SendPasswordResetEmailUseCase sendResetEmailUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _signUpUseCase = signUpUseCase,
       _loginUseCase = loginUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _resendOtpUseCase = resendOtpUseCase,
       _sendResetEmailUseCase = sendResetEmailUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _logoutUseCase = logoutUseCase,
       super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold((failure) {
      if (failure.message.toLowerCase().contains('email not confirmed')) {
        emit(AuthUnverified(email));
      } else {
        emit(AuthError(failure.message));
      }
    }, (user) => emit(AuthAuthenticated(user)));
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _signUpUseCase(
      SignUpParams(fullName: fullName, email: email, password: password),
    );
    result.fold((failure) {
      if (failure.message.toLowerCase().contains('already registered')) {
        // If already registered but unverified, prompt them to verify
        // Note: Supabase doesn't easily expose 'isVerified' on user creation failure,
        // but we can route them to verification screen to try OTP or resend.
        emit(AuthUnverified(email));
      } else {
        emit(AuthError(failure.message));
      }
    }, (_) => emit(AuthOtpSent(email)));
  }

  Future<void> verifyOtp(
    String email,
    String token, {
    bool isRecovery = false,
  }) async {
    emit(AuthLoading());
    final result = await _verifyOtpUseCase(
      VerifyOtpParams(email: email, token: token, isRecovery: isRecovery),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()), // Or direct login logic if session persists
    );
  }

  Future<void> resendOtp(String email) async {
    emit(AuthLoading());
    final result = await _resendOtpUseCase(email);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthOtpSent(email)),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());
    final result = await _sendResetEmailUseCase(email);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthPasswordResetEmailSent(email)),
    );
  }

  Future<void> resetPassword(String newPassword) async {
    emit(AuthLoading());
    final result = await _resetPasswordUseCase(newPassword);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthPasswordResetSuccess()),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()), // Return to initial state (unauthenticated)
    );
  }
}
