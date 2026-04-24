import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/checkout_address_section.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/checkout_payment_section.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/checkout_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutPageBody extends StatelessWidget {
  const CheckoutPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final selectedItems = state.items.where((i) => i.isSelected).toList();

        return Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  const AppBackButton(),
                  const Spacer(),
                  Text(
                    'cart.checkout'.tr(),
                    style: AppTextStyles.titleMedium
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  SizedBox(width: 40.w), // To balance the back button
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CheckoutAddressSection(),
                    AppSpacing.h24,
                    Text(
                      'Products (${selectedItems.length})',
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AppSpacing.h12,
                    ...selectedItems.map((item) => CheckoutProductItem(item: item)),
                    AppSpacing.h24,
                    const CheckoutPaymentSection(),
                  ],
                ),
              ),
            ),
            _buildBottomSummary(context, state),
          ],
        );
      },
    );
  }

  Widget _buildBottomSummary(BuildContext context, CartState state) {
    return Container(
      padding: EdgeInsets.all(20.r),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total amount',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              Text(
                '\$${state.total.toStringAsFixed(2)}',
                style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          AppSpacing.h20,
          AppButton(
            text: 'Checkout Now',
            onPressed: () {
              // Implementation for final checkout
            },
            backgroundColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
