import 'package:ecommerce_app/features/categories/data/models/product_model.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'favorites_state.dart';

class FavoritesCubit extends HydratedCubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesState());

  void toggleFavorite(ProductEntity product) {
    final currentFavorites = List<ProductEntity>.from(state.favorites);
    final isFavorite = currentFavorites.any((element) => element.id == product.id);

    if (isFavorite) {
      currentFavorites.removeWhere((element) => element.id == product.id);
    } else {
      currentFavorites.add(product);
    }

    if (!isClosed) {
      emit(FavoritesState(favorites: currentFavorites));
    }
  }

  bool isFavorite(String productId) {
    return state.favorites.any((element) => element.id == productId);
  }

  @override
  FavoritesState? fromJson(Map<String, dynamic> json) {
    try {
      return FavoritesState.fromMap(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(FavoritesState state) {
    return state.toMap();
  }
}
