import 'package:flutter/material.dart';
import '../widgets/category_products_body.dart';

class CategoryProductsPage extends StatelessWidget {
  final String categoryName;

  const CategoryProductsPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CategoryProductsBody(categoryName: categoryName),
      ),
    );
  }
}
