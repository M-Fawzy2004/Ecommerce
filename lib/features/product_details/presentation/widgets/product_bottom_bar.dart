import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductBottomBar extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCart;

  const ProductBottomBar({
    super.key,
    required this.price,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h + ScreenUtil().bottomBarHeight),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.06),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "navbar.cart".tr(), // Or a generic 'Total'
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
                Text(
                  currencyFormat.format(price),
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.w16,
          Expanded(
            flex: 3,
            child: AppButton(
              text: "product.add_to_cart".tr(),
              onPressed: onAddToCart,
            ),
          ),
        ],
      ),
    );
  }
}
