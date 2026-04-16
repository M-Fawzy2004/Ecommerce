import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Border-radius tokens.
/// ⚠ Never write BorderRadius.circular(<literal>) in UI code.
abstract class AppRadius {
  static BorderRadius get r4 => BorderRadius.circular(4.r);
  static BorderRadius get r8 => BorderRadius.circular(8.r);
  static BorderRadius get r12 => BorderRadius.circular(12.r);
  static BorderRadius get r16 => BorderRadius.circular(16.r);
  static BorderRadius get r20 => BorderRadius.circular(20.r);
  static BorderRadius get r24 => BorderRadius.circular(24.r);
  static BorderRadius get r32 => BorderRadius.circular(32.r);
  static BorderRadius get full => BorderRadius.circular(999.r);

  // ── Same but as BorderRadiusDirectional-friendly Radius aliases ───────────
  static Radius get rad4 => Radius.circular(4.r);
  static Radius get rad8 => Radius.circular(8.r);
  static Radius get rad12 => Radius.circular(12.r);
  static Radius get rad16 => Radius.circular(16.r);
}
