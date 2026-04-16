import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base use-case contract for async use-cases that accept typed [Params].
///
/// Usage:
/// ```dart
/// class GetProductsUseCase extends UseCase<List<ProductEntity>, NoParams> { … }
/// ```
// ignore: avoid_types_as_parameter_names
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use when the use-case needs no parameters.
class NoParams {
  const NoParams();
}
