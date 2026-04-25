import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/core/di/init_dependencies.dart';
import '../cubit/checkout_cubit.dart';
import 'checkout_page_body.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<CheckoutCubit>(),
      child: const CheckoutPageBody(),
    );
  }
}
