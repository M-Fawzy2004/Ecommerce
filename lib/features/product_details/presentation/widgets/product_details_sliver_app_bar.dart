// product_details_sliver_app_bar.dart

import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:ecommerce_app/features/product_details/presentation/widgets/product_image_carousel.dart';

class ProductDetailsSliverAppBar extends StatelessWidget {
  final List<String> images;

  const ProductDetailsSliverAppBar({
    super.key,
    required this.images,
  });

  Widget _buildIconButton(IconData icon) {
    return SizedBox(
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
            color: AppColors.textPrimary,
            size: 18.sp,
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
        leading: _buildIconButton(IconlyLight.arrow_left_2),
        actions: [
          _buildIconButton(IconlyLight.heart),
          AppSpacing.w8,
          _buildIconButton(IconlyLight.send),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        primary: true,
        pinned: true,
        expandedHeight: 400.h,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight + 0.h),
            child: ProductImageCarousel(images: images),
          ),
        ),
      ),
    );
  }
}
