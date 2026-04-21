import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/core/widgets/double_back_to_exit_wrapper.dart';
import 'package:ecommerce_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'categories_page_body.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<CategoriesCubit>()..getCategories(),
      child: const DoubleBackToExitWrapper(
        child: Scaffold(
          body: SafeArea(
            child: CategoriesPageBody(),
          ),
        ),
      ),
    );
  }
}
