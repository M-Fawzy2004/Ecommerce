import 'package:ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'cart_state.dart';

export 'cart_state.dart';

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
      emit(state.copyWith(items: updatedItems));
    } else {
      emit(
        state.copyWith(
          items: [
            ...state.items,
            CartItemEntity(
              product: product,
              quantity: quantity,
              selectedColor: color,
            ),
          ],
        ),
      );
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
    emit(state.copyWith(items: updatedItems));
  }

  void toggleSelection(String productId) {
    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(isSelected: !item.isSelected);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void removeItem(String productId) {
    final updatedItems = state.items
        .where((i) => i.product.id != productId)
        .toList();
    emit(state.copyWith(items: updatedItems));
  }

  void applyPromoCode(String code) {
    if (code == 'MOFAWZY12') {
      emit(state.copyWith(promoCode: code, discountPercentage: 10));
    } else {
      emit(state.copyWith(promoCode: null, discountPercentage: 0));
    }
  }

  void updatePaymentMethod(String method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }

  void clearPromoCode() {
    emit(state.copyWith(promoCode: null, discountPercentage: 0));
  }

  void updateAddress({double? lat, double? lng, String? address}) {
    emit(
      state.copyWith(latitude: lat, longitude: lng, shippingAddress: address),
    );
  }

  @override
  CartState? fromJson(Map<String, dynamic> json) => CartState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(CartState state) => state.toJson();
}
