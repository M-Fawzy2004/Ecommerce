import 'dart:convert';
import 'package:ecommerce_app/features/categories/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RecentlyViewedLocalDataSource {
  Future<void> saveProduct(ProductModel product);
  Future<List<ProductModel>> getProducts();
}

class RecentlyViewedLocalDataSourceImpl implements RecentlyViewedLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _key = 'recently_viewed_products';
  static const int _maxItems = 10;

  RecentlyViewedLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<ProductModel>> getProducts() async {
    final jsonList = sharedPreferences.getStringList(_key);
    if (jsonList == null) return [];
    
    return jsonList
        .map((item) => ProductModel.fromJson(json.decode(item) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveProduct(ProductModel product) async {
    final products = await getProducts();
    
    // Remove if already exists to move to top
    products.removeWhere((p) => p.id == product.id);
    
    // Add to top
    products.insert(0, product);
    
    // Trim if exceeds limit
    if (products.length > _maxItems) {
      products.removeRange(_maxItems, products.length);
    }
    
    final jsonList = products
        .map((p) => json.encode(p.toJson()))
        .toList();
        
    await sharedPreferences.setStringList(_key, jsonList);
  }
}
