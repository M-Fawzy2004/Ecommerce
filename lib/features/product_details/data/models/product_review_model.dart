import 'package:ecommerce_app/features/product_details/domain/entities/product_review_entity.dart';

class ProductReviewModel extends ProductReviewEntity {
  const ProductReviewModel({
    required super.id,
    required super.productId,
    required super.userId,
    required super.userName,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'user_id': userId,
        'user_name': userName,
        'rating': rating,
        'comment': comment,
      };
}

class ProductRatingSummaryModel extends ProductRatingSummary {
  const ProductRatingSummaryModel({
    required super.totalReviews,
    required super.averageRating,
    required super.starBreakdown,
  });

  factory ProductRatingSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductRatingSummaryModel(
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      averageRating: double.tryParse(json['average_rating']?.toString() ?? '0') ?? 0.0,
      starBreakdown: {
        5: (json['five_star'] as num?)?.toInt() ?? 0,
        4: (json['four_star'] as num?)?.toInt() ?? 0,
        3: (json['three_star'] as num?)?.toInt() ?? 0,
        2: (json['two_star'] as num?)?.toInt() ?? 0,
        1: (json['one_star'] as num?)?.toInt() ?? 0,
      },
    );
  }

  /// Returns a zero-state summary when no data exists for a product yet.
  factory ProductRatingSummaryModel.empty() {
    return const ProductRatingSummaryModel(
      totalReviews: 0,
      averageRating: 0.0,
      starBreakdown: {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
    );
  }
}
