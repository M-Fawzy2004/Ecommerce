import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final bool canPop = context.canPop();
    if (!canPop && onPressed == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: onPressed ??
          () {
            if (canPop) {
              context.pop();
            } else {
              debugPrint("No pages to pop!");
            }
          },
      child: Container(
        height: 45.h,
        width: 45.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.gray,
          border: Border.all(color: AppColors.divider, width: 1.w),
        ),
        child: Center(
          child: Icon(
            IconlyLight.arrow_left_2,
            color: AppColors.textPrimary,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}
