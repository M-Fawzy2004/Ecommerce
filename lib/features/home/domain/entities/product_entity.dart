import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final double price;
  final bool hasFreeShipping;
  final double? rating;
  final int? reviewCount;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.hasFreeShipping = false,
    this.rating,
    this.reviewCount,
  });

  @override
  List<Object?> get props => [id, name, image, price, hasFreeShipping, rating];
}
