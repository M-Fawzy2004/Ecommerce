import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/app_radius.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/reviews_cubit.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/reviews_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductEntity product;
  final int quantity;
  final int maxQuantity;
  final Function(int) onQuantityChanged;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.quantity,
    required this.maxQuantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and Quantity Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.h4,
                  _buildRatingAndStock(context),
                ],
              ),
            ),
            AppSpacing.w16,
            _buildQuantitySelector(),
          ],
        ),
        AppSpacing.h12,
        // Price Row
        _buildPriceSection(),
      ],
    );
  }

  Widget _buildRatingAndStock(BuildContext context) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        double rating = product.rating ?? 0.0;
        int reviewCount = product.reviewCount ?? 0;

        if (state is ReviewsLoaded) {
          rating = state.summary.averageRating;
          reviewCount = state.summary.totalReviews;
        }

        return Row(
          children: [
            Icon(Icons.star_rounded, color: AppColors.star, size: 20.sp),
            AppSpacing.w4,
            Text(
              rating.toStringAsFixed(1),
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.w4,
            Text(
              '($reviewCount ${"product.reviews_count".tr()})',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
            AppSpacing.w8,
            Container(
              width: 4.w,
              height: 4.h,
              decoration: const BoxDecoration(
                color: AppColors.divider,
                shape: BoxShape.circle,
              ),
            ),
            AppSpacing.w8,
            Text(
              "product.available_in_stock".tr(),
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceSection() {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          currencyFormat.format(product.price),
          style: AppTextStyles.displayMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        if (product.oldPrice != null) ...[
          AppSpacing.w12,
          Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Text(
              currencyFormat.format(product.oldPrice),
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textHint,
                decoration: TextDecoration.lineThrough,
                decorationColor: AppColors.textHint,
                decorationThickness: 1.5,
              ),
            ),
          ),
          AppSpacing.w12,
          _buildDiscountBadge(),
        ],
      ],
    );
  }

  Widget _buildDiscountBadge() {
    if (product.oldPrice == null || product.oldPrice! <= product.price) {
      return const SizedBox.shrink();
    }
    final discount =
        ((product.oldPrice! - product.price) / product.oldPrice! * 100).round();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: AppRadius.r8,
      ),
      child: Text(
        '+$discount%',
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: AppRadius.r24,
      ),
      child: Row(
        children: [
          _buildQuantityBtn(
            Icons.remove,
            onTap: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
            isDisabled: quantity <= 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              '$quantity',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildQuantityBtn(
            Icons.add,
            onTap: quantity < maxQuantity
                ? () => onQuantityChanged(quantity + 1)
                : null,
            isDisabled: quantity >= maxQuantity,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityBtn(
    IconData icon, {
    VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.transparent : AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: AppColors.textPrimary.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: isDisabled ? AppColors.textHint : AppColors.textPrimary,
        ),
      ),
    );
  }
}
