import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/ui/app_radius.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewsSkeleton extends StatelessWidget {
  const ReviewsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 160.w, height: 22.h, color: AppColors.shimmerBase),
        AppSpacing.h16,
        Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColors.shimmerBase,
            borderRadius: AppRadius.r16,
          ),
        ),
        AppSpacing.h24,
        for (int i = 0; i < 2; i++) ...[
          Row(children: [
            Container(
                width: 40.w,
                height: 40.h,
                decoration: const BoxDecoration(
                    color: AppColors.shimmerBase, shape: BoxShape.circle)),
            AppSpacing.w12,
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: 120.w, height: 14.h, color: AppColors.shimmerBase),
              AppSpacing.h8,
              Container(
                  width: 80.w, height: 12.h, color: AppColors.shimmerBase),
            ]),
          ]),
          AppSpacing.h12,
          Container(
              width: double.infinity,
              height: 14.h,
              color: AppColors.shimmerBase),
          AppSpacing.h16,
        ],
      ],
    );
  }
}
