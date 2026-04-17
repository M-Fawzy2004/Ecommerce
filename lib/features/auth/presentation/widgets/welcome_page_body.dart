import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/utils/assets.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomePageBody extends StatelessWidget {
  const WelcomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Background Image ──────────────────────────────────────────────────
        Positioned.fill(
          child: Image.asset(
            Assets.imagesPngWelcomePage,
            fit: BoxFit.cover,
          ),
        ),

        // ── Gradient Overlay (Optional but professional for legibility) ──────
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
        ),

        // ── Buttons ───────────────────────────────────────────────────────────
        Positioned(
          bottom: 45.h,
          left: 16.w,
          right: 16.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                text: 'auth.login'.tr(),
                onPressed: () {
                  // context.go(AppRouter.login);
                },
              ),
              AppSpacing.h16,
              AppButton(
                text: 'auth.register'.tr(),
                backgroundColor: AppColors.surface,
                textColor: AppColors.primary,
                onPressed: () {
                  // context.go(AppRouter.register);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
