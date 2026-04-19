import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade100),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Section
            Container(
              height: 110.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if (product.hasFreeShipping)
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'Free Ship',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info Section
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                      fontSize: 12.sp,
                    ),
                  ),
                  AppSpacing.h4,

                  // Star Rating
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        final rating = product.rating ?? 4.0;
                        if (index < rating.floor()) {
                          return Icon(
                            Icons.star_rounded,
                            size: 13.sp,
                            color: const Color(0xFFFFC107),
                          );
                        } else if (index < rating) {
                          return Icon(
                            Icons.star_half_rounded,
                            size: 13.sp,
                            color: const Color(0xFFFFC107),
                          );
                        } else {
                          return Icon(
                            Icons.star_outline_rounded,
                            size: 13.sp,
                            color: const Color(0xFFCCCCCC),
                          );
                        }
                      }),
                      SizedBox(width: 4.w),
                      Text(
                        '(${product.reviewCount ?? 0})',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.h8,
                  // Price + Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${NumberFormat("#,###").format(product.price)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontSize: 13.sp,
                        ),
                      ),
                      Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
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
}
