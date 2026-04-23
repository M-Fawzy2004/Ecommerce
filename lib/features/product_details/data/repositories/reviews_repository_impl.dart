import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/product_details/data/datasources/reviews_remote_data_source.dart';
import 'package:ecommerce_app/features/product_details/domain/entities/product_review_entity.dart';
import 'package:ecommerce_app/features/product_details/domain/repositories/reviews_repository.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsRemoteDataSource _remote;
  final NetworkInfo _network;

  ReviewsRepositoryImpl({
    required ReviewsRemoteDataSource remote,
    required NetworkInfo network,
  })  : _remote = remote,
        _network = network;

  @override
  Future<List<ProductReviewEntity>> getReviews({
    required String productId,
    required int from,
    required int limit,
  }) async {
    if (!await _network.isConnected) {
      throw const NetworkException();
    }
    return _remote.getReviews(productId: productId, from: from, limit: limit);
  }

  @override
  Future<ProductRatingSummary> getRatingSummary(String productId) async {
    if (!await _network.isConnected) throw const NetworkException();
    return _remote.getRatingSummary(productId);
  }

  @override
  Future<ProductReviewEntity?> getMyReview({
    required String productId,
    required String userId,
  }) async {
    if (!await _network.isConnected) throw const NetworkException();
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
    if (!await _network.isConnected) throw const NetworkException();
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
    if (!await _network.isConnected) throw const NetworkException();
    return _remote.deleteReview(reviewId);
  }
}
