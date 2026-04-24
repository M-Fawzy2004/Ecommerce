import 'package:ecommerce_app/core/widgets/double_back_to_exit_wrapper.dart';
import 'package:ecommerce_app/features/cart/presentation/pages/cart_orders_page_body.dart';
import 'package:flutter/material.dart';

class CartOrdersPage extends StatelessWidget {
  const CartOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoubleBackToExitWrapper(
      child: Scaffold(
        body: SafeArea(
          child: CartOrdersPageBody(),
        ),
      ),
    );
  }
}
