import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/utils/assets.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'product_card.dart';

class HotSalesSection extends StatelessWidget {
  const HotSalesSection({super.key});

  // Dummy Data for demonstration
  final List<ProductEntity> _products = const [
    ProductEntity(
      id: '1',
      name: 'Macbook Air M1',
      image: Assets.imagesPngMacbook,
      price: 29999,
      hasFreeShipping: true,
      rating: 4.5,
      reviewCount: 128,
    ),
    ProductEntity(
      id: '2',
      name: 'Sony WH/1000XM5',
      image: Assets.imagesPngHeadphones,
      price: 4999,
      hasFreeShipping: true,
      rating: 4.0,
      reviewCount: 87,
    ),
    ProductEntity(
      id: '3',
      name: 'Macbook Air M1',
      image: Assets.imagesPngMacbook,
      price: 29999,
      hasFreeShipping: true,
      rating: 3.5,
      reviewCount: 54,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'home.hot_sales'.tr(),
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        AppSpacing.h12,
        SizedBox(
          height: 210.h, // Fixed height for horizontal list
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: _products.length,
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              return ProductCard(
                product: _products[index],
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
