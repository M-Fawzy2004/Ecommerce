import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:ecommerce_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class VerificationPageBody extends StatefulWidget {
  final String email;

  const VerificationPageBody({super.key, required this.email});

  @override
  State<VerificationPageBody> createState() => _VerificationPageBodyState();
}

class _VerificationPageBodyState extends State<VerificationPageBody> {
  late Timer _timer;
  int _start = 60;
  bool _canResend = false;
  String _currentPin = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _start = 60;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer.cancel();
          _canResend = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _handleVerify() {
    if (_currentPin.length < 6) {
      AppToast.error(context, message: 'auth.otp_error'.tr());
      return;
    }
    context.read<AuthCubit>().verifyOtp(widget.email, _currentPin);
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 55.h,
      textStyle: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
    );

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          AppToast.error(context, message: state.message);
        } else if (state is AuthInitial || state is AuthAuthenticated) {
          // Verification success usually sets state to Authenticated or Initial
          // Supabase automatically logs in the user after verification.
          AppToast.success(context, message: 'auth.verification_success'.tr());
          // Navigate to Home or Login based on your app's flow
          context.go(AppRouter.home);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.h12,
            const AppBackButton(),
            AppSpacing.h24,
            Text(
              'auth.verify_title'.tr(),
              style: AppTextStyles.displayLarge,
            ),
            AppSpacing.h8,
            Text(
              'auth.verify_subtitle'.tr(),
              style: AppTextStyles.bodyLarge,
            ),
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
                separatorBuilder: (index) => SizedBox(width: 8.w),
                onChanged: (pin) => _currentPin = pin,
                onCompleted: (pin) {
                  _currentPin = pin;
                  _handleVerify();
                },
              ),
            ),
            AppSpacing.h32,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'auth.resend_code'.tr(),
                  style: AppTextStyles.bodyMedium,
                ),
                _canResend
                    ? GestureDetector(
                        onTap: () {
                          _startTimer();
                          context.read<AuthCubit>().resendOtp(widget.email);
                          AppToast.success(context,
                              message: 'auth.otp_resent'.tr());
                        },
                        child: Text(
                          'auth.resend'.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Text(
                        '00:$_start ${'auth.timer_seconds'.tr()}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
            AppSpacing.h40,
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return AppButton(
                  text: 'auth.verify_button'.tr(),
                  isLoading: state is AuthLoading,
                  onPressed: _handleVerify,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
