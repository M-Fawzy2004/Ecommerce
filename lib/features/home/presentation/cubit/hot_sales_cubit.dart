import '../../domain/entities/product_entity.dart';
import '../../data/repositories/home_repository_impl.dart';
import 'package:ecommerce_app/core/cubits/base_cubit.dart';

abstract class HotSalesState {}

class HotSalesInitial extends HotSalesState {}
class HotSalesLoading extends HotSalesState {}
class HotSalesLoaded extends HotSalesState {
  final List<ProductEntity> products;
  final bool hasReachedMax;
  HotSalesLoaded(this.products, {this.hasReachedMax = false});
}
class HotSalesError extends HotSalesState {
  final String message;
  HotSalesError(this.message);
}

class HotSalesCubit extends BaseCubit<HotSalesState> {
  final HomeRepository repository;
  static const int pageSize = 5;

  HotSalesCubit(this.repository) : super(HotSalesInitial());

  Future<void> getHotSales({bool isRefresh = false}) async {
    if (!isRefresh) emit(HotSalesLoading());
    final result = await repository.getHotSales(0, pageSize - 1);
    result.fold(
      (failure) => emit(HotSalesError(failure.message)),
      (products) => emit(HotSalesLoaded(products, hasReachedMax: products.length < pageSize)),
    );
  }

  Future<void> loadMore() async {
    if (state is! HotSalesLoaded) return;
    final currentState = state as HotSalesLoaded;
    if (currentState.hasReachedMax) return;

    final result = await repository.getHotSales(
      currentState.products.length,
      currentState.products.length + pageSize - 1,
    );

    result.fold(
      (failure) => emit(HotSalesError(failure.message)),
      (newProducts) {
        if (newProducts.isEmpty) {
          emit(HotSalesLoaded(currentState.products, hasReachedMax: true));
        } else {
          emit(HotSalesLoaded(
            currentState.products + newProducts,
            hasReachedMax: newProducts.length < pageSize,
          ));
        }
      },
    );
  }
}
