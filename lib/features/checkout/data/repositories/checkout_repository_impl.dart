import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/paymob_remote_data_source.dart';
import '../datasources/supabase_data_source.dart';
import '../models/order_model.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final PaymobRemoteDataSource paymobDataSource;
  final SupabaseDataSource supabaseDataSource;

  CheckoutRepositoryImpl({
    required this.paymobDataSource,
    required this.supabaseDataSource,
  });

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) async {
    try {
      final orderModel = OrderModel.fromEntity(order);
      final result = await supabaseDataSource.createOrder(orderModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getPaymobPaymentKey({
    required double amount,
    required String currency,
    required String orderId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    try {
      final key = await paymobDataSource.getPaymentKey(
        amount: amount,
        currency: currency,
        orderId: orderId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );
      return Right(key);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> confirmOrder(String orderId) async {
    try {
      final result = await supabaseDataSource.confirmOrder(orderId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<OrderEntity>>> watchOrders(String userId) {
    return supabaseDataSource.streamOrders(userId).map<Either<Failure, List<OrderEntity>>>(
      (models) => Right(models),
    ).handleError(
      (error) {},
      test: (error) => false, // Let errors pass through to onError in listen
    );
  }
}
