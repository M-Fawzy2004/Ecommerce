import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/ui/app_radius.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// [ProductDetailsSkeleton]
/// Mirrors the exact CustomScrollView structure of [ProductDetailsPageBody]
/// so the skeleton transition is seamless and design-accurate.
/// Uses dedicated shimmer blocks — never wraps [SliverAppBar] which breaks layout.
class ProductDetailsSkeleton extends StatelessWidget {
  const ProductDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        duration: Duration(milliseconds: 1200),
      ),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // ── Pure skeleton AppBar — no image loading ────────────────────
          _SkeletonSliverAppBar(),

          // ── Content skeleton ─────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SkeletonInfoSection(),
                _buildDivider(),
                _SkeletonColorsSection(),
                _buildDivider(),
                _SkeletonDescriptionSection(),
                _buildDivider(),
                _SkeletonSpecsSection(),
                _buildDivider(),
                _SkeletonReviewsSection(),
                AppSpacing.h40,
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        AppSpacing.h12,
        Divider(color: AppColors.divider.withOpacity(0.6), thickness: 1.h),
        AppSpacing.h12,
      ],
    );
  }
}

// ── Private skeleton blocks ────────────────────────────────────────────────

/// Mirrors [ProductDetailsSliverAppBar] exactly:
/// same expandedHeight (400.h), same pinned behavior, same icon layout.
/// Does NOT load any images — uses a shimmer Container instead.
class _SkeletonSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverAppBar(
        leadingWidth: 45.w,
        leading: _buildIconButton(IconlyLight.arrow_left_2),
        actions: [
          _buildIconButton(IconlyLight.heart),
          AppSpacing.w8,
          _buildIconButton(IconlyLight.send),
        ],
        backgroundColor: AppColors.surface,
        elevation: 0,
        primary: true,
        pinned: true,
        expandedHeight: 400.h,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            color: AppColors.gray,
            // Shimmer placeholder — 3 dots to simulate carousel indicator
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: i == 0 ? 16.w : 8.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerBase,
                        borderRadius: AppRadius.r8,
                      ),
                    ),
                  ),
                ),
                AppSpacing.h12,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return SizedBox(
      height: 45.h,
      width: 45.w,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.gray,
          border: Border.all(color: AppColors.divider, width: 1.w),
        ),
        child: Center(
          child: Icon(icon, color: AppColors.textPrimary, size: 18.sp),
        ),
      ),
    );
  }
}

class _SkeletonInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bone(width: 220.w, height: 24.h),
                  AppSpacing.h8,
                  _Bone(width: 140.w, height: 16.h),
                ],
              ),
            ),
            _Bone(width: 80.w, height: 48.h, radius: AppRadius.r12),
          ],
        ),
        AppSpacing.h12,
        Row(
          children: [
            _Bone(width: 72.w, height: 32.h, radius: AppRadius.r8),
            AppSpacing.w12,
            _Bone(width: 56.w, height: 20.h, radius: AppRadius.r8),
          ],
        ),
      ],
    );
  }
}

class _SkeletonColorsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        4,
        (_) => Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: _Bone(width: 44.w, height: 44.h, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _SkeletonDescriptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Bone(width: 130.w, height: 20.h),
        AppSpacing.h12,
        _Bone(width: double.infinity, height: 14.h),
        AppSpacing.h8,
        _Bone(width: double.infinity, height: 14.h),
        AppSpacing.h8,
        _Bone(width: 200.w, height: 14.h),
      ],
    );
  }
}

class _SkeletonSpecsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double cardWidth = (1.sw - 44.w) / 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Bone(width: 140.w, height: 20.h),
        AppSpacing.h16,
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: List.generate(
            4,
            (_) => _Bone(
              width: cardWidth,
              height: 58.h,
              radius: AppRadius.r12,
            ),
          ),
        ),
      ],
    );
  }
}

class _SkeletonReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Bone(width: 130.w, height: 20.h),
            _Bone(width: 100.w, height: 16.h),
          ],
        ),
        AppSpacing.h16,
        // Add review box
        _Bone(width: double.infinity, height: 80.h, radius: AppRadius.r16),
        AppSpacing.h24,
        // Review items
        for (int i = 0; i < 2; i++) ...[
          Row(
            children: [
              _Bone(width: 40.w, height: 40.h, shape: BoxShape.circle),
              AppSpacing.w12,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bone(width: 120.w, height: 14.h),
                  AppSpacing.h8,
                  _Bone(width: 80.w, height: 12.h),
                ],
              ),
            ],
          ),
          AppSpacing.h12,
          _Bone(width: double.infinity, height: 14.h),
          AppSpacing.h8,
          _Bone(width: 240.w, height: 14.h),
          AppSpacing.h16,
          const Divider(color: AppColors.divider, thickness: 0.5),
        ],
      ],
    );
  }
}

// ── Reusable bone ──────────────────────────────────────────────────────────

class _Bone extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? radius;
  final BoxShape shape;

  const _Bone({
    required this.width,
    required this.height,
    this.radius,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Bone(
      width: width,
      height: height,
      borderRadius: shape == BoxShape.circle ? null : (radius ?? AppRadius.r8),
    );
  }
}
