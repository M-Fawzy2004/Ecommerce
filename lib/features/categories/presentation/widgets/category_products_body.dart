import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/utils/assets.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'category_product_item.dart';

class CategoryProductsBody extends StatelessWidget {
  final String categoryName;

  const CategoryProductsBody({super.key, required this.categoryName});

  // Dummy data for demo
  final List<ProductEntity> _dummyProducts = const [
    ProductEntity(
      id: '1',
      name: 'Macbook Air M1',
      image: Assets.imagesPngMacbook,
      price: 29999,
      hasFreeShipping: true,
    ),
    ProductEntity(
      id: '2',
      name: 'iPhone 15 Pro',
      image: Assets.imagesPngIphone,
      price: 55000,
      hasFreeShipping: true,
    ),
    ProductEntity(
      id: '3',
      name: 'Premium T-Shirt',
      image: Assets.imagesPngTShirt,
      price: 1500,
      hasFreeShipping: false,
    ),
    ProductEntity(
      id: '4',
      name: 'Sony WH-1000XM5',
      image: Assets.imagesPngHeadphones,
      price: 4999,
      hasFreeShipping: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar / Header
        SliverAppBar(
          floating: true,
          pinned: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            categoryName,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        // Product List
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: CategoryProductItem(
                    product: _dummyProducts[index],
                    onTap: () {},
                  ),
                );
              },
              childCount: _dummyProducts.length,
            ),
          ),
        ),
      ],
    );
  }
}
