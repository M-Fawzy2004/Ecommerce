import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;
  final bool isSelected;
  final String? selectedColor;

  const CartItemEntity({
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
    this.selectedColor,
  });

  CartItemEntity copyWith({
    ProductEntity? product,
    int? quantity,
    bool? isSelected,
    String? selectedColor,
  }) {
    return CartItemEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  @override
  List<Object?> get props => [product, quantity, isSelected, selectedColor];

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'isSelected': isSelected,
      'selectedColor': selectedColor,
    };
  }

  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      product: ProductEntity.fromJson(json['product']),
      quantity: json['quantity'],
      isSelected: json['isSelected'] ?? true,
      selectedColor: json['selectedColor'],
    );
  }
}
