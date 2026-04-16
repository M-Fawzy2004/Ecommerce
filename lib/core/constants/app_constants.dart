/// Central place for all compile-time constants used across the app.
abstract class AppConstants {
  // ── API ───────────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://api.ecommerce-app.com/v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const String contentTypeJson = 'application/json';

  // ── Secure Storage keys ───────────────────────────────────────────────────
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  // ── SharedPreferences keys ────────────────────────────────────────────────
  static const String onboardingKey = 'onboarding_done';
  static const String localeKey = 'app_locale';

  // ── Pagination ────────────────────────────────────────────────────────────
  static const int defaultPageSize = 20;

  // ── Supported locales ─────────────────────────────────────────────────────
  static const String localeEN = 'en';
  static const String localeAR = 'ar';
}
