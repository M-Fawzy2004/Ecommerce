import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthValidationHint extends StatelessWidget {
  final String label;
  final bool isValid;
  final bool isVisible;

  const AuthValidationHint({
    super.key,
    required this.label,
    required this.isValid,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: isVisible
          ? Padding(
              key: ValueKey(isValid),
              padding: EdgeInsets.only(top: 8.h, left: 4.w),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 16.r,
                    height: 16.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isValid
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                    ),
                    child: Icon(
                      isValid ? Icons.check_rounded : Icons.priority_high_rounded,
                      size: 10.r,
                      color: isValid ? AppColors.primary : AppColors.error,
                    ),
                  ),
                  AppSpacing.w8,
                  Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isValid ? AppColors.primary : AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
