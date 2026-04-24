import 'package:ecommerce_app/features/cart/presentation/pages/checkout_page_body.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(child: CheckoutPageBody()),
    );
  }
}
