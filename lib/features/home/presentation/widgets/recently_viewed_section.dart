import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/utils/assets.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'product_card.dart';

class RecentlyViewedSection extends StatelessWidget {
  const RecentlyViewedSection({super.key});

  final List<ProductEntity> _products = const [
    ProductEntity(
      id: '101',
      name: 'iPhone 15 Pro',
      image: Assets.imagesPngIphone,
      price: 55000,
      hasFreeShipping: true,
      rating: 4.8,
      reviewCount: 1250,
    ),
    ProductEntity(
      id: '102',
      name: 'Macbook Air M1',
      image: Assets.imagesPngMacbook,
      price: 29999,
      hasFreeShipping: true,
      rating: 4.5,
      reviewCount: 850,
    ),
    ProductEntity(
      id: '103',
      name: 'Sony WH/1000XM5',
      image: Assets.imagesPngHeadphones,
      price: 4999,
      hasFreeShipping: true,
      rating: 4.7,
      reviewCount: 420,
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
            'home.recently_viewed'.tr(),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        AppSpacing.h16,
        SizedBox(
          height: 215.h, // Adjusted height for slightly larger cards
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: _products.length,
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              return ProductCard(
                product: _products[index],
                width: 200.w, // Larger width as requested
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
