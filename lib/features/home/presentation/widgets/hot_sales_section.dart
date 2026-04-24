import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/home/presentation/cubit/hot_sales_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'product_card.dart';

class HotSalesSection extends StatefulWidget {
  const HotSalesSection({super.key});

  @override
  State<HotSalesSection> createState() => _HotSalesSectionState();
}

class _HotSalesSectionState extends State<HotSalesSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HotSalesCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotSalesCubit, HotSalesState>(
      builder: (context, state) {
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
            _buildContent(state),
          ],
        );
      },
    );
  }

  Widget _buildContent(HotSalesState state) {
    List<ProductEntity> products = [];
    bool isLoading = false;
    bool hasReachedMax = false;

    if (state is HotSalesLoading) {
      isLoading = true;
      products = List.generate(
        5,
        (index) => const ProductEntity(
          id: '',
          name: 'Loading...',
          image: '',
          price: 0,
        ),
      );
    } else if (state is HotSalesLoaded) {
      products = state.products;
      hasReachedMax = state.hasReachedMax;
    } else if (state is HotSalesError) {
      return Center(child: Text(state.message));
    }

    if (products.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return Skeletonizer(
      enabled: isLoading,
      child: SizedBox(
        height: 215.h,
        child: ListView.separated(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          scrollDirection: Axis.horizontal,
          itemCount: products.length + (hasReachedMax ? 0 : 1),
          separatorBuilder: (context, index) => SizedBox(width: 16.w),
          itemBuilder: (context, index) {
            if (index < products.length) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  if (product.id.isNotEmpty) {
                    context.push(AppRouter.productDetails, extra: product);
                  }
                },
              );
            } else {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: const CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
