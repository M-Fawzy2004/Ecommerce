import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_radius.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/product_details/domain/entities/product_review_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'star_row.dart';

class RatingBreakdown extends StatelessWidget {
  final ProductRatingSummary summary;

  const RatingBreakdown({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.5),
        borderRadius: AppRadius.r16,
      ),
      child: Row(
        children: [
          // Big score
          Column(
            children: [
              Text(
                summary.averageRating.toStringAsFixed(1),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              StarRow(rating: summary.averageRating.round(), size: 16.sp),
              AppSpacing.h4,
              Text(
                '${summary.totalReviews} ${'product.reviews_count'.tr()}',
                style: AppTextStyles.labelSmall
                    .copyWith(color: AppColors.textHint),
              ),
            ],
          ),
          AppSpacing.w16,
          SizedBox(
            height: 80.h,
            child: const VerticalDivider(width: 1, color: AppColors.divider),
          ),
          AppSpacing.w16,
          // Bar breakdown
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1]
                  .map((star) => _RatingBar(star: star, summary: summary))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int star;
  final ProductRatingSummary summary;

  const _RatingBar({required this.star, required this.summary});

  @override
  Widget build(BuildContext context) {
    final pct = summary.percentageFor(star);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Text('$star', style: AppTextStyles.labelSmall),
          AppSpacing.w4,
          Icon(Icons.star_rounded, size: 12.sp, color: AppColors.star),
          AppSpacing.w8,
          Expanded(
            child: ClipRRect(
              borderRadius: AppRadius.r8,
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 6.h,
                backgroundColor: AppColors.divider,
                color: AppColors.star,
              ),
            ),
          ),
          AppSpacing.w8,
          SizedBox(
            width: 24.w,
            child: Text(
              '${summary.starBreakdown[star] ?? 0}',
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
