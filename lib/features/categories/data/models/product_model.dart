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
    // Support both remote (Supabase) and local (SharedPreferences) formats
    final double originalPrice = (json['price'] as num?)?.toDouble() ?? 0.0;
    final double? salePrice = (json['sale_price'] as num?)?.toDouble();

    // Handle nested join data from Supabase if present
    final dynamic summary = json['product_rating_summary'];
    double? remoteRating;
    int? remoteReviewCount;

    if (summary != null) {
      if (summary is List && summary.isNotEmpty) {
        remoteRating = (summary[0]['average_rating'] as num?)?.toDouble();
        remoteReviewCount = summary[0]['total_reviews'] as int?;
      } else if (summary is Map) {
        remoteRating = (summary['average_rating'] as num?)?.toDouble();
        remoteReviewCount = summary['total_reviews'] as int?;
      }
    }

    // If loading from local, price might already be the calculated price
    final double finalPrice = json.containsKey('final_price')
        ? (json['final_price'] as num).toDouble()
        : (salePrice ?? originalPrice);

    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      image:
          (json['main_image_url'] as String? ?? json['image'] as String?) ?? '',
      price: finalPrice,
      oldPrice: json.containsKey('old_price')
          ? (json['old_price'] as num?)?.toDouble()
          : (salePrice != null ? originalPrice : null),
      hasFreeShipping:
          (json['unlimited_stock'] as bool? ??
              json['has_free_shipping'] as bool?) ??
          false,
      rating: remoteRating ?? (json['rating'] as num?)?.toDouble(),
      reviewCount: remoteReviewCount ?? json['review_count'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'main_image_url': image,
      'final_price': price,
      'old_price': oldPrice,
      'has_free_shipping': hasFreeShipping,
      'unlimited_stock': hasFreeShipping, // For compatibility
      'rating': rating,
      'review_count': reviewCount,
    };
  }
}
