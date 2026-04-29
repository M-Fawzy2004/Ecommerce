import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

abstract class SupabaseDataSource {
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> confirmOrder(String orderId);
  Stream<List<OrderModel>> streamOrders(String userId);
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

  @override
  Stream<List<OrderModel>> streamOrders(String userId) {
    final controller = StreamController<List<OrderModel>>();

    // Helper to fetch orders from DB
    Future<void> fetchAndEmit() async {
      try {
        final data = await supabaseClient
            .from('orders')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);
        final orders = (data as List)
            .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
            .toList();
        if (!controller.isClosed) {
          controller.add(orders);
        }
      } catch (e) {
        if (!controller.isClosed) {
          controller.addError(e);
        }
      }
    }

    // Initial fetch
    fetchAndEmit();

    // Listen to ALL changes on the orders table (no filter = no REPLICA IDENTITY dependency)
    final channel = supabaseClient
        .channel('orders_realtime_${DateTime.now().millisecondsSinceEpoch}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'orders',
          callback: (payload) {
            // Any change on the orders table → re-fetch user's orders
            fetchAndEmit();
          },
        )
        .subscribe();

    // Clean up when stream is no longer listened to
    controller.onCancel = () {
      supabaseClient.removeChannel(channel);
      controller.close();
    };

    return controller.stream;
  }
}

