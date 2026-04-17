import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:ecommerce_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
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
  bool _isLoading = false;

  void _nextPage() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Handle password update completion
      if (mounted) {
        AppToast.success(context, message: 'auth.password_reset_success'.tr());
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }

  Widget _buildEmailStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('auth.forgot_password_title'.tr(),
              style: AppTextStyles.displayLarge),
          AppSpacing.h8,
          Text('auth.forgot_password_subtitle'.tr(),
              style: AppTextStyles.bodyLarge),
          AppSpacing.h40,
          AppTextField(
            label: 'auth.email'.tr(),
            hintText: 'auth.email_hint'.tr(),
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(IconlyLight.message),
          ),
          AppSpacing.h32,
          AppButton(
            text: 'auth.send_code'.tr(),
            isLoading: _isLoading,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 55.h,
      textStyle:
          AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold),
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
              onCompleted: (pin) => _nextPage(),
            ),
          ),
          AppSpacing.h32,
          AppButton(
            text: 'auth.verify_button'.tr(),
            isLoading: _isLoading,
            onPressed: _nextPage,
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
          Text('auth.reset_password_title'.tr(),
              style: AppTextStyles.displayLarge),
          AppSpacing.h8,
          Text('auth.reset_password_subtitle'.tr(),
              style: AppTextStyles.bodyLarge),
          AppSpacing.h40,
          AppTextField(
            label: 'auth.new_password'.tr(),
            hintText: 'auth.password_hint'.tr(),
            isPassword: true,
            prefixIcon: const Icon(IconlyLight.lock),
          ),
          AppSpacing.h24,
          AppTextField(
            label: 'auth.confirm_new_password'.tr(),
            hintText: 'auth.password_hint'.tr(),
            isPassword: true,
            prefixIcon: const Icon(IconlyLight.lock),
          ),
          AppSpacing.h32,
          AppButton(
            text: 'auth.update_password'.tr(),
            isLoading: _isLoading,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }
}
