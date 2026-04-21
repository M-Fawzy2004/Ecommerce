import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecase/usecase.dart';
import '../entities/product_details_entity.dart';
import '../repositories/product_details_repository.dart';

class GetProductDetailsUseCase implements UseCase<ProductDetailsEntity, String> {
  final ProductDetailsRepository repository;

  GetProductDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ProductDetailsEntity>> call(String params) async {
    return await repository.getProductDetails(params);
  }
}
