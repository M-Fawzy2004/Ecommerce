import 'package:ecommerce_app/features/search/domain/repositories/search_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _repository;

  SearchCubit(this._repository) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    final result = await _repository.searchProducts(query);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (products) => emit(SearchLoaded(products, query: query)),
    );
  }
  
  void clearSearch() {
    emit(SearchInitial());
  }
}
