import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/checkout_repository.dart';
import 'orders_state.dart';

export 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final CheckoutRepository repository;
  StreamSubscription? _subscription;

  OrdersCubit({required this.repository}) : super(OrdersInitial());

  void watchOrders(String userId) {
    emit(OrdersLoading());
    _subscription?.cancel();
    
    _subscription = repository.watchOrders(userId).listen(
      (result) {
        result.fold(
          (failure) => emit(OrdersError(failure.message)),
          (orders) => emit(OrdersLoaded(orders)),
        );
      },
      onError: (error) {
        emit(OrdersError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
