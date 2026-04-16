import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

/// Centralized route management using GoRouter.
abstract class AppRouter {
  // ── Route Paths ──────────────────────────────────────────────────────────
  static const String splash = '/';

  // ── Configuration ────────────────────────────────────────────────────────
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
    ],
  );
}
