import 'package:ecommerce_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/signup_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/verification_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:ecommerce_app/features/categories/presentation/pages/categories_page.dart';
import 'package:ecommerce_app/features/categories/presentation/pages/category_products_page.dart';
import 'package:ecommerce_app/features/home/presentation/pages/home_page.dart';
import 'package:ecommerce_app/features/main/presentation/pages/main_wrapper_page.dart';
import 'package:ecommerce_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:ecommerce_app/features/orders/presentation/pages/orders_page.dart';
import 'package:ecommerce_app/features/profile/presentation/pages/profile_page.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

/// Centralized route management using GoRouter.
abstract class AppRouter {
  // ── Route Paths ──────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verification = '/verification';
  static const String forgotPassword = '/forgot-password';
  
  static const String home = '/home';
  static const String categories = '/categories';
  static const String orders = '/orders';
  static const String profile = '/profile';

  static const String categoryProducts = '/category-products';

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
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: verification,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return VerificationPage(email: email);
        },
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: categoryProducts,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          final categoryName = extra['name'] ?? 'Category';
          final categoryKey = extra['key'] ?? '';
          return CategoryProductsPage(
            categoryName: categoryName,
            categoryKey: categoryKey,
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapperPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: categories,
                builder: (context, state) => const CategoriesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: orders,
                builder: (context, state) => const OrdersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
