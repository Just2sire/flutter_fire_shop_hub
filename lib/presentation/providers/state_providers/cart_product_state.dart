import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shop_hub/data/models/index.dart" show CartItem;
import "package:shop_hub/domain/repositories/cart_repository.dart";
import "package:shop_hub/presentation/providers/cart_providers.dart";

class CartProductState {
  const CartProductState({this.cartItems = const []});

  final List<CartItem> cartItems;

  CartProductState copyWith({List<CartItem>? cartItems}) {
    return CartProductState(cartItems: cartItems ?? this.cartItems);
  }

  @override
  String toString() {
    return "CartProductState(cartItems: $cartItems)";
  }
}

class CartProductNotifier extends AsyncNotifier<CartProductState> {
  late final CartRepository _cartRepository;

  @override
  Future<CartProductState> build() async {
    _cartRepository = ref.watch(cartRepositoryProvider);
    return await loadItems();
  }

  Future<CartProductState> loadItems() async {
    final result = await _cartRepository.getCart();
    return CartProductState(cartItems: result);
  }

  Future<void> addToCart(CartItem item) async {
    await _cartRepository.addItem(item);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(loadItems);
  }

  Future<void> removeFromCart(CartItem item) async {
    await _cartRepository.removeItem(item);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(loadItems);
  }

  Future<void> updateCart(CartItem item) async {
    await _cartRepository.updateQuantity(item);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(loadItems);
  }

  Future<void> clearCart() async {
    await _cartRepository.clearCart();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(loadItems);
  }
}
