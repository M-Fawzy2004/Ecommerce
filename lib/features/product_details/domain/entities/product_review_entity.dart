import 'package:equatable/equatable.dart';

/// A single user review for a product.
class ProductReviewEntity extends Equatable {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ProductReviewEntity({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, productId, userId, userName, rating, comment, createdAt];
}

/// Aggregated rating statistics for a product.
class ProductRatingSummary extends Equatable {
  final int totalReviews;
  final double averageRating;
  final Map<int, int> starBreakdown; // {5: 12, 4: 8, 3: 3, 2: 1, 1: 0}

  const ProductRatingSummary({
    required this.totalReviews,
    required this.averageRating,
    required this.starBreakdown,
  });

  double percentageFor(int star) {
    if (totalReviews == 0) return 0;
    return (starBreakdown[star] ?? 0) / totalReviews;
  }

  @override
  List<Object?> get props => [totalReviews, averageRating, starBreakdown];
}
