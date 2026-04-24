import 'package:ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;
  final String? promoCode;
  final double discountPercentage;
  final String shippingAddress;
  final double? latitude;
  final double? longitude;
  final String selectedPaymentMethod;

  const CartState({
    this.items = const [],
    this.promoCode,
    this.discountPercentage = 0,
    this.shippingAddress =
        '5482 Adobe Falls Rd #15 San Diego, California(CA), 92120',
    this.latitude = 32.78,
    this.longitude = -117.07,
    this.selectedPaymentMethod = 'mastercard',
  });

  double get subtotal => items
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  double get discountAmount => subtotal * (discountPercentage / 100);

  double get shipping => subtotal > 0 ? 6.0 : 0.0;

  double get total => subtotal - discountAmount + shipping;

  CartState copyWith({
    List<CartItemEntity>? items,
    String? promoCode,
    double? discountPercentage,
    String? shippingAddress,
    double? latitude,
    double? longitude,
    String? selectedPaymentMethod,
  }) {
    return CartState(
      items: items ?? this.items,
      promoCode: promoCode ?? this.promoCode,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }

  @override
  List<Object?> get props => [
    items,
    promoCode,
    discountPercentage,
    shippingAddress,
    latitude,
    longitude,
    selectedPaymentMethod,
  ];

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'promoCode': promoCode,
      'discountPercentage': discountPercentage,
      'shippingAddress': shippingAddress,
      'latitude': latitude,
      'longitude': longitude,
      'selectedPaymentMethod': selectedPaymentMethod,
    };
  }

  factory CartState.fromJson(Map<String, dynamic> json) {
    return CartState(
      items:
          (json['items'] as List?)
              ?.map((e) => CartItemEntity.fromJson(e))
              .toList() ??
          [],
      promoCode: json['promoCode'],
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      shippingAddress:
          json['shippingAddress'] ??
          '5482 Adobe Falls Rd #15 San Diego, California(CA), 92120',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      selectedPaymentMethod: json['selectedPaymentMethod'] ?? 'mastercard',
    );
  }
}
