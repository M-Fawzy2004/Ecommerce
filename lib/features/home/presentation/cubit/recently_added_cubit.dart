import '../../domain/entities/product_entity.dart';
import '../../data/repositories/home_repository_impl.dart';
import 'package:ecommerce_app/core/cubits/base_cubit.dart';

abstract class RecentlyAddedState {}

class RecentlyAddedInitial extends RecentlyAddedState {}
class RecentlyAddedLoading extends RecentlyAddedState {}
class RecentlyAddedLoaded extends RecentlyAddedState {
  final List<ProductEntity> products;
  final bool hasReachedMax;
  RecentlyAddedLoaded(this.products, {this.hasReachedMax = false});
}
class RecentlyAddedError extends RecentlyAddedState {
  final String message;
  RecentlyAddedError(this.message);
}

class RecentlyAddedCubit extends BaseCubit<RecentlyAddedState> {
  final HomeRepository repository;
  static const int pageSize = 5;

  RecentlyAddedCubit(this.repository) : super(RecentlyAddedInitial());

  Future<void> getRecentlyAdded({bool isRefresh = false}) async {
    if (!isRefresh) emit(RecentlyAddedLoading());
    final result = await repository.getRecentlyAddedProducts(0, pageSize - 1);
    result.fold(
      (failure) => emit(RecentlyAddedError(failure.message)),
      (products) => emit(RecentlyAddedLoaded(products, hasReachedMax: products.length < pageSize)),
    );
  }

  Future<void> loadMore() async {
    if (state is! RecentlyAddedLoaded) return;
    final currentState = state as RecentlyAddedLoaded;
    if (currentState.hasReachedMax) return;

    final result = await repository.getRecentlyAddedProducts(
      currentState.products.length,
      currentState.products.length + pageSize - 1,
    );

    result.fold(
      (failure) => emit(RecentlyAddedError(failure.message)),
      (newProducts) {
        if (newProducts.isEmpty) {
          emit(RecentlyAddedLoaded(currentState.products, hasReachedMax: true));
        } else {
          emit(RecentlyAddedLoaded(
            currentState.products + newProducts,
            hasReachedMax: newProducts.length < pageSize,
          ));
        }
      },
    );
  }
}
