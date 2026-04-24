import '../../domain/usecases/get_product_details_usecase.dart';
import 'product_details_state.dart';
import 'package:ecommerce_app/core/cubits/base_cubit.dart';

class ProductDetailsCubit extends BaseCubit<ProductDetailsState> {
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
