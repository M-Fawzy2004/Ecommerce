import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/app_constants.dart';

/// Configured [Dio] HTTP client for the entire application.
class ApiClient {
  late final Dio _dio;

  ApiClient({String? accessToken}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': AppConstants.contentTypeJson,
          'Accept': AppConstants.contentTypeJson,
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      ),
    )..interceptors.addAll([
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      ]);
  }

  Dio get dio => _dio;

  /// Updates the auth token header at runtime (e.g., after login).
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clears the auth token header (e.g., on logout).
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
