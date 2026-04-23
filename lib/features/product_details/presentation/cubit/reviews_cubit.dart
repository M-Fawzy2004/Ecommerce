import 'package:ecommerce_app/features/product_details/domain/entities/product_review_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/product_details/domain/usecases/reviews_usecases.dart';
import 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final GetProductReviewsUseCase _getReviews;
  final GetRatingSummaryUseCase _getSummary;
  final GetMyReviewUseCase _getMyReview;
  final AddReviewUseCase _addReview;
  final DeleteReviewUseCase _deleteReview;

  static const int _pageSize = 2;

  ReviewsCubit({
    required GetProductReviewsUseCase getReviews,
    required GetRatingSummaryUseCase getSummary,
    required GetMyReviewUseCase getMyReview,
    required AddReviewUseCase addReview,
    required DeleteReviewUseCase deleteReview,
  })  : _getReviews = getReviews,
        _getSummary = getSummary,
        _getMyReview = getMyReview,
        _addReview = addReview,
        _deleteReview = deleteReview,
        super(const ReviewsInitial());

  // ── Load initial ──────────────────────────────────────────────────────────

  Future<void> loadReviews(String productId, {String? userId}) async {
    emit(const ReviewsLoading());
    try {
      final futures = [
        _getReviews(productId: productId, from: 0, limit: _pageSize),
        _getSummary(productId),
        if (userId != null)
          _getMyReview(productId: productId, userId: userId),
      ];
      final results = await Future.wait(futures);

      final reviews = results[0] as List<ProductReviewEntity>;
      final summary = results[1] as ProductRatingSummary;
      final myReview = userId != null ? results[2] as ProductReviewEntity? : null;

      emit(ReviewsLoaded(
        reviews: reviews,
        summary: summary,
        myReview: myReview,
        hasMore: reviews.length == _pageSize,
      ));
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }

  // ── Load more ──────────────────────────────────────────────────────────────

  Future<void> loadMore(String productId) async {
    final current = state;
    if (current is! ReviewsLoaded || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    try {
      final more = await _getReviews(
        productId: productId,
        from: current.reviews.length,
        limit: _pageSize,
      );
      emit(current.copyWith(
        reviews: [...current.reviews, ...more],
        hasMore: more.length == _pageSize,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  // ── Show fewer ─────────────────────────────────────────────────────────────

  void showLess(String productId) {
    final current = state;
    if (current is! ReviewsLoaded) return;
    emit(current.copyWith(
      reviews: current.reviews.take(_pageSize).toList(),
      hasMore: true,
    ));
  }

  // ── Submit review ──────────────────────────────────────────────────────────

  Future<void> submitReview({
    required String productId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  }) async {
    final current = state;
    if (current is! ReviewsLoaded) return;
    emit(current.copyWith(isSubmitting: true));
    try {
      await _addReview(
        productId: productId,
        userId: userId,
        userName: userName,
        rating: rating,
        comment: comment,
      );
      await loadReviews(productId, userId: userId);
    } catch (e) {
      emit(current.copyWith(isSubmitting: false));
      emit(ReviewsError(e.toString()));
    }
  }

  // ── Delete the current user's review ──────────────────────────────────────

  Future<void> deleteMyReview({
    required String productId,
    required String userId,
  }) async {
    final current = state;
    if (current is! ReviewsLoaded || current.myReview == null) return;
    emit(current.copyWith(isDeleting: true));
    try {
      await _deleteReview(current.myReview!.id);
      await loadReviews(productId, userId: userId);
    } catch (e) {
      emit(current.copyWith(isDeleting: false));
      emit(ReviewsError(e.toString()));
    }
  }
}
