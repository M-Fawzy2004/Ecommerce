import '../../domain/entities/order_entity.dart';
import 'order_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.orderCode,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.paymentMethod,
    required super.shippingAddress,
    super.latitude,
    super.longitude,
    required super.phone,
    required super.createdAt,
  });

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      orderCode: entity.orderCode,
      userId: entity.userId,
      items: entity.items,
      totalAmount: entity.totalAmount,
      status: entity.status,
      paymentMethod: entity.paymentMethod,
      shippingAddress: entity.shippingAddress,
      latitude: entity.latitude,
      longitude: entity.longitude,
      phone: entity.phone,
      createdAt: entity.createdAt,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderCode: json['order_code'],
      userId: json['user_id'],
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      totalAmount: json['total_amount'].toDouble(),
      status: json['status'],
      paymentMethod: json['payment_method'],
      shippingAddress: json['shipping_address'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      phone: json['phone'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_code': orderCode,
      'user_id': userId,
      'items': items
          .map((item) => OrderItemModel(
                productId: item.productId,
                name: item.name,
                quantity: item.quantity,
                price: item.price,
              ).toJson())
          .toList(),
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'shipping_address': shippingAddress,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
