import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/product_details/data/datasources/reviews_remote_data_source.dart';
import 'package:ecommerce_app/features/product_details/domain/entities/product_review_entity.dart';
import 'package:ecommerce_app/features/product_details/domain/repositories/reviews_repository.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsRemoteDataSource _remote;
  final NetworkInfo network;

  ReviewsRepositoryImpl({
    required ReviewsRemoteDataSource remote,
    required this.network,
  }) : _remote = remote;

  @override
  Future<List<ProductReviewEntity>> getReviews({
    required String productId,
    required int from,
    required int limit,
  }) async {
    return _remote.getReviews(productId: productId, from: from, limit: limit);
  }

  @override
  Future<ProductRatingSummary> getRatingSummary(String productId) async {
    return _remote.getRatingSummary(productId);
  }

  @override
  Future<ProductReviewEntity?> getMyReview({
    required String productId,
    required String userId,
  }) async {
    return _remote.getMyReview(productId: productId, userId: userId);
  }

  @override
  Future<void> addReview({
    required String productId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  }) async {
    return _remote.addReview(
      productId: productId,
      userId: userId,
      userName: userName,
      rating: rating,
      comment: comment,
    );
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    return _remote.deleteReview(reviewId);
  }
}
