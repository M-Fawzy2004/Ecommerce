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
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getHotSales(from, to);
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }
}
