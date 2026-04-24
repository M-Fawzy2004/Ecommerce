import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/ui/toast/app_toast.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartSummary extends StatefulWidget {
  const CartSummary({super.key});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.items.isEmpty) return const SizedBox.shrink();

        if (state.promoCode != null && _promoController.text.isEmpty) {
          _promoController.text = state.promoCode!;
        }

        return Container(
          padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Promo Code
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                decoration: BoxDecoration(
                  color: AppColors.gray,
                  borderRadius: BorderRadius.circular(15.r),
                  border: state.promoCode != null
                      ? Border.all(color: Colors.green, width: 1)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      color: state.promoCode != null
                          ? Colors.green
                          : AppColors.textHint,
                      size: 20.sp,
                    ),
                    AppSpacing.w12,
                    Expanded(
                      child: TextField(
                        controller: _promoController,
                        onSubmitted: (value) {
                          context.read<CartCubit>().applyPromoCode(value);
                          if (value == 'MOFAWZY12') {
                            AppToast.success(
                              context,
                              message: 'cart.promo_applied'.tr(),
                            );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'cart.promo_hint'.tr(),
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textHint,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        state.promoCode != null
                            ? Icons.check_circle
                            : Icons.arrow_forward_ios,
                        color: state.promoCode != null
                            ? Colors.green
                            : AppColors.textHint,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        context.read<CartCubit>().applyPromoCode(
                          _promoController.text,
                        );
                        if (_promoController.text == 'MOFAWZY12') {
                          AppToast.success(
                            context,
                            message: 'cart.promo_applied'.tr(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (state.promoCode != null) ...[
                AppSpacing.h8,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'cart.promo_applied'.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
              AppSpacing.h12,
              _buildRow(
                'cart.subtotal'.tr(),
                '\$${state.subtotal.toStringAsFixed(2)}',
              ),
              if (state.discountAmount > 0) ...[
                AppSpacing.h4,
                _buildRow(
                  'cart.discount'.tr(),
                  '-\$${state.discountAmount.toStringAsFixed(2)}',
                  valueColor: Colors.green,
                ),
              ],
              AppSpacing.h4,
              _buildRow(
                'cart.shipping'.tr(),
                '\$${state.shipping.toStringAsFixed(2)}',
              ),
              AppSpacing.h8,
              const Divider(color: AppColors.divider, thickness: 1),
              AppSpacing.h8,
              _buildRow(
                'cart.total'.tr(),
                '\$${state.total.toStringAsFixed(2)}',
                isTotal: true,
              ),
              AppSpacing.h16,
              AppButton(
                text: 'cart.checkout'.tr(),
                onPressed: () {},
                backgroundColor: AppColors.primary,
              ),
              AppSpacing.h56,
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 20.sp : 16.sp,
          ),
        ),
      ],
    );
  }
}
