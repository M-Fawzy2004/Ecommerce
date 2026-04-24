import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/home/presentation/cubit/recently_viewed_cubit.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/reviews_cubit.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/reviews_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_details_page_body.dart';
import '../widgets/product_details_skeleton.dart';
import '../widgets/product_bottom_bar.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;

  void _onQuantityChanged(int quantity) {
    setState(() {
      _quantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              serviceLocator<ProductDetailsCubit>()
                ..getProductDetails(widget.product.id),
        ),
        BlocProvider(
          create: (_) =>
              serviceLocator<ReviewsCubit>()
                ..loadReviews(widget.product.id, userId: userId),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductDetailsCubit, ProductDetailsState>(
            listener: (context, state) {
              if (state is ProductDetailsLoaded) {
                context.read<RecentlyViewedCubit>().addProduct(state.product);
              }
            },
          ),
          BlocListener<ReviewsCubit, ReviewsState>(
            listener: (context, state) {
              if (state is ReviewsLoaded) {
                final detailsState = context.read<ProductDetailsCubit>().state;
                if (detailsState is ProductDetailsLoaded) {
                  final updatedProduct = detailsState.product.copyWith(
                    rating: state.summary.averageRating,
                    reviewCount: state.summary.totalReviews,
                  );
                  context.read<RecentlyViewedCubit>().addProduct(
                    updatedProduct,
                  );
                }
              }
            },
          ),
        ],
        child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
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
                            .getProductDetails(widget.product.id),
                        child: Text('common.retry'.tr()),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ProductDetailsLoading ||
                state is ProductDetailsInitial) {
              return const Scaffold(
                backgroundColor: AppColors.surface,
                body: ProductDetailsSkeleton(),
              );
            }

            final detailsProduct = (state as ProductDetailsLoaded).product;

            return Scaffold(
              backgroundColor: AppColors.surface,
              body: ProductDetailsPageBody(
                product: detailsProduct,
                initialQuantity: _quantity,
                onQuantityChanged: _onQuantityChanged,
              ),
              bottomNavigationBar: ProductBottomBar(
                price: detailsProduct.price * _quantity,
                onAddToCart: () => AppToast.success(
                  context,
                  message: 'product.added_to_cart'.tr(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
