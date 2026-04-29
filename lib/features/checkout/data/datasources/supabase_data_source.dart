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
    List<OrderModel> localOrders = [];

    void emitCopy() {
      if (!controller.isClosed) {
        controller.add(List<OrderModel>.from(localOrders));
      }
    }

    // Initial fetch from DB (one-time only)
    Future<void> initialFetch() async {
      try {
        final data = await supabaseClient
            .from('orders')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);
        localOrders = (data as List)
            .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
            .toList();
        emitCopy();
      } catch (e) {
        if (!controller.isClosed) controller.addError(e);
      }
    }

    initialFetch();

    // Listen to ALL changes — use payload directly, no re-fetch
    final channel = supabaseClient
        .channel('orders_rt_${userId.hashCode}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'orders',
          callback: (payload) {
            final newRecord = payload.newRecord;
            if (newRecord['user_id'] != userId) return;
            try {
              final order = OrderModel.fromJson(newRecord);
              localOrders.insert(0, order);
              emitCopy();
            } catch (_) {}
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'orders',
          callback: (payload) {
            final newRecord = payload.newRecord;
            final orderId = newRecord['id']?.toString();
            if (orderId == null) return;
            final index = localOrders.indexWhere((o) => o.id == orderId);
            if (index == -1) return;
            try {
              localOrders[index] = OrderModel.fromJson(newRecord);
              emitCopy();
            } catch (_) {}
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'orders',
          callback: (payload) {
            final oldRecord = payload.oldRecord;
            final orderId = oldRecord['id']?.toString();
            if (orderId == null) return;
            localOrders.removeWhere((o) => o.id == orderId);
            emitCopy();
          },
        )
        .subscribe();

    controller.onCancel = () {
      supabaseClient.removeChannel(channel);
      controller.close();
    };

    return controller.stream;
  }
}
