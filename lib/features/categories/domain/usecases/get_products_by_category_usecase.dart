import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/categories_repository.dart';

class GetProductsByCategoryUseCase implements UseCase<List<ProductEntity>, CategoryProductsParams> {
  final CategoriesRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(CategoryProductsParams params) async {
    return await repository.getProductsByCategory(params);
  }
}

class CategoryProductsParams {
  final String categoryKey;
  final int from;
  final int to;

  CategoryProductsParams({
    required this.categoryKey,
    required this.from,
    required this.to,
  });
}
