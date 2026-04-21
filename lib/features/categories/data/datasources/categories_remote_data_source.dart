import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProductsByCategory(String categoryKey, int from, int to);
}
