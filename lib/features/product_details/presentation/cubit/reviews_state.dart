import 'package:equatable/equatable.dart';
import 'package:ecommerce_app/features/product_details/domain/entities/product_review_entity.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();
  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {
  const ReviewsInitial();
}

class ReviewsLoading extends ReviewsState {
  const ReviewsLoading();
}

class ReviewsLoaded extends ReviewsState {
  final List<ProductReviewEntity> reviews;
  final ProductRatingSummary summary;

  /// The current logged-in user's review, null if they haven't reviewed yet.
  final ProductReviewEntity? myReview;

  final bool hasMore;
  final bool isLoadingMore;
  final bool isSubmitting;
  final bool isDeleting;

  const ReviewsLoaded({
    required this.reviews,
    required this.summary,
    this.myReview,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isSubmitting = false,
    this.isDeleting = false,
  });

  ReviewsLoaded copyWith({
    List<ProductReviewEntity>? reviews,
    ProductRatingSummary? summary,
    ProductReviewEntity? myReview,
    bool clearMyReview = false,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isSubmitting,
    bool? isDeleting,
  }) {
    return ReviewsLoaded(
      reviews: reviews ?? this.reviews,
      summary: summary ?? this.summary,
      myReview: clearMyReview ? null : (myReview ?? this.myReview),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  List<Object?> get props =>
      [reviews, summary, myReview, hasMore, isLoadingMore, isSubmitting, isDeleting];
}

class ReviewsError extends ReviewsState {
  final String message;
  const ReviewsError(this.message);
  @override
  List<Object?> get props => [message];
}
