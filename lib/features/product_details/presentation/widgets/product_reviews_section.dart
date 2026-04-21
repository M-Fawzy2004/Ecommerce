import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
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
              'Reviews (3)',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Write a review',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.h16,
        // Add Review Input UI (Placeholder)
        _buildAddReviewUI(),
        AppSpacing.h24,
        // Review List
        _buildReviewItem(
          name: 'Ahmed Ali',
          rating: 5,
          comment: 'Perfect product! The build quality is amazing and it feels very premium.',
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
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('Rate this product:', style: AppTextStyles.bodySmall),
              AppSpacing.w8,
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(Icons.star_border_rounded,
                      color: Colors.amber, size: 20.sp),
                ),
              ),
            ],
          ),
          AppSpacing.h12,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Share your thoughts with other customers...',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
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
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.gray.withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text(name[0], style: TextStyle(color: AppColors.primary, fontSize: 12.sp)),
              ),
              AppSpacing.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                              color: Colors.amber,
                              size: 14.sp,
                            ),
                          ),
                        ),
                        AppSpacing.w8,
                        Text(date, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint, fontSize: 10.sp)),
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
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}
