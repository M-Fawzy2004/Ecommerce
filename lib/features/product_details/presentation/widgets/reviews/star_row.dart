import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StarRow extends StatelessWidget {
  final int rating;
  final double size;

  const StarRow({super.key, required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: AppColors.star,
          size: size,
        ),
      ),
    );
  }
}
