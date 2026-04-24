import 'package:ecommerce_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/signup_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/verification_page.dart';
import 'package:ecommerce_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:ecommerce_app/features/categories/presentation/pages/categories_page.dart';
import 'package:ecommerce_app/features/categories/presentation/pages/category_products_page.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/home/presentation/pages/home_page.dart';
import 'package:ecommerce_app/features/main/presentation/pages/main_wrapper_page.dart';
import 'package:ecommerce_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:ecommerce_app/features/cart/presentation/pages/cart_orders_page.dart';
import 'package:ecommerce_app/features/profile/presentation/pages/profile_page.dart';
import 'package:ecommerce_app/features/favorites/presentation/pages/favorites_page.dart';
import 'package:ecommerce_app/features/search/presentation/pages/search_page.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/product_details/presentation/pages/product_details_page.dart';

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
  static const String cartOrders = '/cart-orders';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String favorites = '/favorites';

  static const String categoryProducts = '/category-products';
  static const String productDetails = '/product-details';

  // ── Configuration ────────────────────────────────────────────────────────
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashPage()),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: auth, builder: (context, state) => const WelcomePage()),
      GoRoute(path: login, builder: (context, state) => const LoginPage()),
      GoRoute(path: signup, builder: (context, state) => const SignupPage()),
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
          final extra = state.extra;
          final String categoryName =
              (extra is Map ? extra['name'] : null)?.toString() ?? 'Category';
          final String categoryKey =
              (extra is Map ? extra['key'] : null)?.toString() ?? '';
          return CategoryProductsPage(
            categoryName: categoryName,
            categoryKey: categoryKey,
          );
        },
      ),
      GoRoute(
        path: productDetails,
        builder: (context, state) {
          final product = state.extra as ProductEntity;
          return ProductDetailsPage(product: product);
        },
      ),
      GoRoute(
        path: favorites,
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(path: search, builder: (context, state) => const SearchPage()),
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
                path: cartOrders,
                builder: (context, state) => const CartOrdersPage(),
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
