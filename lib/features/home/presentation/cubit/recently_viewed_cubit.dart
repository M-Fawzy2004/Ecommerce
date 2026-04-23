import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/home/data/repositories/recently_viewed_repository_impl.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RecentlyViewedState extends Equatable {
  const RecentlyViewedState();
  @override
  List<Object?> get props => [];
}

class RecentlyViewedInitial extends RecentlyViewedState {}

class RecentlyViewedLoaded extends RecentlyViewedState {
  final List<ProductEntity> products;
  const RecentlyViewedLoaded(this.products);
  @override
  List<Object?> get props => [products];
}

class RecentlyViewedCubit extends Cubit<RecentlyViewedState> {
  final RecentlyViewedRepository _repository;

  RecentlyViewedCubit(this._repository) : super(RecentlyViewedInitial());

  Future<void> loadProducts() async {
    final products = await _repository.getRecentlyViewed();
    emit(RecentlyViewedLoaded(products));
  }

  Future<void> addProduct(ProductEntity product) async {
    await _repository.addProduct(product);
    // Reload state after adding
    await loadProducts();
  }
}
