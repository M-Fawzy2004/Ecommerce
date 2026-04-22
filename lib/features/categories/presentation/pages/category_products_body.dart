import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:ecommerce_app/features/categories/presentation/widgets/category_product_item.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/categories/presentation/cubit/category_details_cubit.dart';
import 'package:ecommerce_app/features/categories/presentation/cubit/category_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryProductsBody extends StatefulWidget {
  final String categoryName;
  final String categoryKey;

  const CategoryProductsBody({
    super.key,
    required this.categoryName,
    required this.categoryKey,
  });

  @override
  State<CategoryProductsBody> createState() => _CategoryProductsBodyState();
}

class _CategoryProductsBodyState extends State<CategoryProductsBody> {
  late ScrollController _scrollController;

  static final List<ProductEntity> _dummyProducts = List.generate(
    5,
    (index) => ProductEntity(
      id: index.toString(),
      name: 'Loading Product Name',
      image: '',
      price: 1000,
      hasFreeShipping: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CategoryDetailsCubit>().loadMoreProducts(widget.categoryKey);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryDetailsCubit, CategoryDetailsState>(
      builder: (context, state) {
        if (state is CategoryDetailsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 64,
                ),
                AppSpacing.h16,
                Text(state.message, style: AppTextStyles.bodyLarge),
                AppSpacing.h8,
                TextButton(
                  onPressed: () => context
                      .read<CategoryDetailsCubit>()
                      .getProducts(widget.categoryKey),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final bool isLoading = state is CategoryDetailsLoading;
        final products =
            state is CategoryDetailsLoaded ? state.products : _dummyProducts;

        return RefreshIndicator(
          onRefresh: () => context
              .read<CategoryDetailsCubit>()
              .getProducts(widget.categoryKey, isRefresh: true),
          displacement: 20,
          color: AppColors.primary,
          child: CustomScrollView(
            controller: _scrollController,
            physics: isLoading
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            slivers: [
              // App Bar / Header
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverAppBar(
                  floating: true,
                  pinned: true,
                  leadingWidth: 45.w,
                  elevation: 0,
                  backgroundColor: AppColors.backgroundSoft,
                  surfaceTintColor: Colors.transparent,
                  leading: const AppBackButton(),
                  title: Text(
                    widget.categoryName,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  centerTitle: true,
                ),
              ),

              if (state is CategoryDetailsLoaded && products.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconlyLight.bag,
                          size: 80.r,
                          color: AppColors.textHint.withOpacity(0.5),
                        ),
                        AppSpacing.h16,
                        Text(
                          'categories.no_products'.tr(),
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSpacing.h8,
                        Text(
                          'categories.no_products_desc'.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Skeletonizer.sliver(
                  enabled: isLoading,
                  child: SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < products.length) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: CategoryProductItem(
                                product: products[index],
                                onTap: isLoading
                                    ? () {}
                                    : () {
                                        context.push(
                                          AppRouter.productDetails,
                                          extra: products[index],
                                        );
                                      },
                              ),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                        childCount: state is CategoryDetailsLoaded &&
                                state.isPaginationLoading
                            ? products.length + 1
                            : products.length,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
