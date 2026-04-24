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

  static const Map<String, String> _fixedImages = {
    'sports':
        'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&q=80&w=300',
    'electronics':
        'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&q=80&w=300',
    'laptop':
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&q=80&w=300',
    'laptops':
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&q=80&w=300',
    'fashion':
        'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&q=80&w=300',
    'womens_fashion':
        'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&q=80&w=300',
    'mens_fashion':
        'https://images.unsplash.com/photo-1488161628813-04466f872be2?auto=format&fit=crop&q=80&w=300',
    'mobile':
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&q=80&w=300',
    'smartphones':
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&q=80&w=300',
    'tablet':
        'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&q=80&w=300',
    'appliances':
        'https://images.unsplash.com/photo-1584622781564-1d9876a13d00?auto=format&fit=crop&q=80&w=300',
    'headphones':
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&q=80&w=300',
    'tshirt':
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&q=80&w=300',
  };

  String? _mapCategoryToImage(String key) {
    final normalizedKey = key.toLowerCase();
    if (_fixedImages.containsKey(normalizedKey)) {
      return _fixedImages[normalizedKey];
    }
    return 'https://images.unsplash.com/featured/?$normalizedKey';
  }

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
                    final categoryName = category.name.replaceAll('Home ', '');
                    return CategoryCard(
                      category: CategoryEntity(
                        id: category.id,
                        key: category.key,
                        name: categoryName,
                        image:
                            category.image ?? _mapCategoryToImage(category.key),
                      ),
                      onTap: isLoading
                          ? () {}
                          : () {
                              context.push(
                                AppRouter.categoryProducts,
                                extra: {
                                  'name': category.name,
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
