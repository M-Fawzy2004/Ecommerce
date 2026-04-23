import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/product_details/data/models/product_review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ReviewsRemoteDataSource {
  Future<List<ProductReviewModel>> getReviews({
    required String productId,
    required int from,
    required int limit,
  });

  Future<ProductRatingSummaryModel> getRatingSummary(String productId);

  Future<ProductReviewModel?> getMyReview({
    required String productId,
    required String userId,
  });

  Future<void> addReview({
    required String productId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  });

  Future<void> deleteReview(String reviewId);
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final SupabaseClient _client;

  ReviewsRemoteDataSourceImpl(this._client);

  @override
  Future<List<ProductReviewModel>> getReviews({
    required String productId,
    required int from,
    required int limit,
  }) async {
    try {
      final to = from + limit - 1;
      final response = await _client
          .from('product_reviews')
          .select()
          .eq('product_id', productId)
          .order('created_at', ascending: false)
          .range(from, to);

      return (response as List)
          .map((e) => ProductReviewModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductRatingSummaryModel> getRatingSummary(String productId) async {
    try {
      final response = await _client
          .from('product_rating_summary')
          .select()
          .eq('product_id', productId)
          .maybeSingle();

      if (response == null) return ProductRatingSummaryModel.empty();
      return ProductRatingSummaryModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductReviewModel?> getMyReview({
    required String productId,
    required String userId,
  }) async {
    try {
      final response = await _client
          .from('product_reviews')
          .select()
          .eq('product_id', productId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;
      return ProductReviewModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addReview({
    required String productId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  }) async {
    try {
      await _client.from('product_reviews').insert({
        'product_id': productId,
        'user_id': userId,
        'user_name': userName,
        'rating': rating,
        'comment': comment,
      });
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      await _client
          .from('product_reviews')
          .delete()
          .eq('id', reviewId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
