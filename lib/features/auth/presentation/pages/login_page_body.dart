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

class LoginPageBody extends StatelessWidget {
  const LoginPageBody({super.key});

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
            'auth.login_title'.tr(),
            style: AppTextStyles.displayLarge,
          ),
          Text(
            'auth.login_subtitle'.tr(),
            style: AppTextStyles.bodyLarge,
          ),
          AppSpacing.h40,
          AppTextField(
            label: 'auth.email'.tr(),
            hintText: 'auth.email_hint'.tr(),
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(IconlyLight.message),
          ),
          AppSpacing.h24,
          AppTextField(
            label: 'auth.password'.tr(),
            hintText: 'auth.password_hint'.tr(),
            isPassword: true,
            prefixIcon: const Icon(IconlyLight.lock),
            suffixIcon: const Icon(IconlyLight.hide),
          ),
          AppSpacing.h4,
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'auth.forgot_password'.tr(),
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AppSpacing.h24,
          AppButton(
            text: 'auth.login'.tr(),
            onPressed: () {},
          ),
          AppSpacing.h4,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'auth.dont_have_account'.tr(),
                style: AppTextStyles.bodyMedium,
              ),
              TextButton(
                onPressed: () => context.push(AppRouter.signup),
                child: Text(
                  'auth.register'.tr(),
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
