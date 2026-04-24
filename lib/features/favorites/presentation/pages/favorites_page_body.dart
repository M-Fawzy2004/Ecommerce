import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:ecommerce_app/features/favorites/presentation/widgets/favorite_product_card.dart';
import 'package:iconly/iconly.dart';

class FavoritesPageBody extends StatelessWidget {
  const FavoritesPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                if (state.favorites.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.favorites.length,
                  separatorBuilder: (context, index) => AppSpacing.h16,
                  itemBuilder: (context, index) {
                    final product = state.favorites[index];
                    return FavoriteProductCard(
                      product: product,
                      onTap: () => context.push(
                        AppRouter.productDetails.replaceFirst(
                          ':id',
                          product.id,
                        ),
                        extra: product,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          const AppBackButton(),
          Expanded(
            child: Center(
              child: Text(
                'profile.favorite'.tr(),
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(width: 45.w), // Balance for the back button
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconlyLight.heart, size: 100.sp, color: Colors.grey[300]),
          AppSpacing.h20,
          Text(
            'favorites.no_items'.tr(),
            style: AppTextStyles.headlineSmall.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
