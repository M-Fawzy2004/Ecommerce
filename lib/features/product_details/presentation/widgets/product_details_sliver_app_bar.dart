// product_details_sliver_app_bar.dart

import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:ecommerce_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/product_details/presentation/widgets/product_image_carousel.dart';

class ProductDetailsSliverAppBar extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsSliverAppBar({super.key, required this.product});

  Widget _buildIconButton({
    required IconData icon,
    required BuildContext context,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (icon == IconlyLight.arrow_left_2) {
              Navigator.pop(context);
            }
          },
      child: SizedBox(
        height: 45.h,
        width: 45.w,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.gray,
            border: Border.all(color: AppColors.divider, width: 1.w),
          ),
          child: Center(
            child: Icon(
              icon,
              color: iconColor ?? AppColors.textPrimary,
              size: 18.sp,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverAppBar(
        leadingWidth: 45.w,
        leading: _buildIconButton(
          icon: IconlyLight.arrow_left_2,
          context: context,
        ),
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final isFavorite = context.read<FavoritesCubit>().isFavorite(product.id);
              return _buildIconButton(
                icon: isFavorite ? IconlyBold.heart : IconlyLight.heart,
                iconColor: isFavorite ? AppColors.error : null,
                context: context,
                onTap: () => context.read<FavoritesCubit>().toggleFavorite(product),
              );
            },
          ),
          AppSpacing.w8,
          _buildIconButton(icon: IconlyLight.send, context: context),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        primary: true,
        pinned: true,
        expandedHeight: 400.h,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight + 60.h),
            child: ProductImageCarousel(
              images: product is ProductDetailsEntity
                  ? (product as ProductDetailsEntity).images
                  : [product.image],
            ),
          ),
        ),
      ),
    );
  }
}
