import 'package:flutter/material.dart';

/// App-wide color palette — single source of truth.
/// ⚠ Never use raw Color() or Colors.* outside this file.
abstract class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFFF5500);
  static const Color primaryLight = Color.fromARGB(255, 0, 154, 204);
  static const Color primaryDark = Color.fromARGB(255, 0, 76, 102);

  static const Color secondary = Color(0xFFFF6B35);
  static const Color secondaryLight = Color(0xFFFF9A70);
  static const Color secondaryDark = Color(0xFFCC4A1A);

  // ── Neutrals ──────────────────────────────────────────────────────────────
  static const Color backgroundSoft = Colors.white;
  static const Color backgroundDark = Color(0xFF0F1724);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A2537);
  static const Color divider = Color(0xFFE0E6F0);
  static const Color gray = Color(0xFFF7F7F7);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F1724);
  static const Color textSecondary = Color(0xFF6B7A99);
  static const Color textHint = Color(0xFFADB5CC);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Misc ─────────────────────────────────────────────────────────────────
  static const Color transparent = Colors.transparent;
  static const Color star = Color(0xFFFACC15);
  static const Color shimmerBase = Color(0xFFE0E6F0);
  static const Color shimmerHighlight = Color(0xFFF5F7FA);
}
