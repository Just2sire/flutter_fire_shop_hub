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

  int get discount => cartItems.isEmpty
      ? 0
      : (cartItems.fold<num>(
                  0,
                  (prev, item) => prev + item.product.discountPercentage,
                ) /
                cartItems.length)
            .toInt();

  double get discountAmount => double.parse(
    cartItems
        .fold<double>(
          0,
          (prev, item) =>
              prev +
              (item.product.price *
                  item.quantity *
                  item.product.discountPercentage /
                  100),
        )
        .toStringAsFixed(2),
  );

  double get shippingPrice => cartItems.length * 3.5;

  double get totalPrice {
    if (cartItems.isEmpty) {
      return 0.0;
    }

    return double.parse(cartItems.fold(
      0.0,
      (previousValue, element) => previousValue + element.totalPrice,
    ).toStringAsFixed(2));
  }

  double get finalPrice => double.parse(
    (totalPrice - discountAmount + shippingPrice).toStringAsFixed(2),
  );

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
    final updatedCart = await _cartRepository.getCart();
    state = AsyncValue.data(CartProductState(cartItems: updatedCart));
  }

  Future<void> removeFromCart(CartItem item) async {
    await _cartRepository.removeItem(item);
    final updatedCart = await _cartRepository.getCart();
    state = AsyncValue.data(CartProductState(cartItems: updatedCart));
  }

  Future<void> updateCart(CartItem item) async {
    await _cartRepository.updateQuantity(item);
    final updatedCart = await _cartRepository.getCart();
    state = AsyncValue.data(CartProductState(cartItems: updatedCart));
  }

  Future<void> clearCart() async {
    await _cartRepository.clearCart();
    state = const AsyncValue.data(CartProductState());
  }
}
