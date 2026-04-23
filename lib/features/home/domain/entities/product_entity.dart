import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String image;
  final double price;
  final double? oldPrice;
  final bool hasFreeShipping;
  final double? rating;
  final int? reviewCount;

  const ProductEntity({
    required this.id,
    required this.name,
    this.description,
    required this.image,
    required this.price,
    this.oldPrice,
    this.hasFreeShipping = false,
    this.rating,
    this.reviewCount,
  });

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    double? price,
    double? oldPrice,
    bool? hasFreeShipping,
    double? rating,
    int? reviewCount,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      hasFreeShipping: hasFreeShipping ?? this.hasFreeShipping,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        image,
        price,
        oldPrice,
        hasFreeShipping,
        rating,
        reviewCount,
      ];
}
