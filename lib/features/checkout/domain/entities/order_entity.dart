import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final String orderCode;
  final String userId;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String status; // pending, confirmed, failed
  final String paymentMethod;
  final String shippingAddress;
  final double? latitude;
  final double? longitude;
  final String phone;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.orderCode,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
    this.latitude,
    this.longitude,
    required this.phone,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderCode,
        userId,
        items,
        totalAmount,
        status,
        paymentMethod,
        shippingAddress,
        latitude,
        longitude,
        phone,
        createdAt,
      ];
}
