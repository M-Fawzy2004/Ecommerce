import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/checkout_repository.dart';

class CreateOrderUseCase implements UseCase<OrderEntity, OrderEntity> {
  final CheckoutRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(OrderEntity order) async {
    return await repository.createOrder(order);
  }
}
