import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryDetailsState extends Equatable {
  const CategoryDetailsState();

  @override
  List<Object?> get props => [];
}

class CategoryDetailsInitial extends CategoryDetailsState {}

class CategoryDetailsLoading extends CategoryDetailsState {}

class CategoryDetailsLoaded extends CategoryDetailsState {
  final List<ProductEntity> products;
  final bool isPaginationLoading;
  final bool hasReachedMax;
  final String? paginationError;

  const CategoryDetailsLoaded({
    required this.products,
    this.isPaginationLoading = false,
    this.hasReachedMax = false,
    this.paginationError,
  });

  CategoryDetailsLoaded copyWith({
    List<ProductEntity>? products,
    bool? isPaginationLoading,
    bool? hasReachedMax,
    String? paginationError,
  }) {
    return CategoryDetailsLoaded(
      products: products ?? this.products,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      paginationError: paginationError,
    );
  }

  @override
  List<Object?> get props => [products, isPaginationLoading, hasReachedMax, paginationError];
}

class CategoryDetailsError extends CategoryDetailsState {
  final String message;

  const CategoryDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
