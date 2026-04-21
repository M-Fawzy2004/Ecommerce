import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/features/categories/presentation/pages/category_products_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/category_details_cubit.dart';
class CategoryProductsPage extends StatelessWidget {
  final String categoryName;
  final String categoryKey;

  const CategoryProductsPage({
    super.key,
    required this.categoryName,
    required this.categoryKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<CategoryDetailsCubit>()..getProducts(categoryKey),
      child: Scaffold(
        body: SafeArea(
          child: CategoryProductsBody(
            categoryName: categoryName,
            categoryKey: categoryKey,
          ),
        ),
      ),
    );
  }
}
