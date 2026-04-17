import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:ecommerce_app/core/widgets/app_text_field.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_social_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class SignupPageBody extends StatelessWidget {
  const SignupPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.h12,
          const AppBackButton(),
          AppSpacing.h24,
          Text(
            'auth.signup_title'.tr(),
            style: AppTextStyles.displayLarge,
          ),
          Text(
            'auth.signup_subtitle'.tr(),
            style: AppTextStyles.bodyLarge,
          ),
          AppSpacing.h32,
          AppTextField(
            label: 'auth.username'.tr(),
            hintText: 'auth.username_hint'.tr(),
            prefixIcon: const Icon(IconlyLight.profile),
          ),
          AppSpacing.h16,
          AppTextField(
            label: 'auth.email'.tr(),
            hintText: 'auth.email_hint'.tr(),
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(IconlyLight.message),
          ),
          AppSpacing.h16,
          AppTextField(
            label: 'auth.password'.tr(),
            hintText: 'auth.password_hint'.tr(),
            isPassword: true,
            prefixIcon: const Icon(IconlyLight.lock),
            suffixIcon: const Icon(IconlyLight.hide),
          ),
          AppSpacing.h16,
          AppTextField(
            label: 'auth.confirm_password'.tr(),
            hintText: 'auth.password_hint'.tr(), // Reuse password hint
            isPassword: true,
            prefixIcon: const Icon(IconlyLight.lock),
            suffixIcon: const Icon(IconlyLight.hide),
          ),
          AppSpacing.h24,
          AppButton(
            text: 'auth.register'.tr(),
            onPressed: () {},
          ),
          AppSpacing.h20,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'auth.already_have_account'.tr(),
                style: AppTextStyles.bodyMedium,
              ),
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
