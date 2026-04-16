import 'package:equatable/equatable.dart';

/// Base class for all domain-layer failures.
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Returned when a server / API call fails (4xx, 5xx, parse errors).
final class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

/// Returned when the device has no internet connection.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// Returned when reading/writing to local storage fails.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local cache error.']);
}

/// Returned for unexpected or unclassified errors.
final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
