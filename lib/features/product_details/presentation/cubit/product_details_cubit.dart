import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductDetailsCubit({required this.getProductDetailsUseCase}) : super(ProductDetailsInitial());

  Future<void> getProductDetails(String productId) async {
    emit(ProductDetailsLoading());
    final result = await getProductDetailsUseCase(productId);
    result.fold(
      (failure) => emit(ProductDetailsError(failure.message)),
      (product) => emit(ProductDetailsLoaded(product)),
    );
  }
}
