import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_radius.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/features/product_details/presentation/cubit/reviews_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddReviewBox extends StatefulWidget {
  final String productId;
  final bool isSubmitting;

  const AddReviewBox({super.key, required this.productId, required this.isSubmitting});

  @override
  State<AddReviewBox> createState() => _AddReviewBoxState();
}

class _AddReviewBoxState extends State<AddReviewBox> {
  int _selectedRating = 0;
  final _controller = TextEditingController();
  bool _expanded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      AppToast.error(context, message: 'auth.login'.tr());
      return;
    }
    if (_selectedRating == 0) {
      AppToast.error(context, message: 'product.select_rating'.tr());
      return;
    }
    if (_controller.text.trim().length < 5) {
      AppToast.error(context, message: 'product.comment_too_short'.tr());
      return;
    }
    context.read<ReviewsCubit>().submitReview(
          productId: widget.productId,
          userId: user.id,
          userName: user.userMetadata?['full_name'] as String? ??
              user.email?.split('@').first ??
              'Anonymous',
          rating: _selectedRating,
          comment: _controller.text.trim(),
        );
    setState(() {
      _selectedRating = 0;
      _controller.clear();
      _expanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.5),
        borderRadius: AppRadius.r16,
        border: Border.all(color: AppColors.divider, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Star selector
          Row(
            children: [
              Text('product.rate_product'.tr(),
                  style: AppTextStyles.labelMedium),
              AppSpacing.w12,
              Row(
                children: List.generate(5, (i) {
                  final star = i + 1;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedRating = star;
                      _expanded = true;
                    }),
                    child: Icon(
                      star <= _selectedRating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: AppColors.star,
                      size: 28.sp,
                    ),
                  );
                }),
              ),
            ],
          ),

          // Comment box (appears after rating is selected)
          if (_expanded) ...[
            AppSpacing.h16,
            TextField(
              controller: _controller,
              maxLines: 3,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'product.share_thoughts'.tr(),
                hintStyle: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.r12,
                  borderSide: BorderSide(color: AppColors.divider, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.r12,
                  borderSide: BorderSide(color: AppColors.divider, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.r12,
                  borderSide:
                      BorderSide(color: AppColors.primary, width: 1.5.w),
                ),
                contentPadding: EdgeInsets.all(12.r),
              ),
            ),
            AppSpacing.h12,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.isSubmitting ? null : () => _submit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.r12),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  elevation: 0,
                ),
                child: widget.isSubmitting
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          color: AppColors.surface,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'product.submit_review'.tr(),
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
