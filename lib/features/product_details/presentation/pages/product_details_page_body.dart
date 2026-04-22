import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:ecommerce_app/features/product_details/presentation/widgets/product_details_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/product_info_section.dart';
import '../widgets/product_colors_section.dart';
import '../widgets/product_description_section.dart';
import '../widgets/product_specifications_section.dart';
import '../widgets/product_reviews_section.dart';

class ProductDetailsPageBody extends StatefulWidget {
  final ProductDetailsEntity product;

  const ProductDetailsPageBody({super.key, required this.product});

  @override
  State<ProductDetailsPageBody> createState() => _ProductDetailsPageBodyState();
}

class _ProductDetailsPageBodyState extends State<ProductDetailsPageBody> {
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
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Custom Header with icons over carousel
        ProductDetailsSliverAppBar(images: widget.product.images),

        // Content
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ProductInfoSection(
                product: widget.product,
                quantity: _quantity,
                maxQuantity: _getMaxStock(),
                onQuantityChanged: _onQuantityChanged,
              ),
              _buildDivider(),
              ProductColorsSection(
                colors: widget.product.colors,
                initialIndex: _selectedColorIndex,
                onColorSelected: _onColorSelected,
              ),
              _buildDivider(),
              ProductDescriptionSection(
                description: widget.product.description,
              ),
              _buildDivider(),
              ProductSpecificationsSection(product: widget.product),
              _buildDivider(),
              const ProductReviewsSection(),
              AppSpacing.h40, // Space for the bottom bar height
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        AppSpacing.h12,
        Divider(
          color: AppColors.divider.withOpacity(0.6),
          thickness: 1.h,
        ),
        AppSpacing.h12,
      ],
    );
  }
}
