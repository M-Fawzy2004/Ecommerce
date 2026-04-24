import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavoriteProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const FavoriteProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            _buildImage(),
            AppSpacing.w16,
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Quick Remove Button
                      GestureDetector(
                        onTap: () => context.read<FavoritesCubit>().toggleFavorite(product),
                        child: Icon(
                          IconlyBold.heart,
                          color: AppColors.error,
                          size: 22.sp,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.h4,
                  // Rating
                  _buildRatingRow(),
                  AppSpacing.h12,
                  // Price & Add to Cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${NumberFormat("#,###").format(product.price)}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      _buildAddToCartButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 90.w,
      height: 90.w,
      decoration: BoxDecoration(
        color: AppColors.gray,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: product.image.startsWith('http')
            ? CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.contain,
                placeholder: (context, url) => Skeletonizer(
                  enabled: true,
                  child: Container(color: AppColors.gray),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error_outline),
              )
            : Image.asset(product.image, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        Icon(Icons.star_rounded, color: const Color(0xFFFFC107), size: 16.sp),
        AppSpacing.w4,
        Text(
          (product.rating ?? 0.0).toStringAsFixed(1),
          style: AppTextStyles.labelSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.w4,
        Text(
          '(${product.reviewCount ?? 0})',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(IconlyLight.buy, color: Colors.white, size: 14.sp),
          AppSpacing.w4,
          Text(
            'product.add'.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
