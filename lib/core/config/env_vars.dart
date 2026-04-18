import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized environment variables management.
/// Ensures all sensitive keys are accessed from the .env file.
abstract class EnvVars {
  static String get supabaseUrl => _get('SUPABASE_URL');
  static String get supabaseAnonKey => _get('SUPABASE_ANON_KEY');

  static String _get(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception('Environment variable $key is missing! Check your .env file.');
    }
    return value;
  }
}
