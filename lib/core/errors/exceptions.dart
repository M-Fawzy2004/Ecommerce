
/// Thrown when a server responds with a non-2xx status code.
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});
}

/// Thrown when there is no internet connectivity.
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);
}

/// Thrown when local cache read/write fails.
class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error.']);
}
