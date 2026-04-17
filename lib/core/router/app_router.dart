import 'package:ecommerce_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:ecommerce_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

/// Centralized route management using GoRouter.
abstract class AppRouter {
  // ── Route Paths ──────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';

  // ── Configuration ────────────────────────────────────────────────────────
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: auth,
        builder: (context, state) => const WelcomePage(),
      ),
    ],
  );
}
