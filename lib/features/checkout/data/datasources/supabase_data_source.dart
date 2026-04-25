import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

abstract class SupabaseDataSource {
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> confirmOrder(String orderId);
}

class SupabaseDataSourceImpl implements SupabaseDataSource {
  final SupabaseClient supabaseClient;

  SupabaseDataSourceImpl(this.supabaseClient);

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final response = await supabaseClient
        .from('orders')
        .insert(order.toJson())
        .select()
        .single();
    return OrderModel.fromJson(response);
  }

  @override
  Future<OrderModel> confirmOrder(String orderId) async {
    final response = await supabaseClient
        .from('orders')
        .update({'status': 'confirmed'})
        .eq('id', orderId)
        .select()
        .single();
    return OrderModel.fromJson(response);
  }
}
