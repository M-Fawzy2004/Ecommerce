import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import 'category_details_state.dart';

class CategoryDetailsCubit extends Cubit<CategoryDetailsState> {
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;
  static const int _pageSize = 10;
  int _currentPage = 0;

  CategoryDetailsCubit({required this.getProductsByCategoryUseCase}) : super(CategoryDetailsInitial());

  Future<void> getProducts(String categoryKey, {bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 0;
    } else {
      emit(CategoryDetailsLoading());
    }

    final result = await getProductsByCategoryUseCase(CategoryProductsParams(
      categoryKey: categoryKey,
      from: 0,
      to: _pageSize - 1,
    ));

    result.fold(
      (failure) => emit(CategoryDetailsError(failure.message)),
      (products) {
        _currentPage = 0;
        emit(CategoryDetailsLoaded(
          products: products,
          hasReachedMax: products.length < _pageSize,
        ));
      },
    );
  }

  Future<void> loadMoreProducts(String categoryKey) async {
    final currentState = state;
    if (currentState is! CategoryDetailsLoaded || currentState.isPaginationLoading || currentState.hasReachedMax) {
      return;
    }

    emit(currentState.copyWith(isPaginationLoading: true));

    final nextPage = _currentPage + 1;
    final result = await getProductsByCategoryUseCase(CategoryProductsParams(
      categoryKey: categoryKey,
      from: nextPage * _pageSize,
      to: (nextPage + 1) * _pageSize - 1,
    ));

    result.fold(
      (failure) => emit(currentState.copyWith(
        isPaginationLoading: false,
        paginationError: failure.message,
      )),
      (newProducts) {
        if (newProducts.isEmpty) {
          emit(currentState.copyWith(
            isPaginationLoading: false,
            hasReachedMax: true,
          ));
        } else {
          _currentPage = nextPage;
          emit(currentState.copyWith(
            products: [...currentState.products, ...newProducts],
            isPaginationLoading: false,
            hasReachedMax: newProducts.length < _pageSize,
          ));
        }
      },
    );
  }
}
