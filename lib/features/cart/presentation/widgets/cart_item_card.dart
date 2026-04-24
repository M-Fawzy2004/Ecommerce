import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/app_radius.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: item.isSelected,
            activeColor: AppColors.primary,
            onChanged: (_) =>
                context.read<CartCubit>().toggleSelection(item.product.id),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          // Product Image
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: AppRadius.r12,
            ),
            child: ClipRRect(
              borderRadius: AppRadius.r12,
              child: CachedNetworkImage(
                imageUrl: item.product.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          AppSpacing.w12,
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (item.selectedColor != null)
                  Text(
                    '${'product.color'.tr()}: ${item.selectedColor}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                AppSpacing.h8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity Controller
                    Container(
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: AppColors.gray,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          _buildQtyBtn(
                            context,
                            Icons.remove,
                            () => context.read<CartCubit>().updateQuantity(
                              item.product.id,
                              -1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              '${item.quantity}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          _buildQtyBtn(
                            context,
                            Icons.add,
                            () => context.read<CartCubit>().updateQuantity(
                              item.product.id,
                              1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Price
                    Text(
                      '\$${item.product.price}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(BuildContext context, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.r),
        child: Icon(icon, size: 16.sp, color: AppColors.textPrimary),
      ),
    );
  }
}
