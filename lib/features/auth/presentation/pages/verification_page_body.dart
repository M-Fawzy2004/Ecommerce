import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class VerificationPageBody extends StatefulWidget {
  const VerificationPageBody({super.key});

  @override
  State<VerificationPageBody> createState() => _VerificationPageBodyState();
}

class _VerificationPageBodyState extends State<VerificationPageBody> {
  late Timer _timer;
  int _start = 60;
  bool _canResend = false;

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

    return SingleChildScrollView(
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
              onCompleted: (pin) => debugPrint(pin),
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
          AppButton(
            text: 'auth.verify_button'.tr(),
            onPressed: () {
              // Handle verification
            },
          ),
        ],
      ),
    );
  }
}
