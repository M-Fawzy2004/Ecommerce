import 'package:ecommerce_app/features/product_details/domain/entities/product_review_entity.dart';
import '../repositories/reviews_repository.dart';

class GetProductReviewsUseCase {
  final ReviewsRepository _repo;

  const GetProductReviewsUseCase(this._repo);

  Future<List<ProductReviewEntity>> call({
    required String productId,
    required int from,
    int limit = 2,
  }) =>
      _repo.getReviews(productId: productId, from: from, limit: limit);
}

class GetRatingSummaryUseCase {
  final ReviewsRepository _repo;

  const GetRatingSummaryUseCase(this._repo);

  Future<ProductRatingSummary> call(String productId) =>
      _repo.getRatingSummary(productId);
}

class AddReviewUseCase {
  final ReviewsRepository _repo;

  const AddReviewUseCase(this._repo);

  Future<void> call({
    required String productId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  }) =>
      _repo.addReview(
        productId: productId,
        userId: userId,
        userName: userName,
        rating: rating,
        comment: comment,
      );
}

class GetMyReviewUseCase {
  final ReviewsRepository _repo;

  const GetMyReviewUseCase(this._repo);

  Future<ProductReviewEntity?> call({
    required String productId,
    required String userId,
  }) =>
      _repo.getMyReview(productId: productId, userId: userId);
}

class DeleteReviewUseCase {
  final ReviewsRepository _repo;

  const DeleteReviewUseCase(this._repo);

  Future<void> call(String reviewId) => _repo.deleteReview(reviewId);
}
