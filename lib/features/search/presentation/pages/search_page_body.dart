import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:ecommerce_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:ecommerce_app/features/categories/presentation/widgets/category_card.dart';
import 'package:ecommerce_app/features/home/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:ecommerce_app/features/search/presentation/cubit/search_state.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/core/extensions/category_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class SearchPageBody extends StatefulWidget {
  const SearchPageBody({super.key});

  @override
  State<SearchPageBody> createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<SearchPageBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        AppSpacing.h16,
        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SearchLoaded) {
                return _buildResults(state);
              }
              if (state is SearchError) {
                return Center(child: Text(state.message));
              }
              return _buildInitialState();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          const AppBackButton(),
          AppSpacing.w12,
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.gray,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) => context.read<SearchCubit>().search(value),
                decoration: InputDecoration(
                  hintText: 'home.search_products'.tr(),
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textHint,
                  ),
                  prefixIcon: Icon(
                    IconlyLight.search,
                    color: AppColors.textHint,
                    size: 20.sp,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SearchCubit>().clearSearch();
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'categories.title'.tr(),
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          AppSpacing.h12,
          BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoaded) {
                return SizedBox(
                  height: 100.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    separatorBuilder: (context, index) => AppSpacing.w16,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return SizedBox(
                        width: 80.w,
                        child: CategoryCard(
                          category: category,
                          onTap: () {
                            context.push(
                              AppRouter.categoryProducts,
                              extra: {
                                'name': category.translatedName,
                                'key': category.key,
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          AppSpacing.h24,
          _buildPopularSearches(),
        ],
      ),
    );
  }

  Widget _buildPopularSearches() {
    final popular = ['iPhone', 'T-Shirt', 'Headphones', 'Laptop'];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches', // Should be localized
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.h12,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: popular
                .map(
                  (query) => ActionChip(
                    label: Text(query),
                    onPressed: () {
                      _searchController.text = query;
                      context.read<SearchCubit>().search(query);
                    },
                    backgroundColor: AppColors.gray,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(SearchLoaded state) {
    if (state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconlyLight.search,
              size: 80.sp,
              color: AppColors.textHint.withOpacity(0.3),
            ),
            AppSpacing.h16,
            Text(
              'No products found',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: state.products.length,
      itemBuilder: (context, index) => ProductCard(
        product: state.products[index],
        onTap: () {
          // Navigate to details
        },
      ),
    );
  }
}
