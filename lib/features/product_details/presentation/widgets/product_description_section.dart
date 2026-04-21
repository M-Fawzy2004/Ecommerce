import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/utils/text_direction_helper.dart';
import 'package:flutter/material.dart';

class ProductDescriptionSection extends StatefulWidget {
  final String? description;

  const ProductDescriptionSection({super.key, this.description});

  @override
  State<ProductDescriptionSection> createState() =>
      _ProductDescriptionSectionState();
}

class _ProductDescriptionSectionState extends State<ProductDescriptionSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.description == null || widget.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool isRtl = TextDirectionHelper.isRtl(widget.description!);

    return Column(
      crossAxisAlignment:
          isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.h12,
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: isRtl ? Alignment.topRight : Alignment.topLeft,
          child: Column(
            crossAxisAlignment:
                isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign:
                    TextDirectionHelper.getTextAlign(widget.description!),
                textDirection:
                    TextDirectionHelper.getTextDirection(widget.description!),
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.description!.length > 150 && !_isExpanded
                          ? '${widget.description!.substring(0, 150)}...'
                          : widget.description!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textHint,
                        height: 1.6,
                      ),
                    ),
                    if (widget.description!.length > 150)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _isExpanded = !_isExpanded),
                          child: Text(
                            _isExpanded ? ' Show Less' : ' Read More',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
