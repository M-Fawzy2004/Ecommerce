import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
}
