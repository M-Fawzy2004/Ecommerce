import 'package:ecommerce_app/core/widgets/double_back_to_exit_wrapper.dart';
import 'package:flutter/material.dart';
import '../widgets/welcome_page_body.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoubleBackToExitWrapper(
      child: Scaffold(
        body: WelcomePageBody(),
      ),
    );
  }
}
