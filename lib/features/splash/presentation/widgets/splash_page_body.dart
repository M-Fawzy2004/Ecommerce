import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

/// SplashPageBody: Contains the actual UI and logic for the splash screen.
/// Max 120 lines as per project rules.
class SplashPageBody extends StatefulWidget {
  const SplashPageBody({super.key});

  @override
  State<SplashPageBody> createState() => _SplashPageBodyState();
}

class _SplashPageBodyState extends State<SplashPageBody> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // Simulate initial loading or auth check
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      // For now, just stay on splash or go to home if implemented
      // context.go(AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FlutterLogo(size: 100),
          const SizedBox(height: 24),
          Text(
            'E-commerce App',
            style: AppTextStyles.headlineLarge,
          ),
        ],
      ),
    );
  }
}
