import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ecommerce_app/core/extensions/category_extension.dart';
import '../widgets/category_card.dart';

class CategoriesPageBody extends StatelessWidget {
  const CategoriesPageBody({super.key});

  static final List<CategoryEntity> _dummyCategories = List.generate(
    6,
    (index) => CategoryEntity(
      id: index.toString(),
      key: 'loading',
      name: 'Loading...',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is CategoriesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 48,
                ),
                AppSpacing.h16,
                Text(state.message, style: AppTextStyles.bodyLarge),
                AppSpacing.h16,
                TextButton(
                  onPressed: () =>
                      context.read<CategoriesCubit>().getCategories(),
                  child: Text('common.retry'.tr()),
                ),
              ],
            ),
          );
        }

        final bool isLoading = state is CategoriesLoading;
        final list = state is CategoriesLoaded
            ? state.categories
            : _dummyCategories;

        if (state is CategoriesLoaded && list.isEmpty) {
          return Center(child: Text('categories.empty'.tr()));
        }

        return Skeletonizer(
          enabled: isLoading,
          child: CustomScrollView(
            physics: isLoading
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
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
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final category = list[index];
                    final _ = category.name.replaceAll('Home ', '');
                    return CategoryCard(
                      category: category,
                      onTap: isLoading
                          ? () {}
                          : () {
                              context.push(
                                AppRouter.categoryProducts,
                                extra: {
                                  'name': category.translatedName,
                                  'key': category.key,
                                },
                              );
                            },
                    );
                  }, childCount: list.length),
                ),
              ),
              SliverToBoxAdapter(child: AppSpacing.h64),
            ],
          ),
        );
      },
    );
  }
}
