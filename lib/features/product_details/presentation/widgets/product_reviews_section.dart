import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_radius.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/features/product_details/domain/entities/product_review_entity.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/reviews_cubit.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/reviews_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'reviews/add_review_box.dart';
import 'reviews/rating_breakdown.dart';
import 'reviews/review_item.dart';
import 'reviews/reviews_skeleton.dart';

class ProductReviewsSection extends StatelessWidget {
  final String productId;

  const ProductReviewsSection({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewsCubit, ReviewsState>(
      listenWhen: (_, s) => s is ReviewsError,
      listener: (context, state) {
        if (state is ReviewsError) {
          AppToast.error(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is ReviewsLoading || state is ReviewsInitial) {
          return const ReviewsSkeleton();
        }
        if (state is ReviewsLoaded) {
          return _ReviewsContent(productId: productId, state: state);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ReviewsContent extends StatelessWidget {
  final String productId;
  final ReviewsLoaded state;

  const _ReviewsContent({required this.productId, required this.state});

  @override
  Widget build(BuildContext context) {
    final otherReviews = state.reviews
        .where((r) => r.id != state.myReview?.id)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(state.summary),
        AppSpacing.h16,
        RatingBreakdown(summary: state.summary),
        AppSpacing.h20,
        if (state.myReview != null)
          _MyReviewItem(
            review: state.myReview!,
            productId: productId,
            isDeleting: state.isDeleting,
          )
        else
          AddReviewBox(productId: productId, isSubmitting: state.isSubmitting),
        AppSpacing.h24,
        if (otherReviews.isEmpty && state.myReview == null)
          _buildEmptyState()
        else ...[
          ...otherReviews.map((r) => ReviewItem(review: r)),
          _buildPagination(context),
        ],
      ],
    );
  }

  Widget _buildHeader(ProductRatingSummary summary) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'product.reviews'.tr(),
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' (${summary.totalReviews})',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (state.hasMore) {
      return Center(
        child: TextButton.icon(
          onPressed: () => context.read<ReviewsCubit>().loadMore(productId),
          icon: const Icon(Icons.expand_more_rounded, color: AppColors.primary),
          label: Text(
            'product.load_more_reviews'.tr(),
            style: const TextStyle(color: AppColors.primary),
          ),
        ),
      );
    }
    if (state.reviews.length > 2) {
      return Center(
        child: TextButton.icon(
          onPressed: () => context.read<ReviewsCubit>().showLess(productId),
          icon: const Icon(
            Icons.expand_less_rounded,
            color: AppColors.textHint,
          ),
          label: Text(
            'product.show_less_reviews'.tr(),
            style: const TextStyle(color: AppColors.textHint),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              color: AppColors.textHint,
              size: 48.sp,
            ),
            AppSpacing.h12,
            Text(
              'product.no_reviews_yet'.tr(),
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyReviewItem extends StatelessWidget {
  final ProductReviewEntity review;
  final String productId;
  final bool isDeleting;

  const _MyReviewItem({
    required this.review,
    required this.productId,
    required this.isDeleting,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: AppRadius.r8,
          ),
          child: Text(
            "product.your_review".tr(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppSpacing.h8,
        Stack(
          children: [
            ReviewItem(review: review, isPersonal: true),
            Positioned(
              top: 8.r,
              right: 8.r,
              child: isDeleting
                  ? Container(
                      padding: EdgeInsets.all(10.r),
                      child: SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.error,
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        final userId =
                            Supabase.instance.client.auth.currentUser?.id;
                        if (userId != null) {
                          context.read<ReviewsCubit>().deleteMyReview(
                            productId: productId,
                            userId: userId,
                          );
                        }
                      },
                      icon: Icon(
                        IconlyLight.delete,
                        color: AppColors.error,
                        size: 20.sp,
                      ),
                      tooltip: "product.delete_review".tr(),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
