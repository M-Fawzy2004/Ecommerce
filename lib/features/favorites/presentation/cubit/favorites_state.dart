part of 'favorites_cubit.dart';

class FavoritesState extends Equatable {
  final List<ProductEntity> favorites;

  const FavoritesState({this.favorites = const []});

  @override
  List<Object?> get props => [favorites];

  Map<String, dynamic> toMap() {
    return {
      'favorites': favorites.map((x) => ProductModel(
        id: x.id,
        name: x.name,
        description: x.description,
        image: x.image,
        price: x.price,
        oldPrice: x.oldPrice,
        hasFreeShipping: x.hasFreeShipping,
        rating: x.rating,
        reviewCount: x.reviewCount,
      ).toJson()).toList(),
    };
  }

  factory FavoritesState.fromMap(Map<String, dynamic> map) {
    return FavoritesState(
      favorites: List<ProductEntity>.from(
        (map['favorites'] as List<dynamic>).map(
          (x) => ProductModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
