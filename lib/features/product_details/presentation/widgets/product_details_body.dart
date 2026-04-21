import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/product_info_section.dart';
import '../widgets/product_colors_section.dart';
import '../widgets/product_description_section.dart';
import '../widgets/product_specifications_section.dart';
import '../widgets/product_reviews_section.dart';

class ProductDetailsBody extends StatefulWidget {
  final ProductDetailsEntity product;

  const ProductDetailsBody({super.key, required this.product});

  @override
  State<ProductDetailsBody> createState() => _ProductDetailsBodyState();
}

class _ProductDetailsBodyState extends State<ProductDetailsBody> {
  int _selectedColorIndex = 0;
  int _quantity = 1;

  int _getMaxStock() {
    if (widget.product.colors.isEmpty) return 10;
    final int stock = widget.product.colors[_selectedColorIndex].quantity;
    return stock > 0 ? (stock > 10 ? 10 : stock) : 1; // Limit to 10 or stock
  }

  void _onColorSelected(int index) {
    setState(() {
      _selectedColorIndex = index;
      // Reset quantity if it exceeds new max stock
      final maxStock = _getMaxStock();
      if (_quantity > maxStock) _quantity = maxStock;
    });
  }

  void _onQuantityChanged(int newQuantity) {
    setState(() {
      _quantity = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Custom Header with icons
        SliverAppBar(
          leading: IconButton(
            icon: const Icon(
              IconlyLight.arrow_left_2,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(IconlyLight.heart, color: AppColors.textPrimary),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(IconlyLight.send, color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          pinned: true,
        ),

        // Image Carousel
        SliverToBoxAdapter(
          child: ProductImageCarousel(
            images: widget.product.images,
          ),
        ),

        SliverToBoxAdapter(child: AppSpacing.h12),

        // Content
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ProductInfoSection(
                product: widget.product,
                quantity: _quantity,
                maxQuantity: _getMaxStock(),
                onQuantityChanged: _onQuantityChanged,
              ),
              AppSpacing.h12,
              Divider(
                color: AppColors.backgroundDark.withOpacity(0.5),
                thickness: 0.5.h,
                indent: 16.w,
                endIndent: 16.w,
              ),
              AppSpacing.h12,
              ProductColorsSection(
                colors: widget.product.colors,
                initialIndex: _selectedColorIndex,
                onColorSelected: _onColorSelected,
              ),
              AppSpacing.h12,
              Divider(
                color: AppColors.backgroundDark.withOpacity(0.5),
                thickness: 0.5.h,
                indent: 16.w,
                endIndent: 16.w,
              ),
              AppSpacing.h12,
              ProductDescriptionSection(
                  description: widget.product.description),
              AppSpacing.h12,
              Divider(
                color: AppColors.backgroundDark.withOpacity(0.5),
                thickness: 0.5.h,
                indent: 16.w,
                endIndent: 16.w,
              ),
              AppSpacing.h12,
              ProductSpecificationsSection(product: widget.product),
              AppSpacing.h12,
              Divider(
                color: AppColors.backgroundDark.withOpacity(0.5),
                thickness: 0.5.h,
                indent: 16.w,
                endIndent: 16.w,
              ),
              AppSpacing.h12,
              const ProductReviewsSection(),
              AppSpacing.h20, // Bottom padding for bottom bar
            ]),
          ),
        ),
      ],
    );
  }
}
