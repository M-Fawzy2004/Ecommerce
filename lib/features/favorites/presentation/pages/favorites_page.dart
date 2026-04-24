import 'package:ecommerce_app/features/favorites/presentation/pages/favorites_page_body.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FavoritesPageBody(),
    );
  }
}
