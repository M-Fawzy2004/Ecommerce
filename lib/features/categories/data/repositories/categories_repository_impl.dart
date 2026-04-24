import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/categories/domain/usecases/get_products_by_category_usecase.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_remote_data_source.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CategoriesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
        final remoteCategories = await remoteDataSource.getCategories();
        return Right(remoteCategories);
      } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(CategoryProductsParams params) async {
    try {
        final remoteProducts = await remoteDataSource.getProductsByCategory(
          params.categoryKey,
          params.from,
          params.to,
        );
        return Right(remoteProducts);
      } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
