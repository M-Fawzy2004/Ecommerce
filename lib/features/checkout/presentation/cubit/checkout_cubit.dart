import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/process_payment_usecase.dart';
import '../../domain/usecases/confirm_order_usecase.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CreateOrderUseCase createOrderUseCase;
  final ProcessPaymentUseCase processPaymentUseCase;
  final ConfirmOrderUseCase confirmOrderUseCase;

  OrderEntity? currentOrder;

  CheckoutCubit({
    required this.createOrderUseCase,
    required this.processPaymentUseCase,
    required this.confirmOrderUseCase,
  }) : super(CheckoutInitial());

  Future<void> startCheckout({
    required String userId,
    required List<OrderItemEntity> items,
    required double totalAmount,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String paymentMethod,
    required String shippingAddress,
    double? latitude,
    double? longitude,
  }) async {
    emit(CheckoutLoading());

    final order = OrderEntity(
      id: const Uuid().v4(),
      orderCode: 'ORD-${const Uuid().v4().substring(0, 8).toUpperCase()}',
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      status: 'pending',
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress,
      latitude: latitude,
      longitude: longitude,
      phone: phone,
      createdAt: DateTime.now(),
    );

    final orderResult = await createOrderUseCase(order);

    orderResult.fold(
      (failure) => emit(PaymentFailure(failure.message)),
      (createdOrder) async {
        currentOrder = createdOrder;
        
        if (paymentMethod.toLowerCase() == 'cash' || paymentMethod.toLowerCase() == 'cod') {
          // Skip Paymob for Cash on Delivery, jump straight to success
          emit(PaymentSuccess(createdOrder));
          return;
        }

        final paymentResult = await processPaymentUseCase(ProcessPaymentParams(
          amount: totalAmount,
          currency: 'EGP',
          orderId: createdOrder.id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
        ));

        paymentResult.fold(
          (failure) => emit(PaymentFailure(failure.message)),
          (paymentKey) => emit(PaymentProcessing(paymentKey)),
        );
      },
    );
  }

  void onPaymentSuccess() {
    if (currentOrder != null) {
      emit(PaymentSuccess(currentOrder!));
    }
  }

  Future<void> confirmOrder() async {
    if (currentOrder == null) return;

    emit(CheckoutLoading());
    final result = await confirmOrderUseCase(currentOrder!.id);
    result.fold(
      (failure) => emit(PaymentFailure(failure.message)),
      (order) {
        currentOrder = order;
        emit(OrderConfirmed(order));
      },
    );
  }
}
