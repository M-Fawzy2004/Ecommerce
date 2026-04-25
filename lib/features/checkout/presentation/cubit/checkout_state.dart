import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();
  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class PaymentProcessing extends CheckoutState {
  final String paymentKey;
  const PaymentProcessing(this.paymentKey);
  @override
  List<Object?> get props => [paymentKey];
}

class PaymentSuccess extends CheckoutState {
  final OrderEntity order;
  const PaymentSuccess(this.order);
  @override
  List<Object?> get props => [order];
}

class PaymentFailure extends CheckoutState {
  final String message;
  const PaymentFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class OrderConfirmed extends CheckoutState {
  final OrderEntity order;
  const OrderConfirmed(this.order);
  @override
  List<Object?> get props => [order];
}
