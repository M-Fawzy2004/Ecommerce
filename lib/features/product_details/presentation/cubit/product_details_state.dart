import 'package:ecommerce_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();
  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetailsEntity product;
  const ProductDetailsLoaded(this.product);
  @override
  List<Object?> get props => [product];
}

class ProductDetailsError extends ProductDetailsState {
  final String message;
  const ProductDetailsError(this.message);
  @override
  List<Object?> get props => [message];
}
