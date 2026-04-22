import 'package:ecommerce_app/core/theme/app_colors.dart';
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
        SizedBox(
          height: 45.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.colors.length,
            separatorBuilder: (context, index) => AppSpacing.w16,
            itemBuilder: (context, index) {
              final colorItem = widget.colors[index];
              final isSelected = _selectedColorIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedColorIndex = index);
                  widget.onColorSelected(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: colorItem.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                      width: isSelected ? 2.w : 1.w,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: _getContrastColor(colorItem.color),
                          size: 20.sp,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getContrastColor(Color color) {
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
