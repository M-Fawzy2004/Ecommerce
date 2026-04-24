import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckoutPaymentSection extends StatelessWidget {
  const CheckoutPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'payment.title'.tr(),
              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            AppSpacing.h12,
            _buildPaymentMethod(
              context,
              id: 'cash',
              title: 'payment.cash_on_delivery'.tr(),
              subtitle: 'payment.cash_desc'.tr(),
              icon: Icons.payments_outlined,
              isSelected: state.selectedPaymentMethod == 'cash',
            ),
            AppSpacing.h12,
            _buildPaymentMethod(
              context,
              id: 'mastercard',
              title: 'payment.mastercard'.tr(),
              subtitle: '4827 **** **** 7424',
              imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png',
              isSelected: state.selectedPaymentMethod == 'mastercard',
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentMethod(
    BuildContext context, {
    required String id,
    required String title,
    required String subtitle,
    IconData? icon,
    String? imageUrl,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => context.read<CartCubit>().updatePaymentMethod(id),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width: 30.w,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.payment,
                          color: AppColors.primary,
                          size: 24.sp,
                        ),
                      )
                    : Icon(icon, color: AppColors.primary, size: 24.sp),
              ),
            ),
            AppSpacing.w16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              width: 24.r,
              height: 24.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.gray,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
