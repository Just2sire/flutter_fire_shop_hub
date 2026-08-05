import "package:shop_hub/data/models/cart_item.dart";
import "package:shop_hub/data/services/local_storage_service.dart";
import "package:shop_hub/domain/repositories/cart_repository.dart";

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({required this._localStorageService});

  final LocalStorageService _localStorageService;

  @override
  Future<bool> addItem(CartItem item) async {
    return _localStorageService.addToCart(item);
  }

  @override
  Future<bool> clearCart() async {
    return _localStorageService.clearCart();
  }

  @override
  Future<List<CartItem>> getCart() async {
    return _localStorageService.getCartItems();
  }

  @override
  Future<bool> removeItem(CartItem item) async {
    return _localStorageService.removeFromCart(item);
  }

  @override
  Future<bool> updateQuantity(CartItem item) {
    return _localStorageService.updateCartItemQuantity(item);
  }

  @override
  Future<bool> toggleCartItem(CartItem item) {
    return _localStorageService.toggleCartItem(item);
  }
}
