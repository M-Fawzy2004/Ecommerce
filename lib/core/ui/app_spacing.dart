import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Spacing tokens — use instead of raw SizedBox.
/// ⚠ Never write SizedBox(height/width: <literal>) anywhere in the codebase.
abstract class AppSpacing {
  // ── Vertical Spacing (Height) ───────────────────────────────────────────
  static SizedBox get h4 => SizedBox(height: 4.h);
  static SizedBox get h8 => SizedBox(height: 8.h);
  static SizedBox get h12 => SizedBox(height: 12.h);
  static SizedBox get h16 => SizedBox(height: 16.h);
  static SizedBox get h20 => SizedBox(height: 20.h);
  static SizedBox get h24 => SizedBox(height: 24.h);
  static SizedBox get h32 => SizedBox(height: 32.h);
  static SizedBox get h40 => SizedBox(height: 40.h);
  static SizedBox get h48 => SizedBox(height: 48.h);
  static SizedBox get h56 => SizedBox(height: 56.h);
  static SizedBox get h64 => SizedBox(height: 64.h);

  // ── Horizontal Spacing (Width) ─────────────────────────────────────────
  static SizedBox get w4 => SizedBox(width: 4.w);
  static SizedBox get w8 => SizedBox(width: 8.w);
  static SizedBox get w12 => SizedBox(width: 12.w);
  static SizedBox get w16 => SizedBox(width: 16.w);
  static SizedBox get w20 => SizedBox(width: 20.w);
  static SizedBox get w24 => SizedBox(width: 24.w);
  static SizedBox get w32 => SizedBox(width: 32.w);

  // ── EdgeInsets helpers ────────────────────────────────────────────────────
  static EdgeInsets get pageHorizontal =>
      EdgeInsets.symmetric(horizontal: 20.w);

  static EdgeInsets get pageAll => EdgeInsets.all(20.r);

  static EdgeInsets get cardPadding =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
}

/// Dynamic vertical gap widget.
class VerticalSpace extends StatelessWidget {
  final double height;
  const VerticalSpace(this.height, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: height.h);
}

/// Dynamic horizontal gap widget.
class HorizontalSpace extends StatelessWidget {
  final double width;
  const HorizontalSpace(this.width, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(width: width.w);
}
