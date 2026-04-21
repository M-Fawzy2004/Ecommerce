import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import '../entities/category_entity.dart';
import '../usecases/get_products_by_category_usecase.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(CategoryProductsParams params);
}
