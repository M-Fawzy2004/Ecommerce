import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:ecommerce_app/core/widgets/app_text_field.dart';
import 'package:ecommerce_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_validation_hint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:pinput/pinput.dart';

class ForgotPasswordPageBody extends StatefulWidget {
  const ForgotPasswordPageBody({super.key});

  @override
  State<ForgotPasswordPageBody> createState() => _ForgotPasswordPageBodyState();
}

class _ForgotPasswordPageBodyState extends State<ForgotPasswordPageBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Validation State
  String _email = '';
  String _otp = '';
  String _newPassword = '';
  String _confirmPassword = '';

  bool get _isEmailValid => _email.endsWith('@gmail.com');
  bool get _isPasswordValid =>
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(_newPassword);
  bool get _isConfirmValid => _confirmPassword == _newPassword && _confirmPassword.isNotEmpty;

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleSendEmail() {
    if (!_isEmailValid) {
      AppToast.error(context, message: 'auth.email_error'.tr());
      return;
    }
    context.read<AuthCubit>().sendPasswordResetEmail(_email);
  }

  void _handleVerifyOtp() {
    if (_otp.length < 6) {
      AppToast.error(context, message: 'auth.otp_error'.tr());
      return;
    }
    context.read<AuthCubit>().verifyOtp(_email, _otp, isRecovery: true);
  }

  void _handleResetPassword() {
    if (!_isPasswordValid || !_isConfirmValid) {
      AppToast.error(context, message: 'auth.password_error'.tr());
      return;
    }
    context.read<AuthCubit>().resetPassword(_newPassword);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          AppToast.error(context, message: state.message);
        } else if (state is AuthPasswordResetEmailSent) {
          AppToast.success(context, message: 'auth.otp_sent'.tr());
          _goToNextPage();
        } else if (state is AuthInitial && _currentPage == 1) {
          // Assuming successful verification emits AuthInitial currently
          AppToast.success(context, message: 'auth.verification_success'.tr());
          _goToNextPage();
        } else if (state is AuthPasswordResetSuccess) {
          AppToast.success(context, message: 'auth.password_reset_success'.tr());
          Navigator.pop(context); // Go back to login
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.h12,
          AppBackButton(
            onPressed: () {
              if (_currentPage > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          AppSpacing.h24,
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                _buildEmailStep(),
                _buildOtpStep(),
                _buildNewPasswordStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('auth.forgot_password_title'.tr(), style: AppTextStyles.displayLarge),
          AppSpacing.h8,
          Text('auth.forgot_password_subtitle'.tr(), style: AppTextStyles.bodyLarge),
          AppSpacing.h40,
          AppTextField(
            label: 'auth.email'.tr(),
            hintText: 'auth.email_hint'.tr(),
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(IconlyLight.message),
            onChanged: (val) => setState(() => _email = val),
          ),
          AuthValidationHint(
            label: 'auth.email_error'.tr(),
            isValid: _isEmailValid,
            isVisible: _email.isNotEmpty && !_isEmailValid,
          ),
          AppSpacing.h32,
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return AppButton(
                text: 'auth.send_code'.tr(),
                isLoading: state is AuthLoading,
                onPressed: _handleSendEmail,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 55.h,
      textStyle: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('auth.verify_title'.tr(), style: AppTextStyles.displayLarge),
          AppSpacing.h8,
          Text('auth.verify_subtitle'.tr(), style: AppTextStyles.bodyLarge),
          AppSpacing.h40,
          Center(
            child: Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
              ),
              onChanged: (pin) => _otp = pin,
              onCompleted: (pin) {
                _otp = pin;
                _handleVerifyOtp();
              },
            ),
          ),
          AppSpacing.h32,
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return AppButton(
                text: 'auth.verify_button'.tr(),
                isLoading: state is AuthLoading,
                onPressed: _handleVerifyOtp,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewPasswordStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('auth.reset_password_title'.tr(), style: AppTextStyles.displayLarge),
          AppSpacing.h8,
          Text('auth.reset_password_subtitle'.tr(), style: AppTextStyles.bodyLarge),
          AppSpacing.h40,
          AppTextField(
            label: 'auth.new_password'.tr(),
            hintText: 'auth.password_hint'.tr(),
            isPassword: true,
            prefixIcon: const Icon(IconlyLight.lock),
            onChanged: (val) => setState(() => _newPassword = val),
          ),
          AuthValidationHint(
            label: 'auth.password_error'.tr(),
            isValid: _isPasswordValid,
            isVisible: _newPassword.isNotEmpty && !_isPasswordValid,
          ),
          AppSpacing.h16,
          AppTextField(
            label: 'auth.confirm_new_password'.tr(),
            hintText: 'auth.password_hint'.tr(),
            isPassword: true,
            prefixIcon: const Icon(IconlyLight.lock),
            onChanged: (val) => setState(() => _confirmPassword = val),
          ),
          AuthValidationHint(
            label: 'auth.password_match_error'.tr(),
            isValid: _isConfirmValid,
            isVisible: _confirmPassword.isNotEmpty && !_isConfirmValid,
          ),
          AppSpacing.h32,
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return AppButton(
                text: 'auth.update_password'.tr(),
                isLoading: state is AuthLoading,
                onPressed: _handleResetPassword,
              );
            },
          ),
        ],
      ),
    );
  }
}
