import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:ecommerce_app/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) async {
    try {
      final products = await remoteDataSource.searchProducts(query);
      return Right(products);
    } catch (e) {
      return const Left(ServerFailure('Search failed. Please try again.'));
    }
  }
}
