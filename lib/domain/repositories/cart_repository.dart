import "package:shop_hub/data/models/index.dart" show Product, CartItem;

abstract class CartRepository {
  Future<List<CartItem>> getCart();
  Future<bool> addItem({required Product product, required int quantity});
  Future<bool> removeItem(Product product);
  Future<bool> toggleCartItem(Product product);
  Future<bool> updateQuantity({required Product product, required int quantity});
  Future<bool> clearCart();
}
