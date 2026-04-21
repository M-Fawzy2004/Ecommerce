import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryProductItem extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const CategoryProductItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 145.h, // Increased height
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 100.w, // Increased width
              height: 120.h, // Increased height
              decoration: BoxDecoration(
                color: AppColors.gray,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: _buildProductImage(),
              ),
            ),
            AppSpacing.w16,
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.h4,
                  if (product.description != null)
                    Text(
                      product.description!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const Spacer(), // Pushes content to bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.oldPrice != null)
                            Text(
                              '\$ ${NumberFormat("#,###").format(product.oldPrice)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textHint,
                                fontSize: 11.sp,
                              ),
                            ),
                          Text(
                            '\$ ${NumberFormat("#,###").format(product.price)}',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                      if (product.hasFreeShipping)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            'Free Shipping',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
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

  Widget _buildProductImage() {
    if (product.image.isEmpty) {
      return Icon(Icons.image_not_supported_outlined,
          size: 30.r, color: AppColors.textSecondary);
    }

    if (product.image.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: product.image,
        fit: BoxFit.contain,
        placeholder: (context, url) => Skeletonizer(
          enabled: true,
          child: Container(color: AppColors.gray),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error_outline),
      );
    }

    return Padding(
      padding: EdgeInsets.all(8.r),
      child: Image.asset(product.image, fit: BoxFit.contain),
    );
  }
}
