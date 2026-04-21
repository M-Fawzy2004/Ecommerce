import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import '../entities/product_details_entity.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(String productId);
}
