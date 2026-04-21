import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/utils/text_direction_helper.dart';
import 'package:ecommerce_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSpecificationsSection extends StatelessWidget {
  final ProductDetailsEntity product;

  const ProductSpecificationsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, String>> displayedData = [];

    // Add JSON specs
    if (product.specs != null) {
      product.specs!.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          displayedData.add(MapEntry(key, value.toString()));
        }
      });
    }

    // Add Measures
    if (product.weight != null) {
      displayedData.add(MapEntry('Weight', '${product.weight} ${product.weightUnit ?? 'kg'}'));
    }
    if (product.length != null) {
      displayedData.add(MapEntry('Length', '${product.length} ${product.dimensionUnit ?? 'cm'}'));
    }
    if (product.width != null) {
      displayedData.add(MapEntry('Width', '${product.width} ${product.dimensionUnit ?? 'cm'}'));
    }
    if (product.height != null) {
      displayedData.add(MapEntry('Height', '${product.height} ${product.dimensionUnit ?? 'cm'}'));
    }
    if (product.sku != null) {
      displayedData.add(MapEntry('SKU', product.sku!));
    }

    if (displayedData.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specifications',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.h16,
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: displayedData.map((entry) {
            final bool isRtl = TextDirectionHelper.isRtl(entry.value);

            return Container(
              width: (1.sw - 44.w) / 2, // 2 items per row with spacing
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.gray.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.gray.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                      fontSize: 11.sp,
                    ),
                  ),
                  AppSpacing.h4,
                  Text(
                    entry.value,
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
