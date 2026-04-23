import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/reviews_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_details_page_body.dart';
import '../widgets/product_details_skeleton.dart';
import '../widgets/product_bottom_bar.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<ProductDetailsCubit>()
            ..getProductDetails(product.id),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ReviewsCubit>()
            ..loadReviews(product.id, userId: userId),
        ),
      ],
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          // ── Error ──────────────────────────────────────────────────────────
          if (state is ProductDetailsError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 64,
                    ),
                    AppSpacing.h16,
                    Text(state.message, style: AppTextStyles.bodyLarge),
                    AppSpacing.h12,
                    TextButton(
                      onPressed: () => context
                          .read<ProductDetailsCubit>()
                          .getProductDetails(product.id),
                      child: Text('common.retry'.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── Loading ────────────────────────────────────────────────────────
          if (state is ProductDetailsLoading ||
              state is ProductDetailsInitial) {
            return const Scaffold(
              backgroundColor: AppColors.surface,
              body: ProductDetailsSkeleton(),
            );
          }

          // ── Loaded ─────────────────────────────────────────────────────────
          final detailsProduct = (state as ProductDetailsLoaded).product;

          return Scaffold(
            backgroundColor: AppColors.surface,
            body: ProductDetailsPageBody(product: detailsProduct),
            bottomNavigationBar: ProductBottomBar(
              price: detailsProduct.price,
              onAddToCart: () => AppToast.success(
                context,
                message: 'product.added_to_cart'.tr(),
              ),
            ),
          );
        },
      ),
    );
  }
}
