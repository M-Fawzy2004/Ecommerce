import 'package:ecommerce_app/features/categories/data/models/product_model.dart';
import 'package:ecommerce_app/features/home/data/datasources/recently_viewed_local_data_source.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';

abstract class RecentlyViewedRepository {
  Future<void> addProduct(ProductEntity product);
  Future<List<ProductEntity>> getRecentlyViewed();
}

class RecentlyViewedRepositoryImpl implements RecentlyViewedRepository {
  final RecentlyViewedLocalDataSource _localDataSource;

  RecentlyViewedRepositoryImpl(this._localDataSource);

  @override
  Future<void> addProduct(ProductEntity product) async {
    // Map entity to model for storage
    final model = ProductModel(
      id: product.id,
      name: product.name,
      image: product.image,
      price: product.price,
      oldPrice: product.oldPrice,
      description: product.description,
      hasFreeShipping: product.hasFreeShipping,
      rating: product.rating,
      reviewCount: product.reviewCount,
    );
    await _localDataSource.saveProduct(model);
  }

  @override
  Future<List<ProductEntity>> getRecentlyViewed() async {
    return await _localDataSource.getProducts();
  }
}
