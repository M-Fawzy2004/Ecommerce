import 'package:ecommerce_app/features/categories/data/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecommerce_app/core/network/api_error_handler.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getHotSales(int from, int to);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient supabaseClient;

  HomeRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<ProductModel>> getHotSales(int from, int to) async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('products')
          .select('*')
          .eq('is_featured', true)
          .order('created_at', ascending: false)
          .range(from, to);

      return response
          .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      ApiErrorHandler.handle(e);
    }
  }
}
