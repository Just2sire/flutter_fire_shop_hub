import "package:shop_hub/data/models/index.dart" show CartItem;

abstract class CartRepository {
  Future<List<CartItem>> getCart();
  Future<bool> addItem(CartItem item);
  Future<bool> removeItem(CartItem item);
  Future<bool> toggleCartItem(CartItem item);
  Future<bool> updateQuantity(CartItem item);
  Future<bool> clearCart();
}
