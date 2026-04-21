import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'categories_remote_data_source.dart';

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final SupabaseClient supabaseClient;

  CategoriesRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('product_categories')
          .select()
          .order('name', ascending: true);

      return response
          .map((category) => CategoryModel.fromJson(category as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryKey, int from, int to) async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('products')
          .select()
          .eq('category_id', categoryKey)
          .order('created_at', ascending: false)
          .range(from, to);

      return response
          .map((product) => ProductModel.fromJson(product as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
