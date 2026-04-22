import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${"product.reviews".tr()} (3)",
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "product.write_review".tr(),
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.h16,
        _buildAddReviewUI(),
        AppSpacing.h24,
        _buildReviewItem(
          name: 'Ahmed Ali',
          rating: 5,
          comment:
              'Perfect product! The build quality is amazing and it feels very premium.',
          date: '2 days ago',
        ),
        AppSpacing.h16,
        _buildReviewItem(
          name: 'Sarah Mohamed',
          rating: 4,
          comment: 'Very good but the delivery took some time.',
          date: '1 week ago',
        ),
      ],
    );
  }

  Widget _buildAddReviewUI() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.5),
        borderRadius: AppRadius.r16,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("product.rate_product".tr(),
                  style: AppTextStyles.labelMedium),
              AppSpacing.w12,
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(Icons.star_outline_rounded,
                      color: AppColors.star, size: 22.sp),
                ),
              ),
            ],
          ),
          AppSpacing.h16,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.r12,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "product.share_thoughts".tr(),
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.textHint),
                  ),
                ),
                Icon(Icons.send_rounded, color: AppColors.primary, size: 20.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required int rating,
    required String comment,
    required String date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                name[0],
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppSpacing.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: AppColors.star,
                            size: 14.sp,
                          ),
                        ),
                      ),
                      AppSpacing.w8,
                      Text(
                        date,
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSpacing.h12,
        Text(
          comment,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        AppSpacing.h16,
        const Divider(color: AppColors.divider, thickness: 0.5),
      ],
    );
  }
}
