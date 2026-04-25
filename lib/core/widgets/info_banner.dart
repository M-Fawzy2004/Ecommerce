import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_radius.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const InfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.local_shipping_outlined,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveBackgroundColor = backgroundColor ?? effectiveIconColor.withOpacity(0.05);
    final effectiveTextColor = textColor ?? AppColors.textPrimary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: AppRadius.r12,
        border: Border.all(color: effectiveIconColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: effectiveIconColor, size: 20.sp),
          AppSpacing.w12,
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.labelMedium.copyWith(
                color: effectiveTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
