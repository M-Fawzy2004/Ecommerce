import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    super.description,
    required super.image,
    required super.price,
    super.oldPrice,
    super.hasFreeShipping,
    super.rating,
    super.reviewCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final double originalPrice = (json['price'] as num?)?.toDouble() ?? 0.0;
    final double? salePrice = (json['sale_price'] as num?)?.toDouble();

    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['main_image_url'] as String? ?? '',
      price: salePrice ?? originalPrice,
      oldPrice: salePrice != null ? originalPrice : null,
      hasFreeShipping: json['unlimited_stock'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'main_image_url': image,
      'price': price,
      'oldPrice': oldPrice,
      'is_featured': hasFreeShipping,
      'rating': rating,
      'review_count': reviewCount,
    };
  }
}
