import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/home/presentation/cubit/recently_added_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'product_card.dart';

class RecentlyAddedSection extends StatefulWidget {
  const RecentlyAddedSection({super.key});

  @override
  State<RecentlyAddedSection> createState() => _RecentlyAddedSectionState();
}

class _RecentlyAddedSectionState extends State<RecentlyAddedSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<RecentlyAddedCubit>().loadMore();
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
    return BlocBuilder<RecentlyAddedCubit, RecentlyAddedState>(
      builder: (context, state) {
        if (state is RecentlyAddedInitial) {
          return const SizedBox.shrink();
        }

        if (state is RecentlyAddedLoading) {
          return const _LoadingPlaceholder();
        }

        if (state is RecentlyAddedError) {
          return Center(child: Text(state.message));
        }

        if (state is RecentlyAddedLoaded) {
          final products = state.products;
          if (products.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              AppSpacing.h16,
              SizedBox(
                height: 215.h,
                child: ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.hasReachedMax
                      ? products.length
                      : products.length + 1,
                  separatorBuilder: (context, index) => SizedBox(width: 16.w),
                  itemBuilder: (context, index) {
                    if (index >= products.length) {
                      return const _LoadingIndicator();
                    }
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        context.push(AppRouter.productDetails, extra: product);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        'home.recently_added'.tr(),
        style: AppTextStyles.headlineSmall.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
