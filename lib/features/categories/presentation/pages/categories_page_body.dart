import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/utils/assets.dart';
import 'package:ecommerce_app/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/category_card.dart';

class CategoriesPageBody extends StatelessWidget {
  const CategoriesPageBody({super.key});

  final List<CategoryEntity> _categories = const [
    CategoryEntity(
      id: '1',
      name: 'categories.laptops',
      image: Assets.imagesPngMacbook,
    ),
    CategoryEntity(
      id: '2',
      name: 'categories.headphones',
      image: Assets.imagesPngHeadphones,
    ),
    CategoryEntity(
      id: '3',
      name: 'categories.smartphones',
      image: Assets.imagesPngIphone,
    ),
    CategoryEntity(
      id: '4',
      name: 'categories.tshirt',
      image: Assets.imagesPngTShirt,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          sliver: SliverToBoxAdapter(
            child: Text(
              'categories.title'.tr(),
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return CategoryCard(
                  category: CategoryEntity(
                    id: _categories[index].id,
                    name: _categories[index].name.tr(),
                    image: _categories[index].image,
                  ),
                  onTap: () {
                    context.push(
                      AppRouter.categoryProducts,
                      extra: _categories[index].name.tr(),
                    );
                  },
                );
              },
              childCount: _categories.length,
            ),
          ),
        ),
        // Bottom spacing for navigation bar
        SliverToBoxAdapter(
          child: AppSpacing.h80,
        ),
      ],
    );
  }
}
