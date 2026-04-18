import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:ecommerce_app/core/widgets/app_text_field.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_social_buttons.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_validation_hint.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class SignupPageBody extends StatefulWidget {
  const SignupPageBody({super.key});

  @override
  State<SignupPageBody> createState() => _SignupPageBodyState();
}

class _SignupPageBodyState extends State<SignupPageBody> {
  bool _isLoading = false;
  
  // Validation State
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  
  bool get _isFullNameValid => _fullName.trim().split(' ').length >= 2 && _fullName.trim().length >= 4;
  bool get _isEmailValid => _email.endsWith('@gmail.com');
  bool get _isPasswordValid => 
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(_password);
  bool get _isConfirmValid => _confirmPassword == _password && _confirmPassword.isNotEmpty;

  void _handleSignup() async {
    if (!_isFullNameValid || !_isEmailValid || !_isPasswordValid || !_isConfirmValid) {
      AppToast.error(context, message: 'auth.full_name_error'.tr()); // Generic error for now
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      AppToast.success(context, message: 'auth.otp_sent'.tr());
      context.push(AppRouter.verification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.h12,
          const AppBackButton(),
          AppSpacing.h24,
          Text('auth.signup_title'.tr(), style: AppTextStyles.displayLarge),
          Text('auth.signup_subtitle'.tr(), style: AppTextStyles.bodyLarge),
          AppSpacing.h32,
          AppTextField(
            label: 'auth.username'.tr(),
            hintText: 'auth.username_hint'.tr(),
            prefixIcon: const Icon(IconlyLight.profile),
            onChanged: (val) => setState(() => _fullName = val),
          ),
          AuthValidationHint(
            label: 'auth.full_name_error'.tr(),
            isValid: _isFullNameValid,
            isVisible: _fullName.isNotEmpty && !_isFullNameValid,
          ),
          AppSpacing.h16,
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
          AppSpacing.h16,
          AppTextField(
            label: 'auth.password'.tr(),
            hintText: 'auth.password_hint'.tr(),
            isPassword: true,
            prefixIcon: const Icon(IconlyLight.lock),
            onChanged: (val) => setState(() => _password = val),
          ),
          AuthValidationHint(
            label: 'auth.password_error'.tr(),
            isValid: _isPasswordValid,
            isVisible: _password.isNotEmpty && !_isPasswordValid,
          ),
          AppSpacing.h16,
          AppTextField(
            label: 'auth.confirm_password'.tr(),
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
          AppSpacing.h24,
          AppButton(
            text: 'auth.register'.tr(),
            isLoading: _isLoading,
            onPressed: _handleSignup,
          ),
          AppSpacing.h20,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('auth.already_have_account'.tr(), style: AppTextStyles.bodyMedium),
              AppSpacing.w4,
              GestureDetector(
                onTap: () => context.push(AppRouter.login),
                child: Text(
                  'auth.login'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.h24,
          AuthSocialButtons(
            onGoogleTap: () {},
            onAppleTap: () {},
          ),
        ],
      ),
    );
  }
}
