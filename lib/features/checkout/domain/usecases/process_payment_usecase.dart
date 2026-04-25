import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/checkout_repository.dart';

class ProcessPaymentParams {
  final double amount;
  final String currency;
  final String orderId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  ProcessPaymentParams({
    required this.amount,
    required this.currency,
    required this.orderId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });
}

class ProcessPaymentUseCase implements UseCase<String, ProcessPaymentParams> {
  final CheckoutRepository repository;

  ProcessPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(ProcessPaymentParams params) async {
    return await repository.getPaymobPaymentKey(
      amount: params.amount,
      currency: params.currency,
      orderId: params.orderId,
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phone: params.phone,
    );
  }
}
