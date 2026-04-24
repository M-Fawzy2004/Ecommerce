import 'package:ecommerce_app/core/di/init_dependencies.dart';
import 'package:ecommerce_app/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:ecommerce_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:ecommerce_app/features/search/presentation/pages/search_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<SearchCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CategoriesCubit>()..getCategories(),
        ),
      ],
      child: const Scaffold(
        body: SafeArea(
          child: SearchPageBody(),
        ),
      ),
    );
  }
}
