import 'package:ecommerce_app/features/product_details/domain/entities/product_review_entity.dart';

abstract class ReviewsRepository {
  /// Fetches a page of reviews for [productId].
  Future<List<ProductReviewEntity>> getReviews({
    required String productId,
    required int from,
    required int limit,
  });

  /// Fetches aggregated rating stats for [productId].
  Future<ProductRatingSummary> getRatingSummary(String productId);

  /// Returns the current user's own review, or null if they haven't reviewed.
  Future<ProductReviewEntity?> getMyReview({
    required String productId,
    required String userId,
  });

  /// Submits a new review.
  Future<void> addReview({
    required String productId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  });

  /// Deletes a review by its [reviewId]. Only the owner can delete.
  Future<void> deleteReview(String reviewId);
}
