import 'package:flutter/material.dart';
import '../widgets/splash_page_body.dart';

/// SplashPage: Entry point scaffold for the splash screen.
/// Following the Page/Body pattern from project rules.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashPageBody(),
    );
  }
}
