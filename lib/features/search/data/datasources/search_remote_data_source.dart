import 'package:ecommerce_app/features/categories/data/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SearchRemoteDataSource {
  Future<List<ProductModel>> searchProducts(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final SupabaseClient supabaseClient;

  SearchRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await supabaseClient
        .from('products')
        .select('*')
        .ilike('name', '%$query%')
        .order('name');

    return (response as List).map((json) => ProductModel.fromJson(json)).toList();
  }
}
