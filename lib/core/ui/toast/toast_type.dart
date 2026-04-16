import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum ToastType {
  success,
  error,
  info,
  warning;

  Color get color {
    switch (this) {
      case ToastType.success:
        return AppColors.success;
      case ToastType.error:
        return AppColors.error;
      case ToastType.info:
        return AppColors.primary;
      case ToastType.warning:
        return const Color(0xFFFFA726);
    }
  }

  IconData get icon {
    switch (this) {
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.error:
        return Icons.error_outline_rounded;
      case ToastType.info:
        return Icons.info_outline_rounded;
      case ToastType.warning:
        return Icons.warning_amber_rounded;
    }
  }
}
