import 'package:ecommerce_app/core/widgets/double_back_to_exit_wrapper.dart';
import 'package:ecommerce_app/features/cart/presentation/pages/cart_orders_page_body.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/features/checkout/presentation/cubit/orders_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartOrdersPage extends StatelessWidget {
  const CartOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitWrapper(
      child: Scaffold(
        body: SafeArea(
          child: BlocProvider(
            create: (context) => serviceLocator<OrdersCubit>(),
            child: const CartOrdersPageBody(),
          ),
        ),
      ),
    );
  }
}
