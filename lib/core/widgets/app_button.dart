import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../ui/app_radius.dart';

/// Shared primary action button with loading state support.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.r16),
        minimumSize: Size(double.infinity, 45.h),
      ),
      child: isLoading
          ? SizedBox(
              height: 20.r,
              width: 20.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: textColor ?? Colors.white,
              ),
            )
          : Text(
              text,
              style: AppTextStyles.buttonLarge.copyWith(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
