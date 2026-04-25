import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_entity.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order);
  Future<Either<Failure, String>> getPaymobPaymentKey({
    required double amount,
    required String currency,
    required String orderId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  });
  Future<Either<Failure, OrderEntity>> confirmOrder(String orderId);
}
