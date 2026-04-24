import 'package:dartz/dartz.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product_entity.dart';
import '../datasources/home_remote_data_source.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ProductEntity>>> getHotSales(int from, int to);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> getHotSales(int from, int to) async {
    try {
      final products = await remoteDataSource.getHotSales(from, to);
      return Right(products);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }
}
