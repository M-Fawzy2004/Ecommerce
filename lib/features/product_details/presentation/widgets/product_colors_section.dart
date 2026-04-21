import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductColorsSection extends StatefulWidget {
  final List<ProductColorEntity> colors;
  final int initialIndex;
  final Function(int) onColorSelected;

  const ProductColorsSection({
    super.key,
    required this.colors,
    required this.initialIndex,
    required this.onColorSelected,
  });

  @override
  State<ProductColorsSection> createState() => _ProductColorsSectionState();
}

class _ProductColorsSectionState extends State<ProductColorsSection> {
  late int _selectedColorIndex;

  @override
  void initState() {
    super.initState();
    _selectedColorIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.colors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.h16,
        SizedBox(
          height: 50.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.colors.length,
            separatorBuilder: (context, index) => AppSpacing.w20,
            itemBuilder: (context, index) {
              final colorItem = widget.colors[index];
              final isSelected = _selectedColorIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedColorIndex = index);
                  widget.onColorSelected(index);
                },
                child: Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: colorItem.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 24)
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
