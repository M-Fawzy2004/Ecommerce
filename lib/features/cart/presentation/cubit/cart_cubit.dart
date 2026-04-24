import 'package:ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;
  final String? promoCode;
  final double discountPercentage;

  const CartState({
    this.items = const [],
    this.promoCode,
    this.discountPercentage = 0,
  });

  double get subtotal => items
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  double get discountAmount => subtotal * (discountPercentage / 100);

  double get shipping => subtotal > 0 ? 6.0 : 0.0;

  double get total => subtotal - discountAmount + shipping;

  @override
  List<Object?> get props => [items, promoCode, discountPercentage];

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'promoCode': promoCode,
      'discountPercentage': discountPercentage,
    };
  }

  factory CartState.fromJson(Map<String, dynamic> json) {
    return CartState(
      items: (json['items'] as List)
          .map((e) => CartItemEntity.fromJson(e))
          .toList(),
      promoCode: json['promoCode'],
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
    );
  }
}

class CartCubit extends HydratedCubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(ProductEntity product, {int quantity = 1, String? color}) {
    final index = state.items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      final existingItem = state.items[index];
      final updatedItems = List<CartItemEntity>.from(state.items);
      updatedItems[index] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        selectedColor: color ?? existingItem.selectedColor,
      );
      emit(CartState(
        items: updatedItems,
        promoCode: state.promoCode,
        discountPercentage: state.discountPercentage,
      ));
    } else {
      emit(CartState(
        items: [
          ...state.items,
          CartItemEntity(product: product, quantity: quantity, selectedColor: color),
        ],
        promoCode: state.promoCode,
        discountPercentage: state.discountPercentage,
      ));
    }
  }

  void updateQuantity(String productId, int delta) {
    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        final newQty = (item.quantity + delta).clamp(1, 99);
        return item.copyWith(quantity: newQty);
      }
      return item;
    }).toList();
    emit(CartState(
      items: updatedItems,
      promoCode: state.promoCode,
      discountPercentage: state.discountPercentage,
    ));
  }

  void toggleSelection(String productId) {
    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(isSelected: !item.isSelected);
      }
      return item;
    }).toList();
    emit(CartState(
      items: updatedItems,
      promoCode: state.promoCode,
      discountPercentage: state.discountPercentage,
    ));
  }

  void removeItem(String productId) {
    final updatedItems = state.items.where((i) => i.product.id != productId).toList();
    emit(CartState(
      items: updatedItems,
      promoCode: state.promoCode,
      discountPercentage: state.discountPercentage,
    ));
  }

  void applyPromoCode(String code) {
    if (code == 'MOFAWZY12') {
      emit(CartState(
        items: state.items,
        promoCode: code,
        discountPercentage: 10,
      ));
    } else {
      emit(CartState(
        items: state.items,
        promoCode: null,
        discountPercentage: 0,
      ));
    }
  }

  @override
  CartState? fromJson(Map<String, dynamic> json) => CartState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(CartState state) => state.toJson();
}
