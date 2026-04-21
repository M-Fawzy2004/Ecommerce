import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../widgets/product_details_body.dart';
import '../widgets/product_bottom_bar.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductEntity product;
  
  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ProductDetailsCubit>()..getProductDetails(product.id),
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 64),
                    AppSpacing.h16,
                    Text(state.message, style: AppTextStyles.bodyLarge),
                    AppSpacing.h8,
                    TextButton(
                      onPressed: () => context.read<ProductDetailsCubit>().getProductDetails(product.id),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final bool isLoading = state is ProductDetailsLoading || state is ProductDetailsInitial;
          final detailsProduct = state is ProductDetailsLoaded ? state.product : null;

          return Scaffold(
            body: SafeArea(
              child: Skeletonizer(
                enabled: isLoading,
                child: detailsProduct == null 
                  ? const Center(child: CircularProgressIndicator()) 
                  : ProductDetailsBody(product: detailsProduct),
              ),
            ),
            bottomNavigationBar: detailsProduct == null 
              ? null 
              : ProductBottomBar(
                  price: detailsProduct.price,
                  onAddToCart: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to Cart!')),
                    );
                  },
                ),
          );
        },
      ),
    );
  }
}
