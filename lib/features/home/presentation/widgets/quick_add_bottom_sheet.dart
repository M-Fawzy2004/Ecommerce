import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuickAddBottomSheet extends StatefulWidget {
  final ProductEntity product;

  const QuickAddBottomSheet({super.key, required this.product});

  static Future<void> show(BuildContext context, ProductEntity product) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickAddBottomSheet(product: product),
    );
  }

  @override
  State<QuickAddBottomSheet> createState() => _QuickAddBottomSheetState();
}

class _QuickAddBottomSheetState extends State<QuickAddBottomSheet> {
  int _quantity = 1;
  int _selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          serviceLocator<ProductDetailsCubit>()
            ..getProductDetails(widget.product.id),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            if (state is ProductDetailsLoading ||
                state is ProductDetailsInitial) {
              return _buildLoading();
            }

            if (state is ProductDetailsError) {
              return _buildError(state.message);
            }

            final detailsProduct = (state as ProductDetailsLoaded).product;
            return _buildContent(context, detailsProduct);
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          AppSpacing.h20,
          Row(
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              AppSpacing.w16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 150.w, height: 20.h, color: Colors.grey),
                    AppSpacing.h8,
                    Container(width: 80.w, height: 15.h, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.h24,
          Container(width: double.infinity, height: 50.h, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, style: AppTextStyles.bodyMedium),
        AppSpacing.h16,
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ProductDetailsEntity product) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle
        Center(
          child: Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
        AppSpacing.h20,

        // Product Header
        Row(
          children: [
            Container(
              width: 90.w,
              height: 90.w,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    product.colors.isNotEmpty &&
                        product.colors[_selectedColorIndex].image != null
                    ? product.colors[_selectedColorIndex].image!
                    : product.image,
                fit: BoxFit.contain,
              ),
            ),
            AppSpacing.w16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.h4,
                  Text(
                    '\$${NumberFormat("#,###").format(product.price)}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSpacing.h24,

        // Color Selection
        if (product.colors.isNotEmpty) ...[
          Text(
            "product.select_color".tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.h12,
          SizedBox(
            height: 40.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: product.colors.length,
              separatorBuilder: (context, index) => AppSpacing.w12,
              itemBuilder: (context, index) {
                final colorEntity = product.colors[index];
                final isSelected = _selectedColorIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColorIndex = index),
                  child: Container(
                    padding: EdgeInsets.all(isSelected ? 2.w : 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2.w)
                          : null,
                    ),
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        color: colorEntity.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AppSpacing.h24,
        ],

        // Quantity Selection
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "product.quantity".tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  _buildQtyBtn(Icons.remove, () {
                    if (_quantity > 1) setState(() => _quantity--);
                  }),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      _quantity.toString(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildQtyBtn(Icons.add, () {
                    if (_quantity < 10) setState(() => _quantity++);
                  }),
                ],
              ),
            ),
          ],
        ),
        AppSpacing.h32,

        // Add to Cart Button
        SizedBox(
          width: double.infinity,
          height: 55.h,
          child: ElevatedButton(
            onPressed: () {
              final selectedColor = product.colors.isNotEmpty
                  ? product.colors[_selectedColorIndex].name
                  : null;
              context.read<CartCubit>().addToCart(
                product,
                quantity: _quantity,
                color: selectedColor,
              );
              Navigator.pop(context);
              AppToast.success(context, message: 'product.added_to_cart'.tr());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'product.add'.tr(),
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        AppSpacing.h12,
      ],
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Icon(icon, size: 20.sp, color: AppColors.textPrimary),
      ),
    );
  }
}
