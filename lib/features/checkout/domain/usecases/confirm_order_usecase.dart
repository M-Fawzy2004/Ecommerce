import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/checkout_repository.dart';

class ConfirmOrderUseCase implements UseCase<OrderEntity, String> {
  final CheckoutRepository repository;

  ConfirmOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(String orderId) async {
    return await repository.confirmOrder(orderId);
  }
}
