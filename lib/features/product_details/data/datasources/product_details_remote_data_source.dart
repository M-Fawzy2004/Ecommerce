import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_details_model.dart';
import 'package:ecommerce_app/core/network/api_error_handler.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<ProductDetailsModel> getProductDetails(String productId);
}

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProductDetailsRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<ProductDetailsModel> getProductDetails(String productId) async {
    try {
      final response = await supabaseClient
          .from('products')
          .select('*, product_images(*), product_color_stocks(*)')
          .eq('id', productId)
          .single();

      return ProductDetailsModel.fromJson(response);
    } catch (e) {
      ApiErrorHandler.handle(e);
    }
  }
}
