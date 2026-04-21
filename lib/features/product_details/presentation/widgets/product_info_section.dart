import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
          children: [
            Expanded(
              child: Text(
                product.name,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 22.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Quantity Selector UI
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.gray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                children: [
                  _buildQuantityBtn(
                    Icons.remove,
                    onTap: quantity > 1
                        ? () => onQuantityChanged(quantity - 1)
                        : null,
                    isDisabled: quantity <= 1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      '$quantity',
                      style: AppTextStyles.bodyLarge.copyWith(
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
            ),
          ],
        ),

        AppSpacing.h8,

        // Rating and Stock Status Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Rating
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: 20.sp),
                AppSpacing.w4,
                Text(
                  '${product.rating ?? 0.0}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.w4,
                Text(
                  '(${product.reviewCount ?? 0} Review)',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
            // Stock status
            Text(
              'Available in stock',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),

        AppSpacing.h16,

        // Price Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$ ${NumberFormat("#,###").format(product.price)}',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                fontSize: 24.sp,
              ),
            ),
            if (product.oldPrice != null) ...[
              AppSpacing.w12,
              Text(
                '\$ ${NumberFormat("#,###").format(product.oldPrice)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityBtn(IconData icon,
      {VoidCallback? onTap, bool isDisabled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.3 : 1.0,
        child: Container(
          padding: EdgeInsets.all(4.r),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16.sp, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
