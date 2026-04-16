import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'toast_type.dart';

class ToastCard extends StatelessWidget {
  final String message;
  final String? subtitle;
  final ToastType type;
  final Duration duration;
  final VoidCallback onDismiss;
  final VoidCallback? onTap;

  const ToastCard({
    super.key,
    required this.message,
    this.subtitle,
    required this.type,
    required this.duration,
    required this.onDismiss,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = type.color;

    return GestureDetector(
      onTap: onTap,
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) onDismiss();
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          children: [
            // Background Gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.1), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              child: Row(
                children: [
                  _ToastIcon(icon: type.icon),
                  AppSpacing.w12,
                  Expanded(
                    child: _ToastText(message: message, subtitle: subtitle),
                  ),
                  _CloseButton(onTap: onDismiss),
                ],
              ),
            ),
            // Progress Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _ToastProgressBar(duration: duration),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Sub Components (Private to this file only) ---

class _ToastIcon extends StatelessWidget {
  final IconData icon;
  const _ToastIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20.sp),
    );
  }
}

class _ToastText extends StatelessWidget {
  final String message;
  final String? subtitle;
  const _ToastText({required this.message, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        ),
        if (subtitle != null) ...[
          AppSpacing.h4,
          Text(
            subtitle!,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Icon(
          Icons.close,
          color: Colors.white.withOpacity(0.8),
          size: 18.sp,
        ),
      ),
    );
  }
}

class _ToastProgressBar extends StatelessWidget {
  final Duration duration;
  const _ToastProgressBar({required this.duration});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: duration,
      curve: Curves.linear,
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.5)),
          minHeight: 4.h,
        );
      },
    );
  }
}
