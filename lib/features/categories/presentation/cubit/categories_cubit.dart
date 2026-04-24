import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce_app/core/cubits/base_cubit.dart';

part 'categories_state.dart';

class CategoriesCubit extends BaseCubit<CategoriesState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoriesCubit({
    required GetCategoriesUseCase getCategoriesUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        super(CategoriesInitial());

  Future<void> getCategories() async {
    emit(CategoriesLoading());

    final result = await _getCategoriesUseCase(const NoParams());

    result.fold(
      (failure) => emit(CategoriesError(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }
}
