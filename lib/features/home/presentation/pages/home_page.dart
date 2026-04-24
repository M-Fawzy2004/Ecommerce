import 'package:ecommerce_app/core/widgets/double_back_to_exit_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/features/home/presentation/cubit/hot_sales_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_page_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitWrapper(
      child: BlocProvider(
        create: (context) => serviceLocator<HotSalesCubit>()..getHotSales(),
        child: const Scaffold(
          body: SafeArea(
            child: HomePageBody(),
          ),
        ),
      ),
    );
  }
}
