import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

class NotificationButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool hasUnread;

  const NotificationButton({
    super.key,
    required this.onTap,
    this.hasUnread = true, // Set to true to show the orange badge
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 45.h,
            height: 45.h,
            decoration: const BoxDecoration(
              color: AppColors.gray,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                IconlyLight.notification,
                color: AppColors.textPrimary,
                size: 24.sp,
              ),
            ),
          ),
          if (hasUnread)
            Positioned(
              top: 0.h,
              right: 0.w,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface,
                    width: 2.w,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
