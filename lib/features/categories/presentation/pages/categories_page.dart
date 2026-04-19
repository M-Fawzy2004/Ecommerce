import 'package:ecommerce_app/core/widgets/double_back_to_exit_wrapper.dart';
import 'package:flutter/material.dart';
import 'categories_page_body.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoubleBackToExitWrapper(
      child: Scaffold(
        body: SafeArea(
          child: CategoriesPageBody(),
        ),
      ),
    );
  }
}
