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
        return AppColors.primary;
      case ToastType.error:
        return const Color.fromARGB(255, 255, 45, 45);
      case ToastType.info:
        return AppColors.primaryDark;
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
