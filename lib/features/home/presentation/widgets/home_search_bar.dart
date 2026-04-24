import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const HomeSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(AppRouter.search),
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        height: 45.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.gray,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            Icon(
              IconlyLight.search,
              color: AppColors.textHint,
              size: 22.sp,
            ),
            AppSpacing.w12,
            Text(
              'home.search_products'.tr(), 
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
