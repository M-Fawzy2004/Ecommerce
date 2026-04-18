import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:ecommerce_app/core/widgets/app_text_field.dart';
import 'package:ecommerce_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_social_buttons.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_validation_hint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({super.key});

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  String _email = '';
  String _password = '';

  bool get _isEmailValid => _email.endsWith('@gmail.com');
  bool get _isPasswordValid =>
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(_password);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          AppToast.error(context, message: state.message);
        } else if (state is AuthAuthenticated) {
          AppToast.success(context, message: 'auth.login_success'.tr());
          // context.go(AppRouter.home); // Navigate to home
        } else if (state is AuthUnverified) {
          AppToast.error(context, message: 'auth.verify_first_error'.tr());
          context.push(AppRouter.verification, extra: state.email);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.h12,
            const AppBackButton(),
            AppSpacing.h24,
            Text('auth.login_title'.tr(), style: AppTextStyles.displayLarge),
            Text('auth.login_subtitle'.tr(), style: AppTextStyles.bodyLarge),
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
            AppSpacing.h20,
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
            AppSpacing.h4,
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => context.push(AppRouter.forgotPassword),
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
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return AppButton(
                  text: 'auth.login'.tr(),
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    if (!_isEmailValid || !_isPasswordValid) {
                      AppToast.error(context, message: 'auth.email_error'.tr());
                      return;
                    }
                    context.read<AuthCubit>().login(_email, _password);
                  },
                );
              },
            ),
            AppSpacing.h4,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('auth.dont_have_account'.tr(), style: AppTextStyles.bodyMedium),
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
      ),
    );
  }
}
