import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/core/errors/exceptions.dart';
import '../../domain/repositories/product_details_repository.dart'; // Wait, I put the interface in the usecase file. I should move it.
import '../../domain/entities/product_details_entity.dart';
import '../datasources/product_details_remote_data_source.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(String productId) async {
    try {
        final result = await remoteDataSource.getProductDetails(productId);
        return Right(result);
      } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
